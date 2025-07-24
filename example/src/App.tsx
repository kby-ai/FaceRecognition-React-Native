import * as React from 'react';

import { StatusBar, StyleSheet, View } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { FaceRecognitionSdkView } from 'face-recognition-sdk';
import { IconButton } from 'react-native-paper';
import AboutPage from './AboutPage';
import MainPage from './MainPage';
import FaceRecognitionPage from './FaceRecognitionPage';
import SettingsPage from './SettingsPage';
import ResultPage from './ResultPage';

const Stack = createNativeStackNavigator();

export default function App() {
  const backButton = navigation => (
    <IconButton
      icon='./assets/ic_sparkles.png'
      onPress={() => navigation.goBack()}
    />
  );
  
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name="Home" component={MainPage} options={{ headerShown: false }}/>
        <Stack.Screen name="FaceRecognition" component={FaceRecognitionPage} options={{ headerShown: false }}/>
        <Stack.Screen name="SettingsPage" component={SettingsPage} options={{ headerShown: false }}/>
        <Stack.Screen name="About" component={AboutPage} options={{ headerShown: false }}/>
        <Stack.Screen name="Result" component={ResultPage} options={{ headerShown: false }}/>
      </Stack.Navigator>
    </NavigationContainer>
  );
    // <View style={styles.container}>
    //   <KbyAiFacerecognitionReactNativeView color="#32a852" style={styles.box} />
    // </View>
  // );
}

