This is a new [**React Native**](https://reactnative.dev) project, bootstrapped using [`@react-native-community/cli`](https://github.com/react-native-community/cli).

# Getting Started

>**Note**: Make sure you have completed the [React Native - Environment Setup](https://reactnative.dev/docs/environment-setup) instructions till "Creating a new application" step, before proceeding.

## Step 1: Start the Metro Server

First, you will need to start **Metro**, the JavaScript _bundler_ that ships _with_ React Native.

To start Metro, run the following command from the _root_ of your React Native project:

```bash
# using npm
npm start

# OR using Yarn
yarn start
```

## Step 2: Start your Application

Let Metro Bundler run in its _own_ terminal. Open a _new_ terminal from the _root_ of your React Native project. Run the following command to start your _Android_ or _iOS_ app:

### For Android

```bash
# using npm
npm run android

# OR using Yarn
yarn android
```

### For iOS

```bash
# using npm
npm run ios

# OR using Yarn
yarn ios
```

If everything is set up _correctly_, you should see your new app running in your _Android Emulator_ or _iOS Simulator_ shortly provided you have set up your emulator/simulator correctly.

This is one way to run your app — you can also run it directly from within Android Studio and Xcode respectively.

## Step 3: Modifying your App

Now that you have successfully run the app, let's modify it.

1. Open `App.tsx` in your text editor of choice and edit some lines.
2. For **Android**: Press the <kbd>R</kbd> key twice or select **"Reload"** from the **Developer Menu** (<kbd>Ctrl</kbd> + <kbd>M</kbd> (on Window and Linux) or <kbd>Cmd ⌘</kbd> + <kbd>M</kbd> (on macOS)) to see your changes!

   For **iOS**: Hit <kbd>Cmd ⌘</kbd> + <kbd>R</kbd> in your iOS Simulator to reload the app and see your changes!

## Congratulations! :tada:

You've successfully run and modified your React Native App. :partying_face:

### Now what?

- If you want to add this new React Native code to an existing application, check out the [Integration guide](https://reactnative.dev/docs/integration-with-existing-apps).
- If you're curious to learn more about React Native, check out the [Introduction to React Native](https://reactnative.dev/docs/getting-started).

# Troubleshooting

If you can't get this to work, see the [Troubleshooting](https://reactnative.dev/docs/troubleshooting) page.

# Learn More

To learn more about React Native, take a look at the following resources:

- [React Native Website](https://reactnative.dev) - learn more about React Native.
- [Getting Started](https://reactnative.dev/docs/environment-setup) - an **overview** of React Native and how setup your environment.
- [Learn the Basics](https://reactnative.dev/docs/getting-started) - a **guided tour** of the React Native **basics**.
- [Blog](https://reactnative.dev/blog) - read the latest official React Native **Blog** posts.
- [`@facebook/react-native`](https://github.com/facebook/react-native) - the Open Source; GitHub **repository** for React Native.



_Last updated: July 21, 2025_

# FaceRecognition-React-Native Setup Guide

## Steps to Integrate FaceSDK.framework and Build the iOS Project Successfully

1. **Open Project Workspace in Xcode**  
   Open the `.xcworkspace` file (not `.xcodeproj`) using Xcode.

2. **Add FaceSDK.framework to the Project**  
   - In the Xcode Project Navigator, right-click on your project folder (top-level blue icon).  
   - Choose **"Add Files to '[YourProjectName]'"**.  
   - Navigate to the root-level `ios` folder of your project.  
   - Select the `FaceSDK.framework` folder and click **Add**.

3. **Set the Correct Team for Code Signing**  
   - In the left pane, click on your project name (top of the file list).  
   - Under the **Targets** section, select your app target.  
   - Go to the **Signing & Capabilities** tab.  
   - In the **Team** dropdown, select your registered Apple Developer team.

4. **Sign in with Apple Developer Account (if needed)**  
   If no team appears or the correct one is missing:  
   - Go to **Xcode > Settings > Accounts**.  
   - Click the **"+"** button and log in with your Apple Developer credentials.

5. **Build the Project**  
   After adding the framework and setting the team, build the project using **Cmd + B**.

---

## Steps to build Android Project from dev Successfully

1. **Open Project Workspace in VSCode**  
   
2. **At root level install node_modules**  
   - In the root directory, install node_modules by **npm install**  
    // `FaceRecognition-React-Native-dev> npm install`

3. **Goto example directory**  
   -  Go to the example directory by **cd example** 
    // `FaceRecognition-React-Native-dev> cd example`

4. **In example directory install node_modules**  
   - In the root directory, install node_modules by **npm install**  
    // `FaceRecognition-React-Native-dev/example> npm install`
   
5. **Build the Project**  
   - In the example directory build the project by **npx react-native run-android**  
   // `FaceRecognition-React-Native-dev/example> npx react-native run-android`

---


## Steps to Run FaceRecognition-React-Native-main_old (For Android)

1. In the root directory, run `npm install`  
   `FaceRecognition-React-Native-main_old> npm install`

2. Go to the example directory  
   `FaceRecognition-React-Native-main_old> cd example`

3. In the example directory, run `npm install` again  
   `FaceRecognition-React-Native-main_old/example> npm install`

4. In the example directory, run "npx react-native run-android"  
   // FaceRecognition-React-Native-main_old/example> npx react-native run-android


Note: if you are building a React Native app, make sure you have set up environment variables and the device is connected (if you are using a real device), otherwise you can use an emulator.

