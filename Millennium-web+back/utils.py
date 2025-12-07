"""Utility functions for the application"""
import math
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed
from config import AZERBAIJAN_BOUNDS

def calculate_distance(lat1, lon1, lat2, lon2):
    """Calculate distance between two points using Haversine formula"""
    R = 6371  # Earth radius in kilometers
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = (math.sin(dlat/2) * math.sin(dlat/2) +
         math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) *
         math.sin(dlon/2) * math.sin(dlon/2))
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
    return R * c

def is_in_azerbaijan(lat, lon):
    """Check if coordinates are within Azerbaijan bounds"""
    return (AZERBAIJAN_BOUNDS['min_lat'] <= lat <= AZERBAIJAN_BOUNDS['max_lat'] and
            AZERBAIJAN_BOUNDS['min_lon'] <= lon <= AZERBAIJAN_BOUNDS['max_lon'])

def normalize_metro_station_name(name):
    """Normalize and correct Baku metro station names"""
    if not name:
        return name
    
    # Common Baku metro station names mapping
    metro_name_map = {
        '28 May': '28 May',
        '28 may': '28 May',
        '28-may': '28 May',
        'İçərişəhər': 'İçərişəhər',
        'Icherisheher': 'İçərişəhər',
        'Icheri Sheher': 'İçərişəhər',
        'Sahil': 'Sahil',
        'Gənclik': 'Gənclik',
        'Genclik': 'Gənclik',
        'Nəriman Nərimanov': 'Nəriman Nərimanov',
        'Nariman Narimanov': 'Nəriman Nərimanov',
        'Ulduz': 'Ulduz',
        'Koroglu': 'Koroğlu',
        'Koroğlu': 'Koroğlu',
        'Qara Qarayev': 'Qara Qarayev',
        'Kara Karayev': 'Qara Qarayev',
        'Nəsimi': 'Nəsimi',
        'Nasimi': 'Nəsimi',
        'Azadlıq prospekti': 'Azadlıq prospekti',
        'Azadliq prospekti': 'Azadlıq prospekti',
        'Azadlıq Prospekti': 'Azadlıq prospekti',
        'Nizami': 'Nizami',
        'İnşaatçılar': 'İnşaatçılar',
        'Inshaatchilar': 'İnşaatçılar',
        'Elmler Akademiyası': 'Elmler Akademiyası',
        'Elmler Akademiyasi': 'Elmler Akademiyası',
        'Nizami Gəncəvi': 'Nizami Gəncəvi',
        'Nizami Ganjavi': 'Nizami Gəncəvi',
        'Bakmil': 'Bakmil',
        'Avtovağzal': 'Avtovağzal',
        'Avtovagzal': 'Avtovağzal',
        '20 Yanvar': '20 Yanvar',
        '20 yanvar': '20 Yanvar',
        'Memar Əcəmi': 'Memar Əcəmi',
        'Memar Ajami': 'Memar Əcəmi',
        'Dərnəgül': 'Dərnəgül',
        'Darnagul': 'Dərnəgül',
        'Bakıxanov': 'Bakıxanov',
        'Bakikhanov': 'Bakıxanov',
        'Xalqlar Dostluğu': 'Xalqlar Dostluğu',
        'Khalklar Dostlugu': 'Xalqlar Dostluğu',
        'Neftçilər': 'Neftçilər',
        'Neftchilar': 'Neftçilər',
        'Avrora': 'Avrora',
        'Həzi Aslanov': 'Həzi Aslanov',
        'Hazi Aslanov': 'Həzi Aslanov'
    }
    
    # Try exact match first
    if name in metro_name_map:
        return metro_name_map[name]
    
    # Try case-insensitive match
    name_lower = name.lower().strip()
    for key, value in metro_name_map.items():
        if key.lower() == name_lower:
            return value
    
    # If contains "metro" or "subway", try to extract the station name
    if 'metro' in name_lower or 'subway' in name_lower:
        # Remove common suffixes
        cleaned = name.replace(' Metro', '').replace(' metro', '').replace(' Station', '').replace(' station', '')
        if cleaned in metro_name_map:
            return metro_name_map[cleaned]
    
    # Return original if no match found
    return name

def find_nearby_places(lat, lon, place_type, radius=2000):
    """Find nearby places using Overpass API (OpenStreetMap) - FREE, no API key needed"""
    
    # Check if location is in Azerbaijan
    if not is_in_azerbaijan(lat, lon):
        return []
    
    # Map place types to OpenStreetMap tag queries
    osm_queries = {
        'school': [('amenity', 'school')],
        'hospital': [('amenity', 'hospital')],
        'supermarket': [('shop', 'supermarket')],
        'market': [('shop', 'supermarket'), ('amenity', 'marketplace')],
        'cafe': [('amenity', 'cafe')],
        'restaurant': [('amenity', 'restaurant')],
        'park': [('leisure', 'park')],
        'gym': [('leisure', 'fitness_centre'), ('sport', 'gym')],
        'pharmacy': [('amenity', 'pharmacy')],
        'metro': [('railway', 'station'), ('station', 'subway'), ('public_transport', 'station')],
        'police': [('amenity', 'police')]
    }
    
    # Get the OSM tag queries
    tag_queries = osm_queries.get(place_type, [('amenity', 'school')])
    
    # Use faster Overpass API endpoint (Kumi Systems is often faster)
    overpass_url = "https://overpass.kumi.systems/api/interpreter"
    
    # Build the query for all tag combinations - simplified for speed
    query_parts = []
    if place_type == 'metro':
        # Special query for metro stations - only subway stations
        query_parts.append(f'node["railway"="station"]["station"="subway"](around:{radius},{lat},{lon});')
        query_parts.append(f'way["railway"="station"]["station"="subway"](around:{radius},{lat},{lon});')
        query_parts.append(f'node["public_transport"="station"]["station"="subway"](around:{radius},{lat},{lon});')
        query_parts.append(f'way["public_transport"="station"]["station"="subway"](around:{radius},{lat},{lon});')
    else:
        # Only query nodes for speed (skip ways/relations)
        for key, value in tag_queries:
            query_parts.append(f'node["{key}"="{value}"](around:{radius},{lat},{lon});')
    
    query = f"[out:json][timeout:8];({' '.join(query_parts)}); out center;"
    
    try:
        response = requests.post(overpass_url, data={'data': query}, timeout=8)
        response.raise_for_status()
        data = response.json()
        
        places = []
        seen_coords = set()  # To avoid duplicates by coordinates
        seen_names = set()  # To avoid duplicates by name (for metro stations)
        
        for element in data.get('elements', []):
            # Get coordinates
            place_lat = None
            place_lon = None
            
            if element['type'] == 'node':
                place_lat = element.get('lat')
                place_lon = element.get('lon')
            elif element['type'] == 'way' and 'center' in element:
                place_lat = element['center'].get('lat')
                place_lon = element['center'].get('lon')
            elif element['type'] == 'relation' and 'center' in element:
                place_lat = element['center'].get('lat')
                place_lon = element['center'].get('lon')
            
            if place_lat is None or place_lon is None:
                continue
            
            # Avoid duplicates (same location)
            coord_key = (round(place_lat, 5), round(place_lon, 5))
            if coord_key in seen_coords:
                continue
            seen_coords.add(coord_key)
            
            # Get name
            tags = element.get('tags', {})
            name = tags.get('name') or tags.get('brand') or f'{place_type.title()}'
            
            # For metro stations, normalize the name and filter for subway only
            if place_type == 'metro':
                # Only include if it's actually a subway/metro station
                if tags.get('station') != 'subway' and tags.get('railway') != 'station':
                    # Check if it has subway-related tags
                    if 'subway' not in str(tags).lower() and 'metro' not in str(tags).lower():
                        continue
                # Normalize the station name
                name = normalize_metro_station_name(name)
                
                # Filter out unwanted stations
                name_lower = name.lower()
                unwanted_stations = [
                    'mehemmed hadi', 'mehəmməd hadi', 'mehemmedhadi', 'məhəmməd hadi',
                    'azerneft', 'azərneft', 'azər neft yağ', 'azər neft yağ', 'azər neft',
                    'ag seher', 'ağ şəhər', 'agseher', 'ağseher',
                    'şah ismayıl xətai', 'shah ismayil xetai', 'şah ismayıl', 'shah ismayil', 'şah ismayıl xətai'
                ]
                if any(unwanted in name_lower for unwanted in unwanted_stations):
                    continue
                
                # Avoid duplicate names (especially Memar Əcəmi)
                name_key = name_lower.strip()
                if name_key in seen_names:
                    continue
                seen_names.add(name_key)
            
            # Format to match expected structure
            places.append({
                'geometry': {
                    'location': {
                        'lat': place_lat,
                        'lng': place_lon
                    }
                },
                'name': name,
                'tags': tags
            })
        
        return places
        
    except requests.exceptions.Timeout:
        print(f"Timeout fetching {place_type} from Overpass API")
        return []
    except Exception as e:
        print(f"Error fetching places from Overpass API for {place_type}: {e}")
        return []

def fetch_pois_parallel(center_lat, center_lon, place_types_to_fetch, radius):
    """Fetch POIs in parallel for faster loading"""
    cached_pois = {}
    
    def fetch_single_poi(place_type):
        return place_type, find_nearby_places(center_lat, center_lon, place_type, radius)
    
    # Use ThreadPoolExecutor for parallel requests
    with ThreadPoolExecutor(max_workers=5) as executor:
        future_to_type = {executor.submit(fetch_single_poi, pt): pt for pt in place_types_to_fetch}
        
        for future in as_completed(future_to_type):
            place_type, places = future.result()
            cached_pois[place_type] = places
    
    return cached_pois

def score_location(lat, lon, requirements, cached_pois=None):
    """Score a location based on proximity to required amenities"""
    score = 0
    max_score = 0
    amenities_found = {}
    
    # Define place types and their weights - reduced radii for speed
    place_types = {
        'school': {'weight': requirements.get('school', 0), 'radius': 1500},
        'hospital': {'weight': requirements.get('hospital', 0), 'radius': 2000},
        'supermarket': {'weight': requirements.get('market', 0), 'radius': 1200},
        'cafe': {'weight': requirements.get('cafe', 0), 'radius': 800},
        'restaurant': {'weight': requirements.get('restaurant', 0), 'radius': 1200},
        'park': {'weight': requirements.get('park', 0), 'radius': 1500},
        'gym': {'weight': requirements.get('gym', 0), 'radius': 1500},
        'pharmacy': {'weight': requirements.get('pharmacy', 0), 'radius': 800}
    }
    
    for place_type, config in place_types.items():
        weight = config['weight']
        if weight > 0:
            max_score += weight * 10
            
            # Use cached POIs if available, otherwise fetch
            if cached_pois and place_type in cached_pois:
                places = cached_pois[place_type]
            else:
                places = find_nearby_places(lat, lon, place_type, config['radius'])
            
            if places:
                # Find the closest place
                min_distance = float('inf')
                closest_place = None
                
                for place in places:
                    place_lat = place['geometry']['location']['lat']
                    place_lon = place['geometry']['location']['lng']
                    distance = calculate_distance(lat, lon, place_lat, place_lon)
                    
                    if distance < min_distance:
                        min_distance = distance
                        closest_place = place
                
                # Score based on distance (closer = better)
                # Maximum score if within 500m, decreasing linearly
                if min_distance <= 0.5:  # 500m
                    place_score = weight * 10
                elif min_distance <= config['radius'] / 1000:  # Within radius
                    place_score = weight * 10 * (1 - (min_distance - 0.5) / (config['radius'] / 1000 - 0.5))
                else:
                    place_score = 0
                
                score += place_score
                amenities_found[place_type] = {
                    'distance': round(min_distance, 2),
                    'name': closest_place.get('name', 'Unknown'),
                    'count': len(places)
                }
            else:
                amenities_found[place_type] = {'distance': None, 'name': None, 'count': 0}
    
    # Normalize score to 0-100
    if max_score > 0:
        normalized_score = (score / max_score) * 100
    else:
        normalized_score = 0
    
    return {
        'score': round(normalized_score, 2),
        'amenities': amenities_found
    }

def evaluate_locations(center_lat, center_lon, requirements, grid_size=5):
    """Evaluate multiple locations in a grid around the center point"""
    
    # Check if center is in Azerbaijan
    if not is_in_azerbaijan(center_lat, center_lon):
        return []
    
    print(f"Starting evaluation for {grid_size}x{grid_size} grid...")
    
    # Calculate the area we need to cover - optimized for speed
    step = 0.015  # Approximately 1.5km steps (larger steps = fewer locations)
    max_radius = 1500  # Reduced radius for faster queries
    area_radius = max_radius + (grid_size * step * 111000 / 2)  # Convert to meters
    
    # Fetch all POIs for the entire area ONCE (much faster!)
    print("Fetching POIs for the area...")
    place_types_to_fetch = []
    
    # Build list of place types to fetch
    if requirements.get('market', 0) > 0:
        place_types_to_fetch.append('supermarket')
    
    for place_type in ['school', 'hospital', 'cafe', 'restaurant', 'park', 'gym', 'pharmacy']:
        if requirements.get(place_type, 0) > 0:
            place_types_to_fetch.append(place_type)
    
    # Fetch POIs in parallel for speed
    cached_pois = fetch_pois_parallel(center_lat, center_lon, place_types_to_fetch, int(area_radius))
    
    # Handle market/supermarket
    if 'supermarket' in cached_pois:
        cached_pois['market'] = cached_pois['supermarket']
    
    print(f"Found POIs: {sum(len(v) for v in cached_pois.values())} total")
    
    # Now evaluate each grid location using cached POIs
    locations = []
    start_lat = center_lat - (grid_size * step / 2)
    start_lon = center_lon - (grid_size * step / 2)
    
    print(f"Evaluating {grid_size * grid_size} locations...")
    for i in range(grid_size):
        for j in range(grid_size):
            lat = start_lat + (i * step)
            lon = start_lon + (j * step)
            
            location_data = score_location(lat, lon, requirements, cached_pois)
            locations.append({
                'lat': lat,
                'lon': lon,
                'score': location_data['score'],
                'amenities': location_data['amenities']
            })
    
    print("Evaluation complete!")
    return locations

