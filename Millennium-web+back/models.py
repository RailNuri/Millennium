"""Data models and house management functions"""
import json
import os
from datetime import datetime
from config import HOUSES_FILE, AZERBAIJAN_BOUNDS
from utils import is_in_azerbaijan

def load_houses():
    """Load houses from JSON file"""
    try:
        if os.path.exists(HOUSES_FILE):
            with open(HOUSES_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        return []
    except Exception as e:
        print(f"Error loading houses: {e}")
        return []

def save_houses(houses):
    """Save houses to JSON file"""
    try:
        with open(HOUSES_FILE, 'w', encoding='utf-8') as f:
            json.dump(houses, f, indent=2, ensure_ascii=False)
        return True
    except Exception as e:
        print(f"Error saving houses: {e}")
        return False

def calculate_quality_scores(houses):
    """Calculate quality scores for houses based on price"""
    if not houses:
        return
    
    prices = [h['price'] for h in houses]
    min_p = min(prices)
    max_p = max(prices)
    price_range = max_p - min_p if max_p > min_p else 1
    
    for house in houses:
        if price_range > 0:
            score = 100 - ((house['price'] - min_p) / price_range * 100)
        else:
            score = 50
        house['quality_score'] = round(score, 2)

