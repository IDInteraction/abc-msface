# Take a quick look at the results from the MS Face API

library("tidyverse")


facedata <- read_csv("P07_front.msface",
                     col_types = cols(
                       frame = col_integer(),
                       error.code = col_character(),
                       error.message = col_character(),
                       faceAttributes.age = col_double(),
                       faceAttributes.blur.blurLevel = col_character(),
                       faceAttributes.blur.value = col_double(),
                       faceAttributes.emotion.anger = col_double(),
                       faceAttributes.emotion.contempt = col_double(),
                       faceAttributes.emotion.disgust = col_double(),
                       faceAttributes.emotion.fear = col_double(),
                       faceAttributes.emotion.happiness = col_double(),
                       faceAttributes.emotion.neutral = col_double(),
                       faceAttributes.emotion.sadness = col_double(),
                       faceAttributes.emotion.surprise = col_double(),
                       faceAttributes.exposure.exposureLevel = col_character(),
                       faceAttributes.exposure.value = col_double(),
                       faceAttributes.facialHair.beard = col_double(),
                       faceAttributes.facialHair.moustache = col_double(),
                       faceAttributes.facialHair.sideburns = col_double(),
                       faceAttributes.gender = col_character(),
                       faceAttributes.glasses = col_character(),
                       faceAttributes.headPose.pitch = col_double(),
                       faceAttributes.headPose.roll = col_double(),
                       faceAttributes.headPose.yaw = col_double(),
                       faceAttributes.makeup.eyeMakeup = col_character(),
                       faceAttributes.makeup.lipMakeup = col_character(),
                       faceAttributes.noise.noiseLevel = col_character(),
                       faceAttributes.noise.value = col_double(),
                       faceAttributes.occlusion.eyeOccluded = col_character(),
                       faceAttributes.occlusion.foreheadOccluded = col_character(),
                       faceAttributes.occlusion.mouthOccluded = col_character(),
                       faceAttributes.smile = col_double(),
                       faceId = col_character(),
                       faceLandmarks.eyeLeftBottom.x = col_double(),
                       faceLandmarks.eyeLeftBottom.y = col_double(),
                       faceLandmarks.eyeLeftInner.x = col_double(),
                       faceLandmarks.eyeLeftInner.y = col_double(),
                       faceLandmarks.eyeLeftOuter.x = col_double(),
                       faceLandmarks.eyeLeftOuter.y = col_double(),
                       faceLandmarks.eyeLeftTop.x = col_double(),
                       faceLandmarks.eyeLeftTop.y = col_double(),
                       faceLandmarks.eyeRightBottom.x = col_double(),
                       faceLandmarks.eyeRightBottom.y = col_double(),
                       faceLandmarks.eyeRightInner.x = col_double(),
                       faceLandmarks.eyeRightInner.y = col_double(),
                       faceLandmarks.eyeRightOuter.x = col_double(),
                       faceLandmarks.eyeRightOuter.y = col_double(),
                       faceLandmarks.eyeRightTop.x = col_double(),
                       faceLandmarks.eyeRightTop.y = col_double(),
                       faceLandmarks.eyebrowLeftInner.x = col_double(),
                       faceLandmarks.eyebrowLeftInner.y = col_double(),
                       faceLandmarks.eyebrowLeftOuter.x = col_double(),
                       faceLandmarks.eyebrowLeftOuter.y = col_double(),
                       faceLandmarks.eyebrowRightInner.x = col_double(),
                       faceLandmarks.eyebrowRightInner.y = col_double(),
                       faceLandmarks.eyebrowRightOuter.x = col_double(),
                       faceLandmarks.eyebrowRightOuter.y = col_double(),
                       faceLandmarks.mouthLeft.x = col_double(),
                       faceLandmarks.mouthLeft.y = col_double(),
                       faceLandmarks.mouthRight.x = col_double(),
                       faceLandmarks.mouthRight.y = col_double(),
                       faceLandmarks.noseLeftAlarOutTip.x = col_double(),
                       faceLandmarks.noseLeftAlarOutTip.y = col_double(),
                       faceLandmarks.noseLeftAlarTop.x = col_double(),
                       faceLandmarks.noseLeftAlarTop.y = col_double(),
                       faceLandmarks.noseRightAlarOutTip.x = col_double(),
                       faceLandmarks.noseRightAlarOutTip.y = col_double(),
                       faceLandmarks.noseRightAlarTop.x = col_double(),
                       faceLandmarks.noseRightAlarTop.y = col_double(),
                       faceLandmarks.noseRootLeft.x = col_double(),
                       faceLandmarks.noseRootLeft.y = col_double(),
                       faceLandmarks.noseRootRight.x = col_double(),
                       faceLandmarks.noseRootRight.y = col_double(),
                       faceLandmarks.noseTip.x = col_double(),
                       faceLandmarks.noseTip.y = col_double(),
                       faceLandmarks.pupilLeft.x = col_double(),
                       faceLandmarks.pupilLeft.y = col_double(),
                       faceLandmarks.pupilRight.x = col_double(),
                       faceLandmarks.pupilRight.y = col_double(),
                       faceLandmarks.underLipBottom.x = col_double(),
                       faceLandmarks.underLipBottom.y = col_double(),
                       faceLandmarks.underLipTop.x = col_double(),
                       faceLandmarks.underLipTop.y = col_double(),
                       faceLandmarks.upperLipBottom.x = col_double(),
                       faceLandmarks.upperLipBottom.y = col_double(),
                       faceLandmarks.upperLipTop.x = col_double(),
                       faceLandmarks.upperLipTop.y = col_double(),
                       faceRectangle.height = col_double(),
                       faceRectangle.left = col_double(),
                       faceRectangle.top = col_double(),
                       faceRectangle.width = col_double()
                     ))

# Error frames
facedata %>% 
  filter(!is.na(error.code))
# Hitting rate limit - this was set, but appears to be using
# free tier limit, not paid for 


# Faces per frame:
facedata %>% 
  group_by(frame) %>% 
  summarise(num_faces = n()) %>% 
  filter(num_faces != 1)

# Clean bad data and generate face rectangle area
faceclean <- facedata %>% 
  filter(is.na(error.code)) %>% 
  mutate(faceRectangle.area = faceRectangle.height * faceRectangle.width)

  
faceclean %>% ggplot(aes(x = frame, y = faceRectangle.area)) + geom_point()

faceclean %>% ggplot(aes(x = frame)) + geom_point(aes(y = faceRectangle.left), colour = "red") +
  geom_point(aes(y = faceRectangle.top), colour = "green") 

faceclean %>% ggplot(aes(x = frame, y=faceAttributes.emotion.neutral)) + geom_point() + geom_line()

faceclean %>% ggplot(aes(x = frame, y = faceAttributes.age)) + geom_point() + geom_line()

faceclean %>% ggplot(aes(x = frame)) + geom_point(aes(y = faceLandmarks.pupilLeft.y), colour = "red") +
  geom_point(aes(y = faceLandmarks.pupilRight.y), colour = "green") 

faceclean %>% ggplot(aes(x = frame)) + geom_point(aes(y=faceLandmarks.pupilLeft.x), colour = "red") +
  geom_point(aes(y = faceLandmarks.pupilRight.x), colour = "green") 


