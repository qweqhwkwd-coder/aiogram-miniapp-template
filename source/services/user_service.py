from collections.abc import Sequence
from typing import Any

from source.database import AbstractUnitOfWork
from source.database import UserOrm


class UserService:
    def __init__(self, uow: AbstractUnitOfWork):
        self._uow = uow

    async def register_user(
        self,
        user_id: int,
    ) -> UserOrm:
        async with self._uow:
            user_data = {
                "user_id": user_id,
            }

            user = await self._uow.users.get(user_id)

            if not user:
                try:
                    user = await self._uow.users.add(user_data)
                except ValueError:
                    await self._uow.rollback()
                    user = await self._uow.users.get(user_id)

            return user

    async def add_user(self, data: dict[str, Any]) -> UserOrm:
        async with self._uow:
            user = await self._uow.users.add(data)
            return user

    async def get_user(self, user_id: int) -> UserOrm | None:
        async with self._uow:
            user = await self._uow.users.get(user_id)
            return user

    async def update_user(self, user_id: int, data: dict[str, Any]) -> UserOrm | None:
        async with self._uow:
            updated_user = await self._uow.users.update(user_id, data)
            return updated_user

    async def delete_user(self, user_id: int) -> None:
        async with self._uow:
            await self._uow.users.delete(user_id=user_id)

    async def add_user_by_filters(self, data: dict[str, Any]) -> UserOrm:
        return await self.add_user(data)

    async def get_user_by_filters(self, **filters: Any) -> UserOrm | None:
        async with self._uow:
            return await self._uow.users.get_by_filters(**filters)

    async def update_users_by_filters(
        self,
        filters: dict[str, Any],
        data: dict[str, Any],
    ) -> Sequence[UserOrm]:
        async with self._uow:
            updated_users = await self._uow.users.update_by_filters(filters, data)
            return updated_users

    async def delete_users_by_filters(self, **filters: Any) -> None:
        async with self._uow:
            await self._uow.users.delete_by_filters(**filters)

    async def list_users_by_filters(self, **filters: Any) -> Sequence[UserOrm]:
        async with self._uow:
            users = await self._uow.users.list_by_filters(**filters)
            return users
