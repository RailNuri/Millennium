"""API routes for the application"""
from flask import request, jsonify, render_template
from utils import (
    find_nearby_places, calculate_distance, is_in_azerbaijan,
    score_location, evaluate_locations, fetch_pois_parallel
)
from models import load_houses, save_houses, calculate_quality_scores
from config import DEFAULT_LOCATION, AZERBAIJAN_BOUNDS
from datetime import datetime

def register_routes(app):
    """Register all API routes"""
    
    @app.route('/')
    def index():
        return render_template('index.html')
    
    @app.route('/api/evaluate', methods=['POST'])
    def evaluate():
        """API endpoint to evaluate locations based on requirements"""
        try:
            data = request.json
            
            center_lat = float(data.get('latitude', DEFAULT_LOCATION['lat']))
            center_lon = float(data.get('longitude', DEFAULT_LOCATION['lon']))
            requirements = data.get('requirements', {})
            grid_size = int(data.get('grid_size', 5))
            
            # Validate Azerbaijan bounds
            if not is_in_azerbaijan(center_lat, center_lon):
                return jsonify({
                    'error': 'Location must be within Azerbaijan bounds',
                    'bounds': AZERBAIJAN_BOUNDS
                }), 400
            
            print(f"Received evaluation request for ({center_lat}, {center_lon})")
            locations = evaluate_locations(center_lat, center_lon, requirements, grid_size)
            
            return jsonify({
                'center': {'lat': center_lat, 'lon': center_lon},
                'locations': locations
            })
        except Exception as e:
            print(f"Error in evaluate endpoint: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({'error': str(e)}), 500
    
    @app.route('/api/places', methods=['GET'])
    def get_places():
        """API endpoint to get nearby places for a location"""
        lat = float(request.args.get('lat', 40.7128))
        lon = float(request.args.get('lon', -74.0060))
        place_type = request.args.get('type', 'school')
        
        places = find_nearby_places(lat, lon, place_type)
        
        return jsonify({
            'places': places,
            'count': len(places)
        })
    
    @app.route('/api/all-places', methods=['POST'])
    def get_all_places():
        """API endpoint to get all nearby places of all types for visualization"""
        data = request.json
        center_lat = float(data.get('latitude', DEFAULT_LOCATION['lat']))
        center_lon = float(data.get('longitude', DEFAULT_LOCATION['lon']))
        radius = int(data.get('radius', 2000))
        
        # Validate Azerbaijan bounds
        if not is_in_azerbaijan(center_lat, center_lon):
            return jsonify({
                'places': {},
                'center': {'lat': center_lat, 'lon': center_lon},
                'error': 'Location outside Azerbaijan'
            })
        
        all_places = {}
        place_types = ['school', 'hospital', 'supermarket', 'market', 'cafe', 'restaurant', 'park', 'gym', 'pharmacy']
        
        # Fetch in parallel for speed
        cached_pois = fetch_pois_parallel(center_lat, center_lon, place_types, radius)
        all_places = cached_pois
        
        # Handle market
        if 'supermarket' in all_places:
            all_places['market'] = all_places['supermarket']
        
        return jsonify({
            'places': all_places,
            'center': {'lat': center_lat, 'lon': center_lon}
        })
    
    @app.route('/api/metro-stations', methods=['GET'])
    def get_metro_stations():
        """API endpoint to get all metro stations in Baku"""
        try:
            # Baku center coordinates
            baku_center_lat = 40.4093
            baku_center_lon = 49.8671
            radius = 20000  # 20km to cover all of Baku
            
            # Find all metro stations
            metro_stations = find_nearby_places(baku_center_lat, baku_center_lon, 'metro', radius)
            
            # Remove duplicates (same name) - keep first occurrence
            seen_names = set()
            unique_stations = []
            for station in metro_stations:
                station_name = station.get('name', '').lower().strip()
                if station_name and station_name not in seen_names:
                    seen_names.add(station_name)
                    unique_stations.append(station)
            
            return jsonify({
                'stations': unique_stations,
                'count': len(unique_stations)
            })
        except Exception as e:
            print(f"Error fetching metro stations: {e}")
            return jsonify({'stations': [], 'count': 0, 'error': str(e)})
    
    @app.route('/api/houses', methods=['POST'])
    def add_house():
        """API endpoint for sellers to add a house listing"""
        try:
            data = request.json
            
            # Validate required fields
            required_fields = ['title', 'address', 'latitude', 'longitude', 'price', 'description']
            for field in required_fields:
                if field not in data:
                    return jsonify({'error': f'Missing required field: {field}'}), 400
            
            lat = float(data['latitude'])
            lon = float(data['longitude'])
            
            # Validate Azerbaijan bounds
            if not is_in_azerbaijan(lat, lon):
                return jsonify({'error': 'Location must be within Azerbaijan bounds'}), 400
            
            # Load existing houses
            houses = load_houses()
            
            # Create new house entry
            new_house = {
                'id': len(houses) + 1,
                'title': data['title'],
                'address': data['address'],
                'latitude': lat,
                'longitude': lon,
                'price': float(data['price']),
                'description': data.get('description', ''),
                'bedrooms': data.get('bedrooms', 0),
                'bathrooms': data.get('bathrooms', 0),
                'area': data.get('area', 0),
                'seller_name': data.get('seller_name', 'Anonymous'),
                'seller_phone': data.get('seller_phone', ''),
                'created_at': datetime.now().isoformat()
            }
            
            houses.append(new_house)
            
            # Save houses
            if save_houses(houses):
                return jsonify({'success': True, 'house': new_house}), 201
            else:
                return jsonify({'error': 'Failed to save house'}), 500
                
        except Exception as e:
            print(f"Error adding house: {e}")
            return jsonify({'error': str(e)}), 500
    
    @app.route('/api/houses', methods=['GET'])
    def get_houses():
        """API endpoint to get all houses"""
        houses = load_houses()
        if houses:
            calculate_quality_scores(houses)
        return jsonify({'houses': houses, 'count': len(houses)})
    
    @app.route('/api/houses/search', methods=['POST'])
    def search_houses():
        """API endpoint for buyers to search houses by price range and requirements"""
        try:
            data = request.json
            min_price = float(data.get('min_price', 0))
            max_price = float(data.get('max_price', float('inf')))
            requirements = data.get('requirements', {})
            
            # Load all houses
            houses = load_houses()
            
            # Filter houses by price range
            filtered_houses = []
            for house in houses:
                if min_price <= house['price'] <= max_price:
                    filtered_houses.append(house)
            
            # Score each house based on requirements and get amenities
            scored_houses = []
            for house in filtered_houses:
                lat = house['latitude']
                lon = house['longitude']
                
                # Score the location based on requirements
                location_data = score_location(lat, lon, requirements)
                
                # Get important amenities: hospital, police, school, and nearest metro
                amenities_info = {}
                
                # Get hospital
                hospitals = find_nearby_places(lat, lon, 'hospital', 3000)
                if hospitals:
                    min_dist = min([calculate_distance(lat, lon, 
                                                      h['geometry']['location']['lat'],
                                                      h['geometry']['location']['lng']) 
                                   for h in hospitals])
                    amenities_info['hospital'] = {
                        'distance': round(min_dist, 2),
                        'count': len(hospitals),
                        'name': hospitals[0]['name'] if hospitals else None
                    }
                else:
                    amenities_info['hospital'] = {'distance': None, 'count': 0, 'name': None}
                
                # Get police
                police_stations = find_nearby_places(lat, lon, 'police', 3000)
                if police_stations:
                    min_dist = min([calculate_distance(lat, lon, 
                                                      p['geometry']['location']['lat'],
                                                      p['geometry']['location']['lng']) 
                                   for p in police_stations])
                    amenities_info['police'] = {
                        'distance': round(min_dist, 2),
                        'count': len(police_stations),
                        'name': police_stations[0]['name'] if police_stations else None
                    }
                else:
                    amenities_info['police'] = {'distance': None, 'count': 0, 'name': None}
                
                # Get school
                schools = find_nearby_places(lat, lon, 'school', 2000)
                if schools:
                    min_dist = min([calculate_distance(lat, lon, 
                                                      s['geometry']['location']['lat'],
                                                      s['geometry']['location']['lng']) 
                                   for s in schools])
                    amenities_info['school'] = {
                        'distance': round(min_dist, 2),
                        'count': len(schools),
                        'name': schools[0]['name'] if schools else None
                    }
                else:
                    amenities_info['school'] = {'distance': None, 'count': 0, 'name': None}
                
                # Get nearest metro station
                metro_stations = find_nearby_places(lat, lon, 'metro', 5000)
                if metro_stations:
                    min_dist = min([calculate_distance(lat, lon, 
                                                      m['geometry']['location']['lat'],
                                                      m['geometry']['location']['lng']) 
                                   for m in metro_stations])
                    nearest_metro = min(metro_stations, key=lambda m: calculate_distance(
                        lat, lon, m['geometry']['location']['lat'], m['geometry']['location']['lng']))
                    amenities_info['metro'] = {
                        'distance': round(min_dist, 2),
                        'name': nearest_metro['name']
                    }
                else:
                    amenities_info['metro'] = {'distance': None, 'name': None}
                
                scored_house = {
                    **house,
                    'match_score': location_data['score'],
                    'amenities': amenities_info
                }
                scored_houses.append(scored_house)
            
            # Sort by match score (highest first)
            scored_houses.sort(key=lambda x: x['match_score'], reverse=True)
            
            return jsonify({
                'houses': scored_houses,
                'count': len(scored_houses)
            })
            
        except Exception as e:
            print(f"Error searching houses: {e}")
            import traceback
            traceback.print_exc()
            return jsonify({'error': str(e)}), 500

