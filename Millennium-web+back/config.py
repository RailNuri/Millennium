"""Configuration file for the application"""
import os
from dotenv import load_dotenv

load_dotenv()

# File to store house listings
HOUSES_FILE = 'houses.json'

# Google Maps API key - set this in .env file
GOOGLE_MAPS_API_KEY = os.getenv('GOOGLE_MAPS_API_KEY', 'YOUR_API_KEY_HERE')

# Azerbaijan geographic bounds
AZERBAIJAN_BOUNDS = {
    'min_lat': 38.4,
    'max_lat': 41.9,
    'min_lon': 44.8,
    'max_lon': 50.4
}

# Default location: Baku, Azerbaijan
DEFAULT_LOCATION = {
    'lat': 40.4093,
    'lon': 49.8671
}

