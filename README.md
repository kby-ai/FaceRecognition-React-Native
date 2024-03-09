<p align="center">
  <a href="https://play.google.com/store/apps/dev?id=7086930298279250852" target="_blank">
    <img alt="" src="https://github-production-user-asset-6210df.s3.amazonaws.com/125717930/246971879-8ce757c3-90dc-438d-807f-3f3d29ddc064.png" width=500/>
  </a>  
</p>

#### 📚 Product & Resources - [Here](https://github.com/kby-ai/Product)
#### 🛟 Help Center - [Here](https://docs.kby-ai.com)
#### 💼 KYC Verification Demo - [Here](https://github.com/kby-ai/KYC-Verification-Demo-Android)
#### 🙋‍♀️ Docker Hub - [Here](https://hub.docker.com/u/kbyai)

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

> [Face Liveness Detection - Android(Basic SDK)](https://github.com/kby-ai/FaceLivenessDetection-Android)</br>
> [Face Liveness Detection - iOS(Basic SDK)](https://github.com/kby-ai/FaceLivenessDetection-iOS)</br>
> [Face Recognition - Android(Standard SDK)](https://github.com/kby-ai/FaceRecognition-Android)</br>
> [Face Recognition - iOS(Standard SDK)](https://github.com/kby-ai/FaceRecognition-iOS)</br>
> [Face Recognition - Flutter(Standard SDK)](https://github.com/kby-ai/FaceRecognition-Flutter)</br>
> [Face Recognition - React-Native(Standard SDK)](https://github.com/kby-ai/FaceRecognition-React-Native)</br>
> [Face Attribute - Android(Premium SDK)](https://github.com/kby-ai/FaceAttribute-Android)</br>
> [Face Attribute - iOS(Premium SDK)](https://github.com/kby-ai/FaceAttribute-iOS)</br>

## Try the APK

### Google Play

<a href="https://play.google.com/store/apps/details?id=com.kbyai.facerecognition" target="_blank">
  <img alt="" src="https://user-images.githubusercontent.com/125717930/230804673-17c99e7d-6a21-4a64-8b9e-a465142da148.png" height=80/>
</a>

## Performance Video

You can visit our YouTube video [here](https://www.youtube.com/watch?v=YybJW0Nfl4M) to see how well our demo app works.</br>
[![Face Recognition Android](https://img.youtube.com/vi/YybJW0Nfl4M/0.jpg)](https://www.youtube.com/watch?v=YybJW0Nfl4M)


## Screenshots

<p float="left">
  <img src="https://github.com/kby-ai/FaceRecognition-Flutter/assets/125717930/724fa0e5-7d32-45f4-9d63-c192e79c15a0" width=200/>
  <img src="https://github.com/kby-ai/FaceRecognition-Flutter/assets/125717930/ea7f4653-10dc-45d4-a00c-2ae65cfd678b" width=200/>
  <img src="https://github.com/kby-ai/FaceRecognition-Flutter/assets/125717930/f1b0a0cd-5e5d-4b03-9dae-a1d3839eb8ee" width=200/>
</p>

<p float="left">
  
  <img src="https://github.com/kby-ai/FaceRecognition-Flutter/assets/125717930/cd8d4643-cbca-4fc5-b239-574383bbdc88" width=200/>
  <img src="https://github.com/kby-ai/FaceRecognition-Flutter/assets/125717930/763dd8fa-2463-4534-9497-370b4a9dfd62" width=200/>
  <img src="https://github.com/kby-ai/FaceRecognition-Flutter/assets/125717930/26f1c3aa-d90a-4935-af8a-bff6741bbefc" width=200/>
</p>

## SDK License

The face recognition project relies on kby-ai's SDK, which requires a license for each application ID.

- The code below shows how to use the license: https://github.com/kby-ai/FaceRecognition-React-Native/blob/5b8ffdd1fb6956da7e1c1acfd7337f07d621d019/example/src/MainPage.tsx#L17-L24

- To request a license, please contact us:</br>
🧙`Email:` contact@kby-ai.com</br>
🧙`Telegram:` @kbyai</br>
🧙`WhatsApp:` +19092802609</br>
🧙`Skype:` live:.cid.66e2522354b1049b</br>
🧙`Facebook:` https://www.facebook.com/KBYAI</br>
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
