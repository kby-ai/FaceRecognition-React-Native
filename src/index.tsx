import React, { Component } from 'react'
import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
  NativeModules,
} from 'react-native';
import PropTypes from 'prop-types'

const LINKING_ERROR =
  `The package 'face-recognition-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

type FaceRecognitionSdkProps = {
  color: string;
  style: ViewStyle;
  cameraLens: number;
  livenessLevel: number;
};

const ComponentName = 'FaceRecognitionSdkView';

export const FaceRecognitionSdkView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<FaceRecognitionSdkProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
      
export const {FaceSDKModule} = NativeModules;
