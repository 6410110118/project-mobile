import os
from dotenv import load_dotenv
from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import select
from .. import deps
from .. import models
from .. import security
from sqlmodel.ext.asyncio.session import AsyncSession
from typing import Annotated

router = APIRouter(tags=["google_map"])

@router.get("/geocode", response_model=models.GoogleMap)
async def geocode_address(
    address: str,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user)) -> models.GoogleMap:
    
    # Check if address is already in the database
    async with session:
        result = await session.exec(
            select(models.DBGoogleMap).where(models.DBGoogleMap.address == address)
        )
        dbmap = result.one_or_none()

        if dbmap:
            return dbmap

        # If not in database, request geocoding from Google Maps API
        try:
            api_result = security.gmaps.geocode(address)
        except Exception as e:
            raise HTTPException(status_code=500, detail="Geocoding API request failed")

        if not api_result or not api_result[0]['geometry']:
            raise HTTPException(status_code=404, detail="Address not found")

        # Extract latitude, longitude, and formatted address
        location = api_result[0]['geometry']['location']
        formatted_address = api_result[0]['formatted_address']

        # Generate Static Map URL

        base_url = "https://maps.googleapis.com/maps/api/staticmap"
        map_image_url = (
            
            f"{base_url}?center={location['lat']},{location['lng']}"
            f"&zoom=15&size=600x300&maptype=roadmap"
            f"&markers=color:red%7Clabel:P%7C{location['lat']},{location['lng']}"
            f"&key={security.api_key}"
        )

        # Create new GeocodingData instance and add to database
        new_data = models.DBGoogleMap(
            address=address,
            latitude=location['lat'],
            longitude=location['lng'],
            formatted_address=formatted_address
            
        )
        new_data.map_image_url = map_image_url
        session.add(new_data)
        await session.commit()
        await session.refresh(new_data)

        

    return new_data
