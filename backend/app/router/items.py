import math
from fastapi import APIRouter, HTTPException, Depends , status
from typing import Optional, List, Annotated
from sqlalchemy import func
from sqlmodel import Field, SQLModel, select

from .. import models
from .. import deps
from sqlmodel.ext.asyncio.session import AsyncSession

router = APIRouter(prefix="/items")

@router.post("")
async def create_item(
    item: models.CreatedItem,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.Item | None:
    # Check if the current user is a merchant
       
    if  current_user != current_user:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only user can create items."
        )

    # statement = select(models.DBUser).where(models.DBUser.id == current_user.id)
    # result = await session.exec(statement)
    # dbuser = result.one_or_none()


    # Create the item
    dbitem = models.DBItem.from_orm(item)
    dbitem.user_id = current_user.id

    session.add(dbitem)
    await session.commit()
    await session.refresh(dbitem)

    return models.Item.from_orm(dbitem)

# SIZE_PER_PAGE = 50


# @router.get("")
# async def read_items(
#     session: Annotated[AsyncSession, Depends(models.get_session)],
#     current_user: models.User = Depends(deps.get_current_user),
#     page: int = 1,
# ) -> models.ItemList:

#     result = await session.exec(
#         select(models.DBItem).offset((page - 1) * SIZE_PER_PAGE).limit(SIZE_PER_PAGE)
#     )
#     items = result.all()

#     page_count = int(
#         math.ceil(
#             (await session.exec(select(func.count(models.DBItem.id)))).first()
#             / SIZE_PER_PAGE
#         )
#     )

#     print("page_count", page_count)
#     print("items", items)
#     return models.ItemList.from_orm(
#         dict(items=items, page_count=page_count, page=page, size_per_page=SIZE_PER_PAGE)
#     )