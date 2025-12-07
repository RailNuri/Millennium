# Millennium - Real Estate Marketplace

A comprehensive web application for finding and listing real estate properties in Azerbaijan. The platform helps users discover the best locations based on proximity to amenities, view property listings, and connect buyers with sellers. Features include interactive maps, location scoring, metro station information, and a full property marketplace.

## Features

### 🏠 **Property Marketplace**
- **For Sellers**: List properties with details (price, address, bedrooms, bathrooms, area)
- **For Buyers**: Search properties by price range and location requirements
- Quality scoring based on price competitiveness
- Match scoring based on buyer requirements

### 🗺️ **Interactive Location Analysis**
- **Satellite Imagery**: View locations using Leaflet maps with satellite imagery
- **Smart Scoring**: Location scoring based on proximity to required amenities
- **Visual Overlays**: Color-coded areas showing location quality
  - 🟢 Green = Excellent locations (score 80-100)
  - 🟡 Light green = Good locations (score 60-79)
  - 🟡 Yellow = Fair locations (score 40-59)
  - 🟠 Orange = Poor locations (score 20-39)
  - 🔴 Red = Very poor locations (score 0-19)

### 🏫 **Amenity Analysis**
- Schools, hospitals, markets, cafes, restaurants, parks, pharmacies, gyms
- Police stations and metro stations
- Distance calculations and amenity counts
- Customizable importance weights (0-10) for each amenity type

### 🚇 **Metro Station Integration**
- Complete Baku metro station database
- Distance to nearest metro station for each property
- Metro station visualization on map

### 📊 **Advanced Features**
- Parallel POI fetching for faster performance
- Azerbaijan geographic bounds validation
- Real-time location evaluation
- Interactive map with clickable markers

## Technology Stack

- **Backend**: Flask (Python)
- **Frontend**: HTML, CSS, JavaScript, Leaflet.js
- **Maps**: Leaflet.js (OpenStreetMap)
- **POI Data**: Overpass API (OpenStreetMap - FREE, no API key needed)
- **Data Storage**: JSON file-based storage (`houses.json`)

## Project Structure

```
Millennium-web+back/
├── app.py                 # Main Flask application entry point
├── routes.py              # API route definitions
├── models.py              # Data models and house management
├── utils.py               # Utility functions (scoring, POI fetching, etc.)
├── config.py              # Configuration settings
├── requirements.txt       # Python dependencies
├── houses.json            # Property listings database (auto-generated)
├── install_deps.py        # Dependency installer script
├── run_server.bat         # Windows batch file to run server
├── run.bat                # Alternative run script
├── run.sh                 # Linux/Mac run script
├── QUICK_START.md         # Quick start guide
├── README.md              # This file
├── static/
│   └── logo.svg          # Application logo
└── templates/
    └── index.html         # Frontend interface
```

## Setup Instructions

### Prerequisites

- Python 3.7 or higher
- pip (Python package manager)

### 1. Install Dependencies

**Option A: Using requirements.txt**
```bash
pip install -r requirements.txt
```

**Option B: Manual installation**
```bash
pip install Flask==3.0.0 requests==2.31.0 python-dotenv==1.0.0 flask-cors==4.0.0
```

**Option C: Use the installer script**
```bash
python install_deps.py
```

### 2. Run the Application

**Option A: Direct Python command**
```bash
python app.py
```

**Option B: Windows Batch File**
Double-click `run_server.bat` or run:
```bash
run_server.bat
```

**Option C: Linux/Mac**
```bash
chmod +x run.sh
./run.sh
```

The application will start on `http://localhost:5000`

### 3. Optional: Google Maps API Key (for enhanced features)

If you want to use Google Maps features (currently the app uses Leaflet/OpenStreetMap which doesn't require an API key):

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - Maps JavaScript API
   - Places API
   - Geocoding API
4. Create credentials (API Key)
5. Create a `.env` file in the project root:
   ```bash
   GOOGLE_MAPS_API_KEY=your_actual_api_key_here
   ```

**Note**: The app works perfectly without a Google Maps API key using OpenStreetMap data!

## How to Use

### For Buyers

1. **Search Properties**:
   - Enter a location or use the map to select an area
   - Set your price range (min/max)
   - Adjust amenity importance sliders (0-10):
     - Schools, Hospitals, Markets, Cafes, Restaurants, Parks, Pharmacy, Gym
   - Click "Search Properties"
   - View results sorted by match score

2. **Evaluate Locations**:
   - Enter a location in the search box
   - Set your requirements using sliders
   - Click "Find Best Locations"
   - View color-coded areas on the map
   - Click on markers to see detailed scores and amenities

3. **View Metro Stations**:
   - Metro stations are automatically displayed on the map
   - Each property shows distance to nearest metro station

### For Sellers

1. **Add Property Listing**:
   - Fill in property details:
     - Title, Address, Price
     - Description, Bedrooms, Bathrooms, Area
     - Seller name and phone (optional)
   - Select location on map or enter coordinates
   - Submit listing

2. **View Your Listings**:
   - All listings are stored in `houses.json`
   - Properties are automatically scored for quality

## API Endpoints

### Main Routes
- `GET /` - Main application page

### Location Evaluation
- `POST /api/evaluate` - Evaluate locations based on requirements
  - **Request Body**:
    ```json
    {
      "latitude": 40.4093,
      "longitude": 49.8671,
      "requirements": {
        "school": 8,
        "hospital": 7,
        "market": 6,
        "cafe": 5,
        "restaurant": 4,
        "park": 3,
        "pharmacy": 6,
        "gym": 4
      },
      "grid_size": 5
    }
    ```
  - **Response**: List of locations with scores and amenities

### Places & POIs
- `GET /api/places` - Get nearby places for a location
  - **Query Parameters**: `lat`, `lon`, `type`
  - **Response**: List of nearby places

- `POST /api/all-places` - Get all nearby places of all types
  - **Request Body**:
    ```json
    {
      "latitude": 40.4093,
      "longitude": 49.8671,
      "radius": 2000
    }
    ```
  - **Response**: All places grouped by type

- `GET /api/metro-stations` - Get all metro stations in Baku
  - **Response**: List of unique metro stations

### Property Management
- `POST /api/houses` - Add a new house listing
  - **Request Body**:
    ```json
    {
      "title": "Modern Apartment",
      "address": "Baku, Azerbaijan",
      "latitude": 40.4093,
      "longitude": 49.8671,
      "price": 150000,
      "description": "Beautiful apartment...",
      "bedrooms": 3,
      "bathrooms": 2,
      "area": 120,
      "seller_name": "John Doe",
      "seller_phone": "+994501234567"
    }
    ```
  - **Response**: Created house object

- `GET /api/houses` - Get all house listings
  - **Response**: List of all houses with quality scores

- `POST /api/houses/search` - Search houses by price and requirements
  - **Request Body**:
    ```json
    {
      "min_price": 100000,
      "max_price": 200000,
      "requirements": {
        "school": 8,
        "hospital": 7,
        "market": 6
      }
    }
    ```
  - **Response**: Filtered and scored houses sorted by match score

## Scoring Algorithm

### Location Scoring
- Each amenity type has a weight based on user requirements (0-10)
- The app searches for nearby places within a radius (varies by amenity type):
  - Schools: 1500m
  - Hospitals: 2000m
  - Markets: 1200m
  - Cafes: 800m
  - Restaurants: 1200m
  - Parks: 1500m
  - Gyms: 1500m
  - Pharmacies: 800m
- Distance scoring:
  - Within 500m: Full points
  - Beyond 500m but within radius: Points decrease linearly
  - Beyond radius: 0 points
- Final score is normalized to 0-100

### Quality Scoring (for properties)
- Based on price competitiveness
- Lower price = higher quality score
- Normalized across all listings

## Configuration

The application is configured for Azerbaijan by default. You can modify geographic bounds in `config.py`:

```python
AZERBAIJAN_BOUNDS = {
    'min_lat': 38.4,
    'max_lat': 41.9,
    'min_lon': 44.8,
    'max_lon': 50.4
}
```

Default location is set to Baku:
```python
DEFAULT_LOCATION = {
    'lat': 40.4093,
    'lon': 49.8671
}
```

## Data Sources

- **POI Data**: OpenStreetMap via Overpass API (free, no API key required)
- **Maps**: Leaflet.js with OpenStreetMap tiles
- **Property Listings**: Stored locally in `houses.json`

## Performance Optimizations

- Parallel POI fetching using ThreadPoolExecutor
- Cached POI data for grid evaluations
- Optimized Overpass API queries
- Reduced query radii for faster responses

## Troubleshooting

### Port Already in Use
If port 5000 is already in use, edit `app.py` and change:
```python
app.run(debug=True, port=5000)
```
to a different port (e.g., `port=5001`)

### Module Not Found Errors
- Ensure you're using the correct Python version: `python --version`
- Upgrade pip: `python -m pip install --upgrade pip`
- Reinstall dependencies: `pip install -r requirements.txt`

### Location Validation Errors
- The app validates that locations are within Azerbaijan bounds
- If you need to use other regions, modify `AZERBAIJAN_BOUNDS` in `config.py`

## Future Enhancements

- [ ] User authentication and accounts
- [ ] Image uploads for property listings
- [ ] Advanced filtering (bedrooms, bathrooms, area range)
- [ ] Favorites and saved searches
- [ ] Email notifications for new matching properties
- [ ] Export results to CSV/PDF
- [ ] Integration with real estate APIs
- [ ] Historical price trends
- [ ] Crime statistics overlay
- [ ] Public transportation route planning
- [ ] Multi-language support (Azerbaijani, English, Russian)
- [ ] Mobile app version

## License

This project is open source and available for use in hackathons and personal projects.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues and questions, please check the `QUICK_START.md` file or open an issue in the repository.
