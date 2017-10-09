# Example from https://docs.microsoft.com/en-us/azure/cognitive-services/face/tutorials/faceapiinpythontutorial
# This doesn't seem to authorise with our trial API key

import cognitive_face as CF
import pickle

# Generate api.p using writeapi.py
api_key = pickle.load(open("api.p", "rb"))
CF.Key.set(api_key["subscription_key"])

# You can use this example JPG or replace the URL below with your own URL to a JPEG image.
img_url = 'https://raw.githubusercontent.com/Microsoft/Cognitive-Face-Windows/master/Data/detection1.jpg'
result = CF.face.detect(img_url)
print result
