from datetime import datetime, timedelta
from typing import Any, Union
import jwt
from googlemaps import Client
from . import config
from dotenv import load_dotenv
import os

ALGORITHM = "HS256"

# โหลดการตั้งค่าจาก config
settings = config.get_settings()

# โหลดคีย์ API จากไฟล์ .env
load_dotenv()
api_key = os.getenv("GOOGLE_PLACE_API_KEY")
gmaps = Client(key=api_key)

def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(
            minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
        )
    to_encode.update({"exp": expire})

    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def create_refresh_token(data: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(
            minutes=settings.REFRESH_TOKEN_EXPIRE_MINUTES
        )
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def gplaces(query: str) -> Any:
    """
    ค้นหาสถานที่โดยใช้ Google Places API
    :param query: คำค้นหาสำหรับสถานที่
    :return: ผลลัพธ์ของการค้นหาสถานที่
    """
    try:
        places = gmaps.places(query=query)
        return places
    except Exception as e:
        print(f"เกิดข้อผิดพลาดในการค้นหาสถานที่: {e}")
        return None
