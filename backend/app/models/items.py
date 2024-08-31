from typing import Optional, List
from pydantic import BaseModel, ConfigDict
from sqlmodel import Relationship, SQLModel, Field
import datetime

from .users import *
from .leaders import *

class BaseItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    name: str
    description: Optional[str] = None

    start_date: datetime.date = datetime.date.today()
    expiration_days: int  # จำนวนวันที่หมดอายุที่ต้องป้อนเข้ามา
    end_date: datetime.date  # ฟิลด์ที่จะคำนวณ

    @root_validator(pre=True)
    def calculate_end_date(cls, values):
        start_date = values.get('start_date', datetime.date.today())
        expiration_days = values.get('expiration_days')
        end_date = values.get('end_date')
        
        if expiration_days is not None:
            values['end_date'] = start_date + datetime.timedelta(days=expiration_days)
        return values
        else :
            return values = start_date + datetime.timedelta(days=7)


class CreatedItem(BaseItem):
    pass

class UpdatedItem(BaseItem):
    pass

class Item(BaseItem):
    id: int
    role: UserRole
    user_id: int

class DBItem(SQLModel, Item, table=True):

    __tablename__ =  'items'
    id: int = Field(default=None, primary_key=True)

    user_id: int = Field( default=None, foreign_key="users.id")
    user: DBUser | None = Relationship(back_populates="item")
    role: UserRole = Field(default=None)
    # leader_id: int = Field(default=None, primary_key=True)
    # leader: DBLeader | None = Relationship(back_populates="item")


class ItemList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    items: List[Item]
    page: int
    page_count: int
    
    size_per_page: int
    