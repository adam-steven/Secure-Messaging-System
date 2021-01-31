import os
import sys
import cv2
import numpy as np
import time
import subprocess as sproc
import string
import random

#generate a random number string of (length)
#for file ID system
def get_random_string(length):
    letters = string.digits
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str

#check for movement and find moving object position
def checkForMovement(frame1, frame2, previousDetection):
    lineToCenter = -1
    maxContourArea = 0
    #if the number of contours is >= maxContoursLimit the camera wont move
    maxContoursLimit = 4
    contoursOnLine = []
    #amount to rotate limit (64 = 1/8 of a full rotation)
    atrl = 64

    #get the differences between the 2 frames
    diff = cv2.absdiff(frame1, frame2)
    #change colour to gray
    gray = cv2.cvtColor(diff, cv2.COLOR_BGR2GRAY)
    #blur the black and gray image to reduce noise
    blur = cv2.GaussianBlur(gray, (5,5), 0)
    #get all gray clusters still in the image
    _, thresh = cv2.threshold(blur, 20, 255, cv2.THRESH_BINARY)
    #fill in any hole in the clusters
    dilated = cv2.dilate(thresh, None, iterations=3)
    #calculate the edges of the clusters
    _, contours, _ = cv2.findContours(dilated, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    #get the horizontal screen resolution
    screenWidth = cap.get(3)

    #loop through every found cluster
    for contour in contours:
        #get the current clustes x position and width (y and height are not used)
        (x, _, w, _) = cv2.boundingRect(contour)

        #verify the current cluster is large enough to count
        if cv2.contourArea(contour) < 800:
            continue

        #calculate the horizontal center of the cluster
        aligment = int(x + (w/2))
        #calculate the clusters position relitive to the resolution (orginised into 10 screen sections)
        lineOnScreen = round((aligment/screenWidth) * 10)
        
        #if the current clusters position section has not been found in the current detection add it the a list 
        if lineOnScreen not in contoursOnLine: 
            contoursOnLine.append(lineOnScreen)
        #check to find the biggest cluster in the current detection
        if cv2.contourArea(contour) > maxContourArea:
            maxContourArea = cv2.contourArea(contour)
            lineToCenter = lineOnScreen

    #procced if
    #any clusters were found
    #the biggest clusters position section is not the same as the preveous detections'
    #the contoursOnLine list dose not have too many entries (moving objects found all over the screen)
    if lineToCenter > -1 and lineToCenter != previousDetection and len(contoursOnLine) < maxContoursLimit:
        #check if the object in on the left half of the screen
        if lineToCenter < 5:
            #calculate rotation amount needed 
            lineToCenter = 5 - lineToCenter
            neededRotation = round(atrl * (lineToCenter/5))
            #run the clockwise user application function on the termenal (on a seperate "PIPE" to not stop this application)
            sproc.Popen(['sudo', './stepmotor', 'clockwise', str(neededRotation)], stdout=sproc.PIPE, stderr=sproc.PIPE)
        #check if the object in on the right half of the screen
        elif lineToCenter > 5:
            #calculate rotation amount needed
            lineToCenter = lineToCenter - 5
            neededRotation = round(atrl * (lineToCenter/5))
            #run the anticlockwise user application function on the termenal (on a seperate "PIPE" to not stop this application)
            sproc.Popen(['sudo', './stepmotor', 'anticlockwise', str(neededRotation)], stdout=sproc.PIPE, stderr=sproc.PIPE)

    #return the current biggest clusters position section for the next detection
    return lineToCenter

#cature the camera images - setting new frame 1s & 2s. records and uploads file
def readCapture(batchid, dns):
    
    #frame_rate of 1 = 1 detection call every second
    frame_rate = 1
    prev = 0.0
    detection = -1
    
    #set the frame readings to the first captured frame
    _, frame1 = cap.read()
    _, frame2 = cap.read()
    
    #set the codec
    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    
    isRecording = False
    #with 1 detection test a second, this limit stops the recording after 30 secs of no movement
    failedDetectionLimit = 30 
    failedDetection = 0
    #to add some order to video names
    recordingIndex = 0 
    #for creating unique video names
    recordingBatchID = batchid + '_' 
    
    while cap.isOpened():

        #set frame2 (newest capture) to frame1 (last capture) and reset frame2 to the current captured frame
        frame1 = frame2
        _, frame2 = cap.read()

        #timer to proceed every (frame_rate) seconds
        time_elapsed = time.time() - prev
        if time_elapsed > 1./frame_rate:
            prev = time.time()

            #call detection function and set the new biggest clusters position section to "detection"
            detection = checkForMovement(frame1, frame2, detection)
            #check if any objects were found
            if detection > -1:
                print("detected")
                #reset failedDetection counter
                failedDetection = 0
                #check if the program is not currently recording
                if isRecording == False:
                    #start recording
                    isRecording = True
                    print('recording started')
                    #add 1 to the last videos name to prevent over writing
                    recordingIndex += 1
                    #set the current videos spesifications
                    out = cv2.VideoWriter('tempRecordings/'+recordingBatchID+str(recordingIndex)+'.avi', fourcc, 10.0, (640,480))
            #if no objects were found
            else:
                print("nothing")
                #increment failedDetection counter
                failedDetection += 1
                #check if failedDetection counter is above failedDetectionLimit and the proceeding code has not ran (failedDetection < (failedDetectionLimit + 10))
                if failedDetection > failedDetectionLimit and failedDetection < (failedDetectionLimit + 10) :
                    #stop recording
                    isRecording = False
                    #indicate this code has  ran
                    failedDetection += 20
                    print('recording stopped')
                    #delete the current videos spesifications
                    out.release()
                    #upload the file to aws through the terminal and delete the file
                    #not on a different "PIPE" as "file is a file" errors appear -_-
                    awsPost = sproc.run('scp -o StrictHostKeyChecking=no -i piZeroKey.pem tempRecordings/'+recordingBatchID+str(recordingIndex)+'.avi ec2-user@'+dns+':/var/www/html/videos && rm tempRecordings/'+recordingBatchID+str(recordingIndex)+'.avi', shell=True, capture_output=True)
                    print(awsPost)

        #check if recording has started
        if isRecording:
            #write the current frame to the spesified file
            out.write(frame1)
        
        #display the camera view on the pi
        cv2.imshow("feed", frame1)
               
        #if "q" is pressed end the application
        if cv2.waitKey(20) & 0xFF == ord('q'):
            break

    print("Force Exit")
    #remove the LKM through the terminal
    rmRes = sproc.run('sudo rmmod motorLKM.ko', shell=True, capture_output=True)
    print(rmRes)
    
    #delete the current videos spesifications and release the camera 
    out.release()
    cap.release()
    cv2.destroyAllWindows()

#check that the user has included the aws DNS before running
if len(sys.argv) == 2:
    #save aws DNS argument for peramiter passing
    aws_dns = sys.argv[1]
    #create this runs unique file names
    vBatchID = 'vbatch' + str(get_random_string(16))

    print("starting " +vBatchID)

    #check if "tempRecordings" file exist and create it if it does not
    #"tempRecordings" hold the videos files before they're sent to aws
    if not os.path.exists('tempRecordings'):
        os.makedirs('tempRecordings')

    #insert the LKM through the terminal
    isnRes = sproc.run('sudo insmod motorLKM.ko', shell=True, capture_output=True)
    print(isnRes)

    #request and take the camera
    cap = cv2.VideoCapture(0)
    #set the detection resolution (set to imporve performace, not needed otherwise)
    cap.set(3, 640)
    cap.set(4, 480)

    #start the camera capture readings
    readCapture(vBatchID, aws_dns)
else:
    print("aws dns required")
