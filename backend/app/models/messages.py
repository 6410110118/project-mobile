from typing import Optional
from pydantic import BaseModel
from sqlmodel import Field, SQLModel, Relationship
from .peoples import DBPeople
from .groups import *
import datetime
class BaseMessage(BaseModel):
    
    model_config = ConfigDict(from_attributes=True)
    content: str
    created_at: datetime.datetime = datetime.datetime.now()


class CreatedMessage(BaseMessage):
    pass

class UpdatedMessage(BaseMessage):
    pass

class Message(BaseMessage):
    id: int
    group_id:int
    people_id:int

class DBMessage(SQLModel,Message, table=True):
    __tablename__ = 'messages'
    
    id: int = Field(default=None, primary_key=True)
    group_id: int = Field(default=None, foreign_key="groups.id")
    people_id: Optional[int] = Field(default=None, foreign_key="peoples.id")
    group: Optional["DBGroup"] = Relationship(back_populates="messages")
    people: Optional["DBPeople"] = Relationship(back_populates="messages")