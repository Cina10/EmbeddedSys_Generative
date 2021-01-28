import json
import requests

# make a env file to store your API key!
API_KEY = None
with open("env.json", 'r') as env:
    env_var = json.loads(env.read())
    API_KEY = env_var['API_KEY']

# locations can be passed as zip, country pairs, or sometimes by name.
# I don't know why it sometimes didn't work one way or the other, so I've
# just hard coded some cities for testing purposes
cities = {"shelburne": "zip=01370,us", "new_york": "zip=10027,us", "kunming": "q=kunming,cn", "london": "q=london,uk"}
request = 'http://api.openweathermap.org/data/2.5/weather?{}&units=imperial&appid={}'.format(cities["new_york"], API_KEY)
print(request)
response = requests.get(request)
if response.status_code == 200:
    city_weather_dict = response.json()

    # icon code modulates brightness
    # using the icons as they provide the most standardized info across weather types and day/night status
    # 01, 02, 03, 04, 09, 10, 11, 13, 50 icon codes from least to most overcast
    icon = city_weather_dict['weather'][0]['icon']

    # temperature modulates color -- cooler temp = cooler tones
    # temperatures returned in fahrenheit
    temp = city_weather_dict['main']['temp']

    # wind_speed modulates rate at which the lights change
    wind_speed = city_weather_dict['wind']['speed']

