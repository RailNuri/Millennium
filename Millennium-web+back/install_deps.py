import subprocess
import sys

packages = ['Flask', 'requests', 'python-dotenv', 'flask-cors']

print("Installing packages...")
for package in packages:
    print(f"Installing {package}...")
    result = subprocess.run([sys.executable, '-m', 'pip', 'install', package], 
                          capture_output=True, text=True)
    print(result.stdout)
    if result.returncode != 0:
        print(f"Error installing {package}: {result.stderr}")
    else:
        print(f"✓ {package} installed successfully")

print("\nVerifying installation...")
try:
    import flask
    import flask_cors
    import requests
    import dotenv
    print("✓ All packages are installed and can be imported!")
except ImportError as e:
    print(f"✗ Import error: {e}")

