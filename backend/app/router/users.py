
from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated

from .. import deps
from .. import models
import math
from sqlalchemy import func


router = APIRouter(prefix="/users", tags=["users"])


@router.get("/me")
def get_me( session: Annotated[AsyncSession, Depends(models.get_session)],current_user: models.User = Depends(deps.get_current_user)) -> models.User:
    
        return current_user 


SIZE_PER_PAGE = 50
@router.get("")
async def read_user(
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
    page: int = 1,
    
) -> models.UserList:
    query = select(models.DBUser).where(models.DBUser.id != current_user.id)
    result = await session.exec(
        query.offset((page - 1) * SIZE_PER_PAGE).limit(SIZE_PER_PAGE)
    )
    users = result.all() or []
    
    
    

    page_count = int(
        math.ceil(
            (await session.exec(select(func.count(models.DBUser.id)))).first()
            / SIZE_PER_PAGE
        )
    )

    print("page_count", page_count)
    print("users", users)
    return models.UserList.from_orm(
        dict(users=users, page_count=page_count, page=page, size_per_page=SIZE_PER_PAGE)
    )


@router.post("/register_leader")
async def register_leader(
    user_info: models.RegisteredUser,
    leader_info: models.CreatedLeader,
    session: Annotated[AsyncSession, Depends(models.get_session)],
) -> models.Leader:

   
    user_result = await session.execute(
        select(models.DBUser).where(models.DBUser.username == user_info.username)
    )

    user = user_result.scalar_one_or_none()

    if user:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="This leader already exists.",
        )

    
    user = models.DBUser.from_orm(user_info)
    await user.set_password(user_info.password)
    user.role = models.UserRole.leader
    
    session.add(user)

    
    dbleader= models.DBLeader(**leader_info.dict())
   
    dbleader= models.DBLeader.model_validate(leader_info)
    dbleader.user = user

    session.add(dbleader)
    await session.commit()
    
    await session.refresh(user)
    await session.refresh(dbleader)


    return models.Leader.from_orm(dbleader)

@router.post("/register_people")
async def register_people(
    user_info: models.RegisteredUser,
    people_info: models.CreatedPeople,
    session: Annotated[AsyncSession, Depends(models.get_session)],
) -> models.People:
    # check username
    user_result = await session.execute(
        select(models.DBUser).where(models.DBUser.username == user_info.username)
    )

    people = user_result.scalar_one_or_none()

    if people:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="This people already exists.",
        )

    # create new user
    user = models.DBUser.from_orm(user_info)
    await user.set_password(user_info.password)
    user.role = models.UserRole.people
    
    session.add(user)

    # create new customer
    dbpeople = models.DBPeople(**people_info.dict())
    dbpeople.user = user

    # Add people to the session first
    session.add(dbpeople)

    # Commit to generate IDs
    await session.commit()

    # Refresh the people to get the ID
   
    
    return models.People.from_orm(dbpeople)


@router.put("/{user_id}/change_password")
async def change_password(
    # request: Request,
    
    password_update: models.ChangedPassword,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.User:

    result = await session.exec(
        select(models.DBUser).where(models.DBUser.id == current_user.id)
    )
    db_user = result.one_or_none()

    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Not found this user",
        )

    if not await db_user.verify_password(password_update.current_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect password",
        )
    
    await db_user.set_password(password_update.new_password)
    session.add(db_user)
    await session.commit()
    await session.refresh(db_user)

    raise HTTPException(
            status_code=status.HTTP_200_OK,
            detail="Change password successfully",
        )

@router.put("/update")
async def update(
    request: Request,
    user_update: models.UpdatedUser,
    # password_update: models.ChangedPassword,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.User:

    result = await session.exec(
        select(models.DBUser).where(models.DBUser.id == current_user.id)
    )
    db_user = result.one_or_none()

    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Not found this user",
        )

    # if not await db_user.verify_password(password_update.current_password):
    #     raise HTTPException(
    #         status_code=status.HTTP_401_UNAUTHORIZED,
            
    #         detail="Incorrect password",
        # )
    if db_user:
        db_user.sqlmodel_update(user_update)
        # await db_user.set_password(password_update.new_password)
        session.add(db_user)
        await session.commit()
        await session.refresh(db_user)


        return db_user

   
# @router.put("/{user_id}/update")
# async def update(
#     request: Request,
#     user_id: str,
#     user_update: models.UpdatedUser,
#     session: Annotated[AsyncSession, Depends(models.get_session)],
#     current_user: models.User = Depends(deps.get_current_user),
# ) -> models.User:

#     user = await session.get(models.DBUser, user_id)

#     if user:
#         raise HTTPException(
#             status_code=status.HTTP_404_NOT_FOUND,
#             detail="Not found this user",
#         )

#     if not user.verify_password(password_update.current_password):
#         raise HTTPException(
#             status_code=status.HTTP_401_UNAUTHORIZED,
#             detail="Incorrect password",
#         )

#     user.update(**set_dict)
#     session.add(user)
#     await session.commit()
#     await session.refresh(user)

#     return user

@router.delete("/{user_id}")
async def delete_user(
   
    current_user: Annotated[models.User, Depends(deps.get_current_user)],
    session: Annotated[AsyncSession, Depends(models.get_session)],
) -> dict:
    result = await session.exec(
        select(models.DBUser).where(models.DBUser.id == current_user.id)
    )
    db_user = result.one_or_none()
    if db_user:
        await session.delete(db_user)
        await session.commit()


        return dict(message="delete success")
    raise HTTPException(status_code=404, detail="user not found")