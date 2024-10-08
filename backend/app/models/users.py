
from typing import TYPE_CHECKING, List, Optional
import pydantic
import bcrypt
from pydantic import BaseModel , ConfigDict , EmailStr
import datetime
from sqlmodel import Relationship, SQLModel, Field
from enum import Enum

if TYPE_CHECKING:
    
    from .items import DBItem
    from.groups import DBGroup
    # from .add_user_to_groups import DBAddUserToGroup
    from .leaders import DBLeader
    from .peoples import DBPeople

class UserRole(str, Enum):
    leader = "Leader"
    people= "People"

class BaseUser(BaseModel):
    model_config = ConfigDict(from_attributes=True, populate_by_name=True)
    email: str = pydantic.Field(json_schema_extra=dict(example="admin@email.local"))
    username: str = pydantic.Field(json_schema_extra=dict(example="admin"))
    first_name: str = pydantic.Field(json_schema_extra=dict(example="Firstname"))
    last_name: str = pydantic.Field(json_schema_extra=dict(example="Lastname"))


class User(BaseUser):
    id: int
    role:UserRole
    imageData : bytes | None

    last_login_date: datetime.datetime | None = pydantic.Field(
        json_schema_extra=dict(example="2023-01-01T00:00:00.000000"), default=None
    )
    register_date: datetime.datetime | None = pydantic.Field(
        json_schema_extra=dict(example="2023-01-01T00:00:00.000000"), default=None
    )

class ReferenceUser(BaseModel):
    model_config = ConfigDict(from_attributes=True, populate_by_name=True)
    username: str 
    first_name: str 
    last_name: str

class UserList(BaseModel):
    model_config = ConfigDict(from_attributes=True, populate_by_name=True)
    users: list[User]


class Login(BaseModel):
    email: EmailStr
    password: str


class ChangedPassword(BaseModel):
    current_password: str
    new_password: str


class ResetedPassword(BaseModel):
    email: EmailStr
    citizen_id: str


class RegisteredUser(BaseUser):
    password: str = pydantic.Field(json_schema_extra=dict(example="password"))


class UpdatedUser(BaseUser):
    role: UserRole
    email: EmailStr | None = pydantic.Field(json_schema_extra=dict(example="admin@email.local"))
    username: str | None= pydantic.Field(json_schema_extra=dict(example="admin"))
    first_name: str | None= pydantic.Field(json_schema_extra=dict(example="Firstname"))
    last_name: str| None = pydantic.Field(json_schema_extra=dict(example="Lastname"))
 


class Token(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str
    expires_in: int
    expires_at: datetime.datetime
    scope: str
    issued_at: datetime.datetime


class TokenData(BaseModel):
    user_id: str | None = None
    user_id: int


class ChangedPasswordUser(BaseModel):
    current_password: str
    new_password: str



class DBUser(BaseUser, SQLModel, table=True):
    __tablename__ = "users"
    id: int | None = Field(default=None, primary_key=True)

    password: str
    role: UserRole = Field(default=None)
    imageData: Optional[bytes] = Field(default=None)

    register_date: datetime.datetime = Field(default_factory=datetime.datetime.now)
    updated_date: datetime.datetime = Field(default_factory=datetime.datetime.now)
    last_login_date: datetime.datetime | None = Field(default=None)
    item: List["DBItem"] = Relationship(back_populates="user", cascade_delete=True)
    # group: List["DBGroup"] = Relationship(back_populates="user", cascade_delete=True)
    # add_user_to_group: List["DBAddUserToGroup"] = Relationship(back_populates="user", cascade_delete=True)
    leader: List["DBLeader"] = Relationship(back_populates="user", cascade_delete=True)
    people: List["DBPeople"] = Relationship(back_populates="user", cascade_delete=True)
    



    async def has_roles(self, roles):
        for role in roles:
            if role in self.roles:
                return True
        return False
    async def get_encrypted_password(self, plain_password):
        return bcrypt.hashpw(
            plain_password.encode("utf-8"), salt=bcrypt.gensalt()
        ).decode("utf-8")
    async def set_password(self, plain_password):
        self.password = await self.get_encrypted_password(plain_password)

    async def verify_password(self, plain_password):
        return bcrypt.checkpw(
            plain_password.encode("utf-8"), self.password.encode("utf-8")
        )
    
class UserList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    users: List[User]
    page: int
    page_count: int
    
    size_per_page: int