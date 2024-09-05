from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import Session, select
from .. import deps
from .. import models
from .. import security
from sqlmodel.ext.asyncio.session import AsyncSession
from typing import Annotated


# ... (keep the existing imports and setup)
router = APIRouter(tags=["google_map"])




@router.get("/geocode", response_model=models.GoogleMap)
async def geocode_address(
    address: str,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user)) -> models.GoogleMap:
    
    # Check if address is already in the database
    result = await session.exec(
        select(models.DBGoogleMap).where(models.DBGoogleMap.address == address)
    )
    dbmap = result.one_or_none()

    if dbmap:
        return dbmap

    # If not in database, request geocoding from Google Maps API
    api_result = security.gmaps.geocode(address)

    if not api_result:
        raise HTTPException(status_code=404, detail="Address not found")

    # Extract latitude, longitude, and formatted address
    location = api_result[0]['geometry']['location']
    formatted_address = api_result[0]['formatted_address']

    # Create new GeocodingData instance and add to database
    new_data = models.DBGoogleMap(
        address=address,
        latitude=location['lat'],
        longitude=location['lng'],
        formatted_address=formatted_address
    )
    session.add(new_data)
    await session.commit()
    await session.refresh(new_data)

    return new_data
    
