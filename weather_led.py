import json
import requests
import board
import neopixel
import time

pixels = neopixel.NeoPixel(board.D21, 8, brightness=0.1, auto_write=False, pixel_order=neopixel.RGB)

# make a env file to store your API key!
API_KEY = None
with open("env.json", 'r') as env:
    env_var = json.loads(env.read())
    API_KEY = env_var['API_KEY']

# locations can be passed as zip, country pairs, or sometimes by name.
# I don't know why it sometimes didn't work one way or the other, so I've
# just hard coded some cities for testing purposes
cities = {"shelburne": "zip=01370,us", "new_york": "zip=10027,us", "kunming": "q=kunming,cn", "london": "q=london,uk"}
request = 'http://api.openweathermap.org/data/2.5/weather?{}&units=imperial&appid={}'.format(cities["new_york"],
                                                                                             API_KEY)
icon = ""
temp = 0
wind_speed = 0

response = requests.get(request)
if response.status_code == 200:
    city_weather_dict = response.json()

    # icon code modulates brightness
    # using the icons as they provide the most standardized info across weather types and day/night status
    # 01, 02, 03, 04, 09, 10, 11, 13, 50 icon codes from least to most overcast
    # icon = city_weather_dict['weather'][0]['icon']
    # print(icon)

    # temperature modulates color -- cooler temp = cooler tones
    # temperatures returned in fahrenheit
    temp = city_weather_dict['main']['temp']

    # wind_speed modulates rate at which the lights change
    wind_speed = city_weather_dict['wind']['speed']
    print(wind_speed)


# returns a list of colors
def calculate_colors(temp):
    color_list = []

    # warm tones modulate G140->215 R215 B8
    if temp > 70:
        g = 140
        r = 215
        b = 8
        step = -2 * temp + 225
        for i in range(8):
            color_list.append((g, r, b))
            g += step // 8

    # cool tones modulate red and green 
    elif temp > 40:
        g = 120
        r = 235
        b = 8

        step = int(- (3 / 5) * temp + 44)
        for i in range(8):
            color_list.append((g, r, b))
            r -= step // 8
            b += 246 // 8

    # cold tones modulate blue
    else:
        g = 225
        r = 79
        b = int(temp) + 150
        for i in range(8):
            color_list.append((g, r, b))
            if b <= 225:
                g -= 5
            else:
                b -= 5
    return color_list


colors = calculate_colors(temp)
while True:
    shift = 0
    for i in range(8):
        pixels[i] = colors[i + shift // 8]
    pixels.show()

    # dictated by wind speed
    time.sleep(0.005)
    if shift is not 7:
        shift += 1
    else:
        shift = 0
