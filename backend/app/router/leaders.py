from fastapi import APIRouter, HTTPException, Depends

from typing import Optional, Annotated
from sqlmodel import Field, SQLModel, create_engine, Session, select
from sqlmodel.ext.asyncio.session import AsyncSession

from ..models.users import User

from ..models import (
    Leader,
    CreatedLeader,
    UpdatedLeader,
    LeaderList,
    DBLeader,
    engine,
    get_session,
)

router = APIRouter(prefix="/leaders")


from .. import deps

# @router.post("")
# async def create_merchant(
#     merchant: CreatedMerchant,
#     session: Annotated[AsyncSession, Depends(get_session)],
#     current_user: User = Depends(deps.get_current_user)
# ) -> Merchant:
#     print("create_merchant", merchant)
#     data = merchant.dict()
#     dbmerchant = DBMerchant(**data)
#     dbmerchant.user = current_user
#     session.add(dbmerchant)
#     await session.commit()
#     await session.refresh(dbmerchant)
#     return Merchant.from_orm(dbmerchant)







@router.put("/{leader_id}")
async def update_leader(
    leader_id: int,
    leader: UpdatedLeader,
    session: Annotated[AsyncSession, Depends(get_session)],
    current_user: User = Depends(deps.get_current_user),
) -> Leader:
    data = leader.dict()
    db_leader = await session.get(DBLeader, leader_id)
    db_leader.sqlmodel_update(data)
    session.add(db_leader)
    await session.commit()
    await session.refresh(db_leader)

    return Leader.from_orm(db_leader)

