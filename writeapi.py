import pickle

# Pickle the API key, so we can load this in without
# committing it to github
# DON'T commit this file or the pickle object
api_details = {
        "subscription_key" : 'PUT YOUR API KEY HERE',
        "uri_base" : 'westcentralus.api.cognitive.microsoft.com'}

pickle.dump(api_details, open("api.p","wb"))
quit()
