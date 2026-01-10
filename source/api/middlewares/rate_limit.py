import time
from collections import defaultdict
from typing import Callable

from fastapi import Request
from fastapi import Response
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware


class RateLimitMiddleware(BaseHTTPMiddleware):
    """
    Simple in-memory rate limiting middleware.

    For production with multiple instances, use Redis-based rate limiting.
    """

    def __init__(
        self,
        app,
        requests_per_minute: int = 100,
        cleanup_interval: int = 300,
    ):
        super().__init__(app)
        self.requests_per_minute = requests_per_minute
        self.cleanup_interval = cleanup_interval
        self.request_counts: dict[str, list[float]] = defaultdict(list)
        self.last_cleanup = time.time()

    def _cleanup_old_requests(self) -> None:
        current_time = time.time()
        if current_time - self.last_cleanup < self.cleanup_interval:
            return

        cutoff = current_time - 60
        for client_id in list(self.request_counts.keys()):
            self.request_counts[client_id] = [
                ts for ts in self.request_counts[client_id] if ts > cutoff
            ]
            if not self.request_counts[client_id]:
                del self.request_counts[client_id]

        self.last_cleanup = current_time

    def _get_client_id(self, request: Request) -> str:
        forwarded = request.headers.get("X-Forwarded-For")
        if forwarded:
            return forwarded.split(",")[0].strip()

        if request.client:
            return request.client.host

        return "unknown"

    async def dispatch(self, request: Request, call_next: Callable) -> Response:
        if request.url.path in ("/health", "/api/health"):
            return await call_next(request)

        self._cleanup_old_requests()

        client_id = self._get_client_id(request)
        current_time = time.time()
        cutoff = current_time - 60

        recent_requests = [
            ts for ts in self.request_counts[client_id] if ts > cutoff
        ]

        if len(recent_requests) >= self.requests_per_minute:
            return JSONResponse(
                status_code=429,
                content={
                    "error": "Too many requests",
                    "detail": (
                        f"Rate limit: {self.requests_per_minute} requests per minute"
                    ),
                    "retry_after": 60,
                },
                headers={"Retry-After": "60"},
            )

        self.request_counts[client_id].append(current_time)

        return await call_next(request)
