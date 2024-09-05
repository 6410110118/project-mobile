import math
from fastapi import APIRouter, HTTPException, Depends , status
from typing import Optional, List, Annotated
from sqlalchemy import func
from sqlmodel import Field, SQLModel, select

from .. import models
from .. import deps
from sqlmodel.ext.asyncio.session import AsyncSession
from datetime import datetime, timedelta


router = APIRouter(prefix="/items")

@router.post("")
async def create_item(
    item: models.CreatedItem,
    google_map_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.Item | None:
    # ตรวจสอบสิทธิ์ของ current_user
    if  current_user != current_user:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You is not current user."
        )
    
    # ตรวจสอบและตั้งค่า end_date หากไม่ได้กำหนด
    if not item.end_date:
        item.end_date = item.start_date + timedelta(days=5)
    elif item.end_date < item.start_date:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="End date cannot be earlier than start date"
        )
    
    
    
    
    # สร้างไอเท็ม
    dbitem = models.DBItem.from_orm(item)
    dbitem.user_id = current_user.id
    dbitem.role = current_user.role
    dbitem.google_map_id = google_map_id
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