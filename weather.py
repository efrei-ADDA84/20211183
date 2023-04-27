import os
import requests
from dotenv import load_dotenv

load_dotenv()
# Function to get the current weather information for the given latitude and longitude
def get_current_weather(latitude, longitude, api_key):
    url = f'https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={api_key}&units=metric'
    response = requests.get(url)
    response_json = response.json()
    weather_description = response_json['weather'][0]['description']
    temperature = response_json['main']['temp']
    feels_like = response_json['main']['feels_like']
    return f'Current weather: {weather_description}, Temperature: {temperature}°C, Feels like: {feels_like}°C'

# Retrieve latitude, longitude, and API key from environment variables
latitude = os.environ.get('LATITUDE')
longitude = os.environ.get('LONGITUDE')
api_key = os.environ.get('OPENWEATHER_API_KEY')

# Call the function to get the current weather information
print(get_current_weather(latitude, longitude, api_key))
