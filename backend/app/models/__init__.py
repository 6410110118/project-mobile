from sqlmodel import SQLModel

from sqlmodel.ext.asyncio.session import AsyncSession
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.asyncio import create_async_engine
from typing import AsyncGenerator


from .users import *
from .items import *
from .groups import *
# from .add_user_to_groups import *
from .leaders import *
from .peoples import * 
from .google_maps import *

connect_args = {}

engine = None

def init_db(settings):
    global engine

    engine = create_async_engine(
        settings.SQLDB_URL,
        echo=True,
        future=True,
        connect_args=connect_args,
    )
async def create_all():
    async with engine.begin() as conn:

        #await conn.run_sync(SQLModel.metadata.drop_all)
        await conn.run_sync(SQLModel.metadata.create_all)




async def get_session() -> AsyncGenerator[AsyncSession, None]:
    async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
    async with async_session() as session:
        yield session