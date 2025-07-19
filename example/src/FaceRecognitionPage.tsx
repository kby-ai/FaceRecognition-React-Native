// FaceRecognitionPage.js
import React, { useEffect, useState, useRef } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image, } from 'react-native';
import { FaceRecognitionSdkView, FaceSDKModule } from 'face-recognition-sdk';
import { check, request, PERMISSIONS, RESULTS } from 'react-native-permissions'
import { NativeEventEmitter } from 'react-native';
import ResultPage from './ResultPage';
import { AppState, BackHandler } from 'react-native';
import { useIsFocused } from '@react-navigation/native';

const cameraPermission = Platform.select({
    ios: PERMISSIONS.IOS.CAMERA,
    android: PERMISSIONS.ANDROID.CAMERA,
})

const FaceRecognitionView = () => {
    const isFocused = useIsFocused();
    const sdkViewRef = useRef(null);

    useEffect(() => {
        if (isFocused) {
            startCamera();
        } else {
            stopCamera();
        }

        return () => {
            if(isFocused) {
                stopCamera();
            }
        };
    }, [isFocused]);

    const startCamera = async () => {
        await FaceSDKModule.startCamera();
    };

    const stopCamera = async () => {
        await FaceSDKModule.stopCamera();
    };

    const handleViewLayout = () => {
        if (isFocused && sdkViewRef.current) {
            startCamera();
        } else {
            stopCamera();
        }
    };

    return (
        <View style={styles.container}>
            <View style={styles.box} onLayout={handleViewLayout}>
                <FaceRecognitionSdkView
                    ref={sdkViewRef}
                    style={{ flex: 1 }}
                    livenessLevel={1}
                    cameraLens={1}
                />
            </View>
        </View>
    );
};

const FaceRecognitionPage = ({ navigation, route }) => {

    const { persons } = route.params;
    const [faces, setFaces] = useState([]);
    const [cameraShow, setCameraShow] = useState(false);
    const isFocused = useIsFocused();

    var recognized = false;

    const goBackToHome = () => {
        navigation.goBack();
    };

    useEffect(() => {
        checkPermission();

        const eventEmitter = new NativeEventEmitter(FaceSDKModule);
        let eventListener = eventEmitter.addListener('onFaceDetected', (event) => {
            setFaces(event);
            if (recognized == false) {
                identifyPerson(event);
            }
        });

        if(isFocused)
            recognized = false;
        else
            recognized = true;

        return () => {
            eventListener.remove();
        };

    }, [isFocused]);

    const identifyPerson = async (curFaces) => {
        let maxSimilarity = -1;
        let maxSimilarityName = "";
        let maxLiveness = -1;
        let maxYaw = -1;
        let maxRoll = -1;
        let maxPitch = -1;
        let enrolledFace, identifiedFace;

        try {
            if (curFaces.length > 0) {
                const face = curFaces[0];

                for (const person of persons) {
                    try {
                        const similarity = await FaceSDKModule.similarityCalculation(
                            face.templates,
                            person.templates
                        );

                        console.log('similarity', similarity);

                        if (maxSimilarity < similarity) {
                            maxSimilarity = similarity;
                            maxSimilarityName = person.name;
                            maxLiveness = face.liveness;
                            maxYaw = face.yaw;
                            maxRoll = face.roll;
                            maxPitch = face.pitch;
                            identifiedFace = face.faceJpg;
                            enrolledFace = person.faceJpg;
                        }
                    } catch (error) {
                        console.error('Error calculating similarity:', error);
                    }
                }
            }
        } catch (error) {
            console.error('Error setting activation:', error);
        }

        if (maxSimilarity > 0.8 && maxLiveness > 0.7) {
            recognized = true;
            
            navigation.replace('Result', { enrolledFace, identifiedFace, maxSimilarityName, maxSimilarity, maxLiveness, maxYaw, maxRoll, maxPitch });

            setFaces([]);
        }
    };

    const checkPermission = async () => {
        const permissionStatus = await check(cameraPermission);
        handlePermissionStatus(permissionStatus);
    };

    const requestPermission = async () => {
        const permissionStatus = await request(cameraPermission);
        handlePermissionStatus(permissionStatus);
    };

    const handlePermissionStatus = (status) => {
        switch (status) {
            case RESULTS.UNAVAILABLE:
                break;
            case RESULTS.DENIED:
                requestPermission();
                break;
            case RESULTS.GRANTED:
                setCameraShow(true);
                break;
            case RESULTS.BLOCKED:
                break;
        }
    };

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

                    <Text style={styles.title}>Face Recognition</Text>
                </View>
            </View>
            <View style={styles.body}>
                {cameraShow ? (
                    <FaceRecognitionView />
                ) : (
                    <View>
                        <Text>Camera permission issue.</Text>
                    </View>
                )}
                <View
                    style={{
                        flex: 1,
                        position: 'absolute',
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                    }}
                    pointerEvents="none"
                >
                    <FacePainter faces={faces} livenessThreshold={0.7} />
                </View>
            </View>
        </View>
    );
};

const FacePainter = ({ faces, livenessThreshold }) => {
    const [viewDimensions, setViewDimensions] = useState({ width: 0, height: 0 });

    const onLayout = (event) => {
        const { width, height } = event.nativeEvent.layout;
        setViewDimensions({ width, height });
    };

    const renderFaces = () => {
        return faces.map((face, index) => {
            const { x1, y1, x2, y2, frameWidth, frameHeight, liveness } = face;
            const xScale = frameWidth / viewDimensions.width;
            const yScale = frameHeight / viewDimensions.height;
            const isRealFace = liveness >= livenessThreshold;

            const rectStyle = isRealFace ? styles.realFaceRect : styles.spoofFaceRect;
            const textStyle = isRealFace ? styles.realFaceText : styles.spoofFaceText;
            const title = isRealFace ? `Real ${liveness}` : `Spoof ${liveness}`;

            return (
                <React.Fragment key={index}>
                    <Text style={[styles.faceText, textStyle, { left: x1 / xScale, top: y1 / yScale - 30 }]}>{title}</Text>
                    <View
                        style={[
                            styles.faceRect,
                            rectStyle,
                            {
                                left: x1 / xScale,
                                top: y1 / yScale,
                                width: (x2 - x1) / xScale,
                                height: (y2 - y1) / yScale,
                            },
                        ]}
                    />
                </React.Fragment>
            );
        });
    };

    return (
        <View style={styles.containerFace} onLayout={onLayout}>
            {renderFaces()}
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#1C1B1F'
    },
    appBar: {
        height: 70,
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
    box: {
        flex: 1,
        marginVertical: 0,
    },
    containerFace: {
        ...StyleSheet.absoluteFillObject,
        justifyContent: 'center',
        alignItems: 'center',
    },
    faceRect: {
        position: 'absolute',
        borderWidth: 3,
    },
    realFaceRect: {
        borderColor: '#00FF00',
    },
    spoofFaceRect: {
        borderColor: '#FF0000',
    },
    faceText: {
        position: 'absolute',
        fontSize: 20,
    },
    realFaceText: {
        color: '#00FF00',
    },
    spoofFaceText: {
        color: '#FF0000',
    },
});

export default FaceRecognitionPage;