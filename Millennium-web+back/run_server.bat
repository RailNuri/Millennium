@echo off
echo Installing required packages...
python -m pip install Flask requests python-dotenv flask-cors
echo.
echo Starting server...
python app.py
pause

