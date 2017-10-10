# abc-msface

This repository contains code to use [Microsoft Azure's cognitive services face API](https://docs.microsoft.com/en-us/azure/cognitive-services/face/) to detect faces, facial landmarks etc, and output them in a format suitable for [abc-display-tool](https://github.com/IDInteraction/abc-display-tool).   

To get started, edit the `writeapi.py` file to include your API key.  Run this to generate an `api.p` "pickle" file.  This *should not* be uploaded to git.  

Usage:

```
msface.py [-h] --videofile VIDEOFILE [--outfile OUTFILE] --startframe
         STARTFRAME --endframe ENDFRAME [--APIpickle APIPICKLE]
```

A csv file will be output to `OUTFILE` containing the facial features 
detected.  One row will be output per face per frame

TODO: decide whether to handle multiple faces per frame here, or 
further down the pipeline
