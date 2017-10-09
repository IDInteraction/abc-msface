# Example from https://docs.microsoft.com/en-gb/azure/cognitive-services/face/quickstarts/python#detect-faces-in-images-with-face-api-using-python-a-namedetect-a
import httplib, urllib, base64, json
import pickle

# Generate api.p using writeapi.py
api_key = pickle.load(open("api.p", "rb"))

headers = {
    'Content-Type': 'application/octet-stream',
    'Ocp-Apim-Subscription-Key': api_key["subscription_key"],
}

# Request parameters.
params = urllib.urlencode({
    'returnFaceId': 'true',
    'returnFaceLandmarks': 'false',
    'returnFaceAttributes': 'age,gender,headPose,smile,facialHair,glasses,emotion,hair,makeup,occlusion,accessories,blur,exposure,noise',
})

# The URL of a JPEG image to analyze.
#body = "{'url':'https://upload.wikimedia.org/wikipedia/commons/c/c3/RH_Louise_Lillian_Gish.jpg'}"
body = open("frames/output_0150.png", "rb").read()
try:
    # Execute the REST API call and get the response.
    conn = httplib.HTTPSConnection(api_key["uri_base"])
    conn.request("POST", "/face/v1.0/detect?%s" % params, body, headers)
    response = conn.getresponse()
    data = response.read()

    # 'data' contains the JSON data. The following formats the JSON data for display.
    parsed = json.loads(data)
    print ("Response:")
    print (json.dumps(parsed, sort_keys=True, indent=2))
    conn.close()

except Exception as e:
    print("[Errno {0}] {1}".format(e.errno, e.strerror))

####################################

