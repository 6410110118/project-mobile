from typing import Optional
from sqlmodel import Field, Relationship, SQLModel
from .users import DBUser

class PeopleGroupLink(SQLModel, table=True):
    __tablename__ = "people_group_link"
    id: Optional[int] = Field(default=None, primary_key=True)
    people_id: int = Field(default=None, foreign_key="peoples.id")
    group_id: int = Field(default=None, foreign_key="groups.id")
    user_id: int = Field(default=None, foreign_key="users.id")
    user: "DBUser"  = Relationship(back_populates="people_group_links")