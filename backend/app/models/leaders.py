# Merchant
from typing import Optional , List
from pydantic import BaseModel, ConfigDict
from sqlmodel import Field, Relationship, SQLModel



from . import users
from . import items
from .groups import DBGroup




class BaseLeader(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    firstname: str
    lastname: str
    

    

class CreatedLeader(BaseLeader):
    pass

class UpdatedLeader(BaseLeader):
    pass

class Leader(BaseLeader):
    id: int
    user_id: int
    

class DBLeader(Leader, SQLModel, table=True):
    __tablename__ = "leaders"
    id: int = Field(default=None, primary_key=True)
    # item: list["items.DBItem"] = Relationship(back_populates="leader", cascade_delete=True)
    groups:list["DBGroup"] = Relationship(back_populates="leader", cascade_delete=True)
    #wallets: list["wallets.DBWallet"] = Relationship(back_populates="merchant", cascade_delete=True)
    user_id: int = Field(default=None, foreign_key="users.id")
    user: users.DBUser | None = Relationship(back_populates="leader")

class LeaderList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    leaders: list[Leader]
    page: int
    page_size: int
    size_per_page: int
