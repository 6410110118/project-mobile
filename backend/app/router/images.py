from fastapi import APIRouter, Depends, HTTPException, Response, UploadFile
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select
from typing import Annotated
from app import models
from app import deps


router = APIRouter(prefix="/images", tags=["images"])
@router.post("")
async def create_image(
    file: UploadFile,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
):
    file_data = await file.read()
    
    db_image = models.DBImages(
        filename=file.filename,
        data=file_data,
        user_id=current_user.id  # Assuming there is a user_id field in DBImages
    )
    
    session.add(db_image)
    await session.commit()
    await session.refresh(db_image)
    
    return {"message": f"Image {file.filename} uploaded successfully", "image_id": db_image.id}
@router.get("/{image_id}")
async def get_image(
    image_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
):
    image = await session.exec(
        select(models.DBUser).where(models.DBUser.id == image_id)
    )
    
    db_image = image.one_or_none()
    
    if not db_image:
        raise HTTPException(status_code=404, detail="Image not found")
    if not db_image.imageData:
        raise HTTPException(status_code=404, detail="Image data not found")
    
    return Response(db_image.imageData, media_type="image/jpeg")