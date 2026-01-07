# API Reference

## Services

### UserService

- `register_user(user_id: int) -> UserOrm`
- `get_user(user_id: int) -> UserOrm | None`
- `update_user(user_id: int, data: dict[str, Any]) -> UserOrm | None`
- `delete_user(user_id: int) -> None`

### CacheService

- `get_user_language(user_id: int) -> str | None`
- `set_user_language(user_id: int, lang: str, ttl: int = 3600) -> None`
- `invalidate_user_language(user_id: int) -> None`

## Repositories

### UserRepository

- `add(data: dict[str, Any]) -> UserOrm`
- `get(user_id: int) -> UserOrm | None`
- `update(user_id: int, data: dict[str, Any]) -> UserOrm | None`
- `delete(**filters: Any) -> None`
- `get_by_filters(**filters: Any) -> UserOrm | None`
- `list_by_filters(**filters: Any) -> Sequence[UserOrm]`
