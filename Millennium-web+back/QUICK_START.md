# Quick Start Guide

## Option 1: Install and Run (Recommended)

1. **Open PowerShell or Command Prompt** in this folder

2. **Install dependencies** (run this command):
   ```
   python -m pip install Flask requests python-dotenv flask-cors
   ```

3. **Start the server**:
   ```
   python app.py
   ```

4. **Open your browser** and go to: `http://localhost:5000`

## Option 2: Use the Batch File (Windows)

Double-click `run_server.bat` - it will install dependencies and start the server automatically.

## Troubleshooting

If you get "ModuleNotFoundError":
- Make sure you're using the correct Python (try `python --version`)
- Try: `python -m pip install --upgrade pip` first
- Then install packages: `python -m pip install Flask requests python-dotenv flask-cors`

If port 5000 is already in use:
- Edit `app.py` and change `port=5000` to a different port (e.g., `port=5001`)
- Then access `http://localhost:5001`

## Note about Google Maps API

The app will work with mock data if you don't have a Google Maps API key. To use real data:
1. Get API key from https://console.cloud.google.com/
2. Enable: Maps JavaScript API, Places API, Geocoding API
3. Update the key in `templates/index.html` (line 535)

