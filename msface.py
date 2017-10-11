#!/usr/bin/python
# Example from https://docs.microsoft.com/en-gb/azure/cognitive-services/face/quickstarts/python#detect-faces-in-images-with-face-api-using-python-a-namedetect-a
import httplib, urllib, base64, json
import pickle
import pandas as pd
import argparse
import cv2
import sys
from limit import limit
import os
import tempfile

class APIException(Exception):
    def __init__(self, value):
        self.parameter = value
    def __str__(self):
        return repr(self.parameter)

@limit(10,1)
def getFaceInfo(infile):
    headers = {
        'Content-Type': 'application/octet-stream',
        'Ocp-Apim-Subscription-Key': api_key["subscription_key"],
    }

    # Request parameters.
    params = urllib.urlencode({
        'returnFaceId': 'true',
        'returnFaceLandmarks': 'true',
        'returnFaceAttributes': 'age,gender,headPose,smile,facialHair,glasses,emotion,makeup,occlusion,blur,exposure,noise',
    })

    # The URL of a JPEG image to analyze.
    #body = "{'url':'https://upload.wikimedia.org/wikipedia/commons/c/c3/RH_Louise_Lillian_Gish.jpg'}"
    try:
        body = open(infile, "rb").read()
        # Execute the REST API call and get the response.
        conn = httplib.HTTPSConnection(api_key["uri_base"])
        conn.request("POST", "/face/v1.0/detect?%s" % params, body, headers)
        response = conn.getresponse()
        data = response.read()

        # 'data' contains the JSON data. The following formats the JSON data for display.
        parsed = json.loads(data)

        if 'error.code' in parsed:
            raise APIException("Error code found in returned data")

        conn.close()

    except Exception as e:
        print("[Errno {0}] {1}".format(e.errno, e.strerror))

    return parsed

parser = argparse.ArgumentParser(description = "Send video frames to MS Face API and return API results to a csv")
parser.add_argument("--videofile", help = "The input video to send to the MS Face API", required = True)
parser.add_argument("--outfile", required = False,
        help = "Optional output filename.  Will be --videofile with .msface by default (ignoring the path of --videofile)")
parser.add_argument("--startframe",
        help = "The first frame to send to the API", required = True,
        type  = int)
parser.add_argument("--endframe",
         help = "The final frame to send to the API", required = True,
         type = int)
parser.add_argument("--APIpickle", help = "A pickle containing the API key and region", default = "api.p")

args = parser.parse_args()
if args.endframe < args.startframe:
    print("Invalid frame range")
    sys.exit()

if args.outfile is None:
   args.outfile = os.path.splitext(os.path.basename(args.videofile))[0] + ".msface" 

# You should generate api.p using writeapi.py
api_key = pickle.load(open(args.APIpickle, "rb"))

video = cv2.VideoCapture(args.videofile)
trackingdata = pd.DataFrame()

for frame in range(args.startframe, args.endframe + 1):
    video.set(cv2.cv.CV_CAP_PROP_POS_FRAMES, frame)
    ret, img = video.read()
    if ret == False:
        print("Failed to capture frame %s" % frame)
        
    videoimg = tempfile.NamedTemporaryFile(suffix = ".png")
    cv2.imwrite(videoimg.name, img)
    print("Captured frame %s" % frame)

    apiresp = getFaceInfo(videoimg.name)
    # print (json.dumps(apiresp, sort_keys=True, indent=2))
    if len(apiresp) > 0:
        df = pd.io.json.json_normalize(apiresp)
    else:
        print("No face found for frame %d" % frame)
    df["frame"] = frame
    df.set_index("frame", inplace = True)

    trackingdata = trackingdata.append(df, ignore_index = False)
    
trackingdata.to_csv(args.outfile)


