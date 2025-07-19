import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Image, Switch, TextInput, Button, Alert, TouchableOpacity } from 'react-native';
import SettingsList from 'react-native-settings-list';
import RNPickerSelect from 'react-native-picker-select';
import Modal from 'react-native-modal';
// import { Picker } from '@react-native-picker/picker';
// import AsyncStorage from '@react-native-async-storage/async-storage';


const SettingsPage = ({ navigation }) => {
    const [cameraLens, setCameraLens] = useState(false);
    const [livenessThreshold, setLivenessThreshold] = useState('0.7');
    const [identifyThreshold, setIdentifyThreshold] = useState('0.8');
    const [selectedLivenessLevel, setSelectedLivenessLevel] = useState(0);
    const [frontCameraValue, setFrontCameraValue] = useState(true);

    const livenessController = React.createRef();
    const identifyController = React.createRef();

    const livenessLevelNames = ['Best Accuracy', 'Light Weight'];

    const goBackToHome = () => {
        navigation.goBack();
    };


    useEffect(() => {
        loadSettings();
    }, []);

    const loadSettings = async () => {
        // try {
        //   const cameraLensValue = await AsyncStorage.getItem('camera_lens');
        //   const livenessLevelValue = await AsyncStorage.getItem('liveness_level');
        //   const livenessThresholdValue = await AsyncStorage.getItem('liveness_threshold');
        //   const identifyThresholdValue = await AsyncStorage.getItem('identify_threshold');

        //   setCameraLens(cameraLensValue === '1');
        //   setLivenessThreshold(livenessThresholdValue || '0.7');
        //   setIdentifyThreshold(identifyThresholdValue || '0.8');
        //   setSelectedLivenessLevel(livenessLevelValue ? parseInt(livenessLevelValue) : 0);
        // } catch (error) {
        //   console.log('Error loading settings:', error);
        // }
    };

    const restoreSettings = async () => {
        // try {
        //   await AsyncStorage.setItem('first_write', '0');
        //   await initSettings();
        //   await loadSettings();

        //   Alert.alert('Default settings restored!');
        // } catch (error) {
        //   console.log('Error restoring settings:', error);
        // }
    };

    const deleteAllPerson = async () => {

    };

    const initSettings = async () => {
        // try {
        //   const firstWrite = await AsyncStorage.getItem('first_write');
        //   if (!firstWrite) {
        //     await AsyncStorage.setItem('first_write', '1');
        //     await AsyncStorage.setItem('camera_lens', '1');
        //     await AsyncStorage.setItem('liveness_level', '0');
        //     await AsyncStorage.setItem('liveness_threshold', '0.7');
        //     await AsyncStorage.setItem('identify_threshold', '0.8');
        //   }
        // } catch (error) {
        //   console.log('Error initializing settings:', error);
        // }
    };

    // const updateLivenessLevel = async (value) => {
    //     // try {
    //     //   await AsyncStorage.setItem('liveness_level', value.toString());
    //     // } catch (error) {
    //     //   console.log('Error updating liveness level:', error);
    //     // }
    // };

    const updateCameraLens = async (value) => {
        // try {
        //   await AsyncStorage.setItem('camera_lens', value ? '1' : '0');
        //   setCameraLens(value);
        // } catch (error) {
        //   console.log('Error updating camera lens:', error);
        // }
    };

    const updateLivenessThreshold = async () => {

        // try {
        //   const doubleValue = parseFloat(livenessController.current.value);
        //   if (!isNaN(doubleValue) && doubleValue >= 0 && doubleValue < 1.0) {
        //     await AsyncStorage.setItem('liveness_threshold', livenessController.current.value);
        //     setLivenessThreshold(livenessController.current.value);
        //   }
        // } catch (error) {
        //   console.log('Error updating liveness threshold:', error);
        // }
    };

    const updateIdentifyThreshold = async () => {
        // try {
        //   const doubleValue = parseFloat(identifyController.current.value);
        //   if (!isNaN(doubleValue) && doubleValue >= 0 && doubleValue < 1.0) {
        //     await AsyncStorage.setItem('identify_threshold', identifyController.current.value);
        //     setIdentifyThreshold(identifyController.current.value);
        //   }
        // } catch (error) {
        //   console.log('Error updating identify threshold:', error);
        // }
    };

    const showLivenessThresholdPicker = () => {
        Alert.prompt(
            'Liveness thresholds',
            '',
            (text) => {
                setLivenessThreshold(text);
              console.log('You entered: ' + text);
            },
            undefined,
            livenessThreshold
          );
    };

    const showLivenessLevelPicker = () => {

    };

    const onFrontChanged = (value) => {
        setFrontCameraValue(value)
    }

    return (
        <View style={styles.container}>
            <View style={styles.appBar}>
                <View style={{ flexDirection: 'row', flex: 1, alignItems: 'center' }}>
                    <TouchableOpacity style={{ width: 50, height: 50, alignItems: 'center', justifyContent: 'center' }} onPress={goBackToHome}
                    >
                        <Image style={{ width: 24, height: 24, tintColor: '#FFFFFF', }}
                            source={require('./assets/ic_arrow_left.png')}
                        />
                    </TouchableOpacity>

                    <Text style={styles.title}>Settings</Text>
                </View>
            </View>
            <View style={styles.body}>
                <View style={{ flex: 1 }}>
                    <View style={{ flex: 1 }}>
                        <SettingsList borderColor='#313033'>
                            <SettingsList.Header headerText='Camera Lens' headerStyle={{ color: 'white' }} />
                            <SettingsList.Item backgroundColor='#313033' titleStyle={{ color: 'white' }}
                                icon={
                                    <View style={{ marginLeft: 10, alignSelf: 'center' }}>
                                        <Image style={{ alignSelf: 'center', height: 24, width: 24, tintColor: '#FFFFFF' }} source={require('./assets/ic_camera.png')} />
                                    </View>
                                }
                                title='Front'
                                hasNavArrow={false}
                                hasSwitch={true}
                                switchState={frontCameraValue}
                                switchOnValueChange={onFrontChanged}
                            />
                            <SettingsList.Header headerText='Thresholds' headerStyle={{ color: 'white', marginTop: 30 }} />
                            <SettingsList.Item titleInfo='0.7' hasNavArrow={false} title='Liveness threshold' backgroundColor='#313033' titleStyle={{ color: 'white' }}
                                onPress={showLivenessThresholdPicker}
                            />
                            <SettingsList.Item titleInfo='High Accuracy' hasNavArrow={false} title='Liveness level' backgroundColor='#313033' titleStyle={{ color: 'white' }}
                                
                            />
                            <SettingsList.Item titleInfo='0.8' hasNavArrow={false} title='Identify threshold' backgroundColor='#313033' titleStyle={{ color: 'white' }} />
                            <SettingsList.Header headerText='Reset' headerStyle={{ color: 'white', marginTop: 30 }} />
                            <SettingsList.Item hasNavArrow={false} title='Restore default settings' backgroundColor='#313033' titleStyle={{ color: 'white' }} />
                            <SettingsList.Item hasNavArrow={false} title='Clear all person' backgroundColor='#313033' titleStyle={{ color: 'white' }} />
                        </SettingsList>
                    </View>
                </View>
            </View>
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#1C1B1F'
    },
    appBar: {
        height: 60,
        backgroundColor: '#1C1B1F',
        justifyContent: 'center',
        alignItems: 'center',
    },
    title: {
        marginLeft: 30,
        flex: 1,
        fontSize: 18,
        color: '#FFFFFF',
    },
    body: {
        flex: 1,
        margin: 16,
    },
    description: {
        marginBottom: 8,
        fontSize: 14,
        color: '#FFF',
    },
    contact: {
        marginBottom: 8,
        fontSize: 14,
        fontWeight: 'bold',
        color: '#FFF',
    },
    contactRow: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 4,
    },
    icon: {
        width: 24,
        height: 24,
        marginRight: 4,
        tintColor: '#FFFFFF',
    },
    containerAlert: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
    },
    label: {
        fontSize: 16,
        marginBottom: 10,
    },
    button: {
        paddingVertical: 10,
        paddingHorizontal: 20,
        backgroundColor: 'blue',
        color: 'white',
        fontSize: 16,
    },
    pickerContainer: {
        backgroundColor: 'white',
        padding: 20,
        borderRadius: 8,
        justifyContent: 'center',
        alignItems: 'center',
    },
    settingsTile: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 10,
    },
    value: {
        marginLeft: 'auto',
        color: 'blue',
    },
});

const pickerStyles = StyleSheet.create({
    inputIOS: {
        fontSize: 16,
        paddingVertical: 12,
        paddingHorizontal: 10,
        borderWidth: 1,
        borderColor: 'gray',
        borderRadius: 4,
        color: 'black',
        width: 200,
    },
    inputAndroid: {
        fontSize: 16,
        paddingHorizontal: 10,
        paddingVertical: 8,
        borderWidth: 1,
        borderColor: 'gray',
        borderRadius: 8,
        color: 'black',
        width: 200,
    },
});

export default SettingsPage;
