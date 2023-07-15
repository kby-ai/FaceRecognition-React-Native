<p align="center">
  <a href="https://play.google.com/store/apps/dev?id=7086930298279250852" target="_blank">
    <img alt="" src="https://github-production-user-asset-6210df.s3.amazonaws.com/125717930/246971879-8ce757c3-90dc-438d-807f-3f3d29ddc064.png" width=500/>
  </a>  
</p>

👏 Product List

https://github.com/kby-ai/Product

👏  We have published the Face Liveness Detection, Face Recognition SDK and ID Card Recognition SDK for the server.

  - [FaceLivenessDetection-Docker](https://github.com/kby-ai/FaceLivenessDetection-Docker)

  - [FaceRecognition-Docker](https://github.com/kby-ai/FaceRecognition-Docker)

  - [IDCardRecognition-Docker](https://github.com/kby-ai/IDCardRecognition-Docker)

# FaceRecognition-React-Native

## Overview

This project is a Face Recognition and Face Liveness Detection project for Flutter.

> The demo is integrated with KBY-AI's Standard Face Mobile SDK.

  | Basic      | Standard | Premium |
  |------------------|------------------|------------------|
  | Face Detection        | Face Detection    | Face Detection |
  | Face Liveness Detection        | Face Liveness Detection    | Face Liveness Detection |
  | Pose Estimation        | Pose Estimation    | Pose Estimation |
  |         | Face Recognition    | Face Recognition |
  |         |         | 68 points Face Landmark Detection |
  |         |         | Face Quality Calculation |
  |         |         | Face Occlusion Detection |
  |         |         | Eye Closure Detection |
  |         |         | Age, Gender Estimation |

> [Face Liveness Detection - Android(Basic SDK)](https://github.com/kby-ai/FaceLivenessDetection-Android)
> 
> [Face Liveness Detection - iOS(Basic SDK)](https://github.com/kby-ai/FaceLivenessDetection-iOS)
> 
> [Face Recognition - Android(Standard SDK)](https://github.com/kby-ai/FaceRecognition-Android)
> 
> [Face Recognition - iOS(Standard SDK)](https://github.com/kby-ai/FaceRecognition-iOS)
> 
> [Face Recognition - Flutter(Standard SDK)](https://github.com/kby-ai/FaceRecognition-Flutter)
>
> [Face Recognition - React-Native(Standard SDK)](https://github.com/kby-ai/FaceRecognition-React-Native)
>
> [Face Attribute - Android(Premium SDK)](https://github.com/kby-ai/FaceAttribute-Android)
> 
> [Face Attribute - iOS(Premium SDK)](https://github.com/kby-ai/FaceAttribute-iOS)

## Try the APK

### Google Play

<a href="https://play.google.com/store/apps/details?id=com.kbyai.facerecognition" target="_blank">
  <img alt="" src="https://user-images.githubusercontent.com/125717930/230804673-17c99e7d-6a21-4a64-8b9e-a465142da148.png" height=80/>
</a>

### Google Drive

https://drive.google.com/file/d/1cn_89fYDYhq8ANXs2epO-KBv7p5ZnWcA/view?usp=sharing

## Screenshots

<p float="left">
  <img src="https://user-images.githubusercontent.com/125717930/232038080-fb3a9bbb-dbc3-4d17-ac40-e14d83f4253a.png" width=300/>
  <img src="https://user-images.githubusercontent.com/125717930/232038075-8d35cc96-7b0e-4a42-80a5-32a9efca33ee.png" width=300/>
</p>

<p float="left">
  <img src="https://user-images.githubusercontent.com/125717930/232038058-8ac20b97-ec60-4986-b467-fffd15e3b2ea.png" width=300/>
  <img src="https://user-images.githubusercontent.com/125717930/232038066-aad39f28-3432-4822-8da1-a9f80da39e7f.png" width=300/>
</p>

<p float="left">
  <img src="https://user-images.githubusercontent.com/125717930/232038042-1f377ccd-4b9e-462c-a071-ddf1c133ce97.png" width=300/>
  <img src="https://user-images.githubusercontent.com/125717930/232038055-aa149d97-1362-4d36-b4d9-91aab6766d36.png" width=300/>
</p>

## SDK License

The face recognition project relies on kby-ai's SDK, which requires a license for each application ID.

- The code below shows how to use the license: https://github.com/kby-ai/FaceRecognition-Flutter/blob/0ed0fea9f86d73d08aff81e25da479c62f2ebc05/lib/main.dart#L68-L94

- To request a license, please contact us:
```
Email: contact@kby-ai.com

Telegram: @kbyai

WhatsApp: +19092802609

Skype: live:.cid.66e2522354b1049b
```

## How To Run
### 1. React-Native Setup
  Make sure you have React-Native installed. 

  If you don't have React-Native installed, please follow the instructions provided in the official React-Native documentation: https://reactnative.dev/docs/environment-setup
  
### 2. Running the App

  Run the following commands:
  
  ```
  yarn
  yarn example android
  ```
## About SDK
### 1. Setup
### 1.1 'Face SDK' Setup
  > Android

  -  Copy the SDK (libfacesdk folder) to the 'android' folder of your project.

  -  Add SDK to the project in settings.gradle
  ```
  include ':libfacesdk'
  ```
### 2 API Usages
#### 2.1 FaceSDKModule
  - Activate the 'FaceSDKModule' by calling the 'setActivation' method:
  ```
        var ret = await FaceSDKModule.setActivation("...");
        console.log("set activation:", ret);
  ```
  - Initialize the 'FaceSDKModule' by calling the 'initSDK' method:
  ```
      var ret = await FaceSDKModule.initSDK();
  ```
  - Set parameters using the 'setParam' method:
  ```
    var ret = await FaceSDKModule.setParam(checkLivenessLevel);
  ```
  - Extract faces using the 'extractFaces' method:
  ```
    var faceBoxes = await FaceSDKModule.extractFaces(uri);
  ```
  - Calculate similarity between faces using the 'similarityCalculation' method:
  ```
    const similarity = await FaceSDKModule.similarityCalculation(
        face.templates,
        person.templates
    );
  ```
#### 2.2 FaceRecognitionSdkView
  - To build the native camera screen and process face detection, please refer to the [example/src/FaceRecognitionPage.tsx](https://github.com/kby-ai/FaceRecognition-React-Native/blob/main/example/src/FaceRecognitionPage.tsx) file in the repository. 
  
```
  <FaceRecognitionSdkView style={styles.box} livenessLevel={1} cameraLens={1} />
```

 - To obtain the face detection results, use the following code:
```
      const eventEmitter = new NativeEventEmitter(FaceSDKModule);
      let eventListener = eventEmitter.addListener('onFaceDetected', (event) => {
          setFaces(event);
          if (recognized == false) {
              identifyPerson(event);
          }
      });
```

  - To start and stop the camera, use the following code:
```
    //Start Camera
    const startCamera = async () => {
        await FaceSDKModule.startCamera();
    }

    //Stop Camera
    const stopCamera = async () => {
        await FaceSDKModule.stopCamera();
    }
```
