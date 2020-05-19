import geocoder
import requests
import json

try:
    g = geocoder.ip("me")
    coords = g.latlng

    r = requests.get("https://api.openweathermap.org/data/2.5/weather?",
            params={"APPID": "9f9bafb4b64c925b890a6580d94cb025", "lat": coords[0],
                "lon": coords[1], "units": "imperial"})
    print("{} degrees and {}, with {}% humidity".format(r.json()["main"]["temp"], 
        r.json()["weather"][0]["description"], r.json()["main"]["humidity"]))
except:
    print("weather unavailable")
