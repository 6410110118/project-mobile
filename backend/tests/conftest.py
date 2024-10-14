import sys
import os

# Add the parent directory of 'app' to the Python path
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
import pytest
import pytest_asyncio
import datetime
from fastapi import FastAPI
from httpx import AsyncClient, ASGITransport
from app import config, main, security, models
import pathlib
import asyncio


# ตั้งค่า Settings สำหรับการทดสอบ
SettingsTesting = config.Settings
SettingsTesting.model_config = {
    "env_file": ".testing.env",
    "validate_assignment": True,
    "extra": "allow"
}

@pytest.fixture(name="app", scope="session")
def app_fixture():
    settings = SettingsTesting()
    path = pathlib.Path("test-data")
    if not path.exists():
        path.mkdir()

    app = main.create_app(settings)
    asyncio.run(models.recreate_table())

    yield app

@pytest.fixture(name="client", scope="session")
def client_fixture(app: FastAPI) -> AsyncClient:
    return AsyncClient(transport=ASGITransport(app=app), base_url="http://localhost")

@pytest_asyncio.fixture(name="session", scope="session")
async def get_session() -> models.AsyncGenerator[models.AsyncSession, None]:
    settings = SettingsTesting()
    models.init_db(settings)

    async_session = models.sessionmaker(
        models.engine, class_=models.AsyncSession, expire_on_commit=False
    )
    async with async_session() as session:
        yield session
