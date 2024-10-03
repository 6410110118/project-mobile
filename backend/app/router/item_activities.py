
import math
from fastapi import APIRouter, HTTPException, Depends , status
from typing import Optional, List, Annotated
from sqlalchemy import func
from sqlmodel import Field, SQLModel, select

from .. import models
from .. import deps
from sqlmodel.ext.asyncio.session import AsyncSession

router = APIRouter(prefix="/items-activities")

SIZE_PER_PAGE = 50
@router.get("")
async def read_items(
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
    page: int = 1,
) -> models.ItemList:

    result = await session.exec(
        select(models.DBItem).offset((page - 1) * SIZE_PER_PAGE).limit(SIZE_PER_PAGE)
    )
    items = result.all()

    page_count = int(
        math.ceil(
            (await session.exec(select(func.count(models.DBItem.id)))).first()
            / SIZE_PER_PAGE
        )
    )

    print("page_count", page_count)
    print("items", items)
    return models.ItemList.from_orm(
        dict(items=items, page_count=page_count, page=page, size_per_page=SIZE_PER_PAGE)
    )

@router.get("/{page_size}/")
async def read_items(
    page_size : int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
    page: int = 1,
) -> models.ItemList:

    result = await session.exec(
        select(models.DBItem).offset((page - 1) * page_size).limit(page_size)
    )
    items = result.all()

    page_count = int(
        math.ceil(
            (await session.exec(select(func.count(models.DBItem.id)))).first()
            / page_size
        )
    )

    print("page_count", page_count)
    print("items", items)
    return models.ItemList.from_orm(
        dict(items=items, page_count=page_count, page=page, size_per_page=SIZE_PER_PAGE,page_size=page_size)
    )

@router.put("/{item_id}")
async def update_item(
    item_id: int, 
    item: models.UpdatedItem, 
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
    ) -> models.Item:
    result = await session.exec(
        select(models.DBItem).where(models.DBItem.id == item_id)
    )
    db_item = result.one_or_none()

    if  current_user.role != 'Leader':
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You is not Leader."
        )
    if  db_item:
        db_item.sqlmodel_update(item)
        session.add(db_item)
        await session.commit()
        await session.refresh(db_item)
        return models.Item.from_orm(db_item)
    raise HTTPException(status_code=404, detail="Item not found")

@router.delete("/{item_id}")
async def delete_item(
    item_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
    ) -> dict:
    result = await session.exec(
        select(models.DBItem).where(models.DBItem.id == item_id)
    )
    db_item = result.one_or_none()
    if  current_user.role != 'Leader':
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You is not Leader."
        )
    if db_item:
        await session.delete(db_item)
        await session.commit()
        
        return dict(message="delete success")
    raise HTTPException(status_code=404, detail="Item not found")
