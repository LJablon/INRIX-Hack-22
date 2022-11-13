import requests
from credentials_manager import CredentialsManager
#import matplotlib.pyplot as plt
from shapely.geometry import Point, Polygon

# x = []
# y = []
# for i, j in coords:
#   x.append(i)
#   y.append(j)

class DrivePolygon:
  def __init__(self, time_length, target_location):
    self.generate(time_length, target_location)

  def generate(self, time_length, target_location):
    ### Fetching
    Token = CredentialsManager().get_token()[0]

    url = "https://api.iq.inrix.com/drivetimePolygons?center=" + str(target_location[0]) + "%7C" + str(target_location[1]) + "&rangeType=A&duration=42"

    payload={}
    headers = {
    'Authorization': 'Bearer' + Token
    }

    response = requests.request("GET", url, headers=headers, data=payload)

    ### Parsing
    coords_string = response.text[314:(len(response.text) - 75)]
    coords1D = coords_string.split(' ')
    coords = []
    for i in range(0, len(coords1D), 2):
      coords.append((float(coords1D[i]), float(coords1D[i+1])))
    print(coords)


    ### Turn into Shapely Object
    self.poly = Polygon(coords)

  def check(self, my_coords):
    p = Point(float(my_coords[0]), float(my_coords[1]))
    return p.within(self.poly)


# c = ('37.770315', '-122.446527')
# test = DrivePolygon(54.44, c)

# print(test.poly)

# print(test.check(('37.770315', '-122.446527')))


