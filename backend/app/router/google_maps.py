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
    current_user: models.User = Depends(deps.get_current_user)
) -> models.GoogleMap:
    
    # Check if address is already in the database
    async with session:
        result = await session.exec(
            select(models.DBGoogleMap).where(models.DBGoogleMap.address == address)
        )
        dbmap = result.one_or_none()

        if dbmap:
            return dbmap

        # If not in database, request geocoding from Google Places API
        try:
            api_result = security.gplaces(address)  # เรียกใช้ฟังก์ชัน gplaces
        except Exception as e:
            print(f"error {e}")
            raise HTTPException(status_code=500, detail="Places API request failed")

        if not api_result or not api_result.get('results'):
            raise HTTPException(status_code=404, detail="Address not found")

        # Extract data from the first result
        place_data = api_result['results'][0]
        location = place_data['geometry']['location']
        formatted_address = place_data['formatted_address']
        place_id = place_data['place_id']

        # Check for photo references in the result
        # Check for photo references in the result
        photo_reference = None
        if 'photos' in place_data and place_data['photos']:
            photo_reference = place_data['photos'][0].get('photo_reference')  # ใช้ get() เพื่อลดโอกาสเกิด KeyError


        # Generate Place Photo URL if available
        photo_url = None
        if photo_reference:
            base_photo_url = "https://maps.googleapis.com/maps/api/place/photo"
            photo_url = (
                f"{base_photo_url}?maxwidth=400&photoreference={photo_reference}&key={security.api_key}"
            )

        # Create new GoogleMap instance and add to database
        new_data = models.DBGoogleMap(
            address=address,
            latitude=location['lat'],
            longitude=location['lng'],
            formatted_address=formatted_address,
            place_id=place_id,  # Store place_id for future reference
            photo_reference=photo_url  # Save the photo URL if available
        )
        session.add(new_data)
        await session.commit()
        await session.refresh(new_data)

    return new_data
