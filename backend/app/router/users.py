
from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated

from .. import deps
from .. import models




router = APIRouter(prefix="/users", tags=["users"])


@router.get("/me")
def get_me(current_user: models.User = Depends(deps.get_current_user)) -> models.User:
    return current_user


# @router.get("/{user_id}")
# async def get_user(
#     user_id: str,
#     session: Annotated[AsyncSession, Depends(models.get_session)],
#     current_user: Annotated[models.User, Depends(deps.get_current_user)],
# ) -> models.User:
#     # Check if the current user is requesting their own information
#     if user_id == str(current_user.id):
#         return current_user
    
#     # If not, check if the current user has permission to view other users
#     if not current_user.is_admin:  # Assuming there's an is_admin field
#         raise HTTPException(
#             status_code=status.HTTP_403_FORBIDDEN,
#             detail="Not authorized to view other users' information",
#         )
    
#     # If the current user is an admin, proceed to fetch the requested user
#     user = await session.get(models.User, user_id)
    
#     if not user:
#         raise HTTPException(
#             status_code=status.HTTP_404_NOT_FOUND,
#             detail="User not found",
#         )
    
#     return user


@router.post("/create")
async def create(
    user_info: models.RegisteredUser,
    session: Annotated[AsyncSession, Depends(models.get_session)],
) -> models.User:

    result = await session.exec(
        select(models.DBUser).where(models.DBUser.username == user_info.username)
    )

    user = result.one_or_none()

    if user:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="This username is exists.",
        )

    user = models.DBUser.from_orm(user_info)
    await user.set_password(user_info.password)
    session.add(user)
    await session.commit()

    return user


@router.put("/{user_id}/change_password")
async def change_password(
    user_id: str,
    password_update: models.ChangedPassword,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> dict:

    user = await session.get(models.DBUser, user_id)

    if user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Not found this user",
        )

    if not user.verify_password(password_update.current_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect password",
        )

    user.set_password(password_update.new_password)
    session.add(user)
    await session.commit()


@router.put("/{user_id}/update")
async def update(
    request: Request,
    user_id: str,
    user_update: models.UpdatedUser,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.User:

    user = await session.get(models.DBUser, user_id)

    if user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Not found this user",
        )

    if not user.verify_password(password_update.current_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect password",
        )

    user.update(**set_dict)
    session.add(user)
    await session.commit()
    await session.refresh(user)

    return user

@router.delete("/{user_id}")
async def delete_user(
    user_id: int,
    current_user: Annotated[models.User, Depends(deps.get_current_user)],
    session: Annotated[AsyncSession, Depends(models.get_session)],
) -> dict:
    db_user = await session.get(models.DBUser, user_id)
    if db_user:
        await session.delete(db_user)
        await session.commit()


        return dict(message="delete success")
    raise HTTPException(status_code=404, detail="user not found")