from sqlmodel import SQLModel, Field
from pydantic import BaseModel, ConfigDict
from typing import Optional
class BaseImages(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    data: bytes
class CreatedImages(BaseImages):
    pass

class UpdatedImages(BaseImages):
    pass

class Images(BaseImages):
    id: Optional[int] = None

class DBImages(BaseImages, SQLModel, table=True):
    __tablename__ = "images"
    filename: Optional[str] = Field(default=None)
    id: int = Field(default=None, primary_key=True)
class ImagestList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    students: list[Images]
    page: int
    page_size: int
    size_per_page: int