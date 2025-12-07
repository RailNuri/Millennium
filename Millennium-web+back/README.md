# Real Estate Location Finder

A web application that uses satellite imagery and location data to help users find the best real estate locations based on their requirements. The app analyzes proximity to amenities like schools, hospitals, markets, cafes, and more, then visualizes the results with color-coded overlays on satellite maps.

## Features

- 🗺️ **Satellite Imagery**: View locations using Google Maps satellite imagery
- 🎯 **Smart Scoring**: Location scoring based on proximity to required amenities
- 🎨 **Visual Overlays**: Color-coded areas (green = excellent, red = poor)
- 🏫 **Multiple Amenities**: Schools, hospitals, markets, cafes, restaurants, parks, pharmacies, gyms
- 📊 **Interactive Map**: Click on locations to see detailed scores and amenity information
- ⚙️ **Customizable Requirements**: Adjust importance (0-10) for each amenity type

## Setup Instructions

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Get Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - Maps JavaScript API
   - Places API
   - Geocoding API
4. Create credentials (API Key)
5. Copy your API key

### 3. Configure API Key

Create a `.env` file in the project root:

```bash
GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

Also update the API key in `templates/index.html` (line near the bottom):

```html
<script async defer
    src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY_HERE&callback=initMap&libraries=places">
</script>
```

Replace `YOUR_API_KEY_HERE` with your actual API key.

### 4. Run the Application

```bash
python app.py
```

The application will start on `http://localhost:5000`

## How to Use

1. **Enter Location**: Type an address or city name in the search box (e.g., "New York, NY")
2. **Set Requirements**: Adjust the sliders (0-10) to set the importance of each amenity:
   - Schools
   - Hospitals
   - Markets
   - Cafes
   - Restaurants
   - Parks
   - Pharmacy
   - Gym
3. **Find Locations**: Click "Find Best Locations" button
4. **View Results**: 
   - Green areas = Excellent locations (score 80-100)
   - Light green = Good locations (score 60-79)
   - Yellow = Fair locations (score 40-59)
   - Orange = Poor locations (score 20-39)
   - Red = Very poor locations (score 0-19)
5. **Get Details**: Click on any colored area or marker to see detailed information

## Scoring Algorithm

The scoring system works as follows:

- Each amenity type has a weight based on user requirements (0-10)
- The app searches for nearby places within a radius (varies by amenity type)
- Distance scoring:
  - Within 500m: Full points
  - Beyond 500m but within radius: Points decrease linearly
  - Beyond radius: 0 points
- Final score is normalized to 0-100

## Project Structure

```
hackathon/
├── app.py                 # Flask backend application
├── requirements.txt       # Python dependencies
├── .env.example          # Environment variables template
├── README.md             # This file
└── templates/
    └── index.html        # Frontend interface
```

## API Endpoints

- `GET /` - Main application page
- `POST /api/evaluate` - Evaluate locations based on requirements
  - Request body: `{latitude, longitude, requirements, grid_size}`
  - Returns: List of locations with scores and amenities
- `GET /api/places` - Get nearby places for a location
  - Query params: `lat, lon, type`
  - Returns: List of nearby places

## Notes

- If no Google Maps API key is provided, the app will use mock data for testing
- The grid size determines how many locations are evaluated (default: 7x7 = 49 locations)
- Larger grid sizes provide more coverage but take longer to process

## Future Enhancements

- [ ] Add more amenity types
- [ ] Support for custom radius settings
- [ ] Save and compare multiple searches
- [ ] Export results to CSV/PDF
- [ ] Integration with real estate listings
- [ ] Historical data and trends
- [ ] Crime statistics overlay
- [ ] Public transportation accessibility

## License

This project is open source and available for use in hackathons and personal projects.

