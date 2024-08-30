from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated
from .. import deps
from .. import models

router = APIRouter(prefix="/groups", tags=["groups"])
@router.post("")
async def create(
    group_info: models.CreatedGroup,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.Group:

    result = await session.exec(
        select(models.DBLeader).where(models.DBLeader.user_id == current_user.id)
    )


    db_leader = result.one_or_none()

    if not db_leader:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only leader can create groups.",
        )

    new_group = models.DBGroup.from_orm(group_info)
    new_group.leader = db_leader
    new_group.user_id = current_user.id
    session.add(new_group)
    await session.commit()
    await session.refresh(new_group)

    return new_group
