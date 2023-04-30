import os
import requests
from dotenv import load_dotenv
from flask import Flask

app = Flask(__name__)
load_dotenv()

@app.route('/')
def get_weather():
    latitude = os.environ.get('LATITUDE')
    longitude = os.environ.get('LONGITUDE')
    api_key = os.environ.get('OPENWEATHER_API_KEY')
    url = f'https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={api_key}&units=metric'
    response = requests.get(url)
    response_json = response.json()
    weather_description = response_json['weather'][0]['description']
    temperature = response_json['main']['temp']
    feels_like = response_json['main']['feels_like']
    return f'Current weather: {weather_description}, Temperature: {temperature}°C, Feels like: {feels_like}°C'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081)
