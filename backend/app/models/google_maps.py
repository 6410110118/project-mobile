from sqlmodel import SQLModel, Field, Relationship
from typing import Optional
from pydantic import BaseModel, ConfigDict
from typing import List

from .items import *

class BaseGoogleMap(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    address: str

class CreatedGoogleMap(BaseGoogleMap):
    pass

class UpdatedGoogleMap(BaseGoogleMap):
    pass

class GoogleMap(BaseGoogleMap):
    id: int
    latitude: float
    longitude: float
    formatted_address: str
    
    place_id: Optional[str] = None  # เพิ่มฟิลด์ place_id เพื่อเก็บข้อมูลจาก Google Places API
    photo_reference: Optional[str] = None  # เพิ่มฟิลด์ photo_reference สำหรับดึง URL รูปภาพ

class DBGoogleMap(GoogleMap, SQLModel, table=True):
    __tablename__ = "google_maps"
    id: int = Field(default=None, primary_key=True)
    items: list["DBItem"] = Relationship(back_populates="google_map")
