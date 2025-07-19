// ResultPage.js
import React from 'react';
import { View, Text, StyleSheet, Image, TouchableOpacity } from 'react-native';

const ResultPage = ({ navigation, route }) => {

    const { enrolledFace, identifiedFace, maxSimilarityName, maxSimilarity, maxLiveness, maxYaw, maxRoll, maxPitch } = route.params;

    const goBackToHome = () => {
        navigation.goBack();
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

                    <Text style={styles.title}>Identify Result</Text>
                </View>
            </View>
            <View style={styles.body}>
                <View style={{ width: '100%', height: '100%', backgroundColor: '#1C1B1F' }}>
                    <View style={{ marginVertical: 10 }}>
                        <View style={{ flexDirection: 'row', justifyContent: 'space-evenly' }}>
                            {enrolledFace ? (
                                <View>
                                    <Image style={{ width: 160, height: 160 }} source={{ uri: `data:image/jpeg;base64,${enrolledFace}` }} />
                                    <Text style={{color: 'white'}}>Enrolled</Text>
                                </View>
                            ) : (
                                <View style={{ height: 1 }} />
                            )}
                            {identifiedFace ? (
                                <View>
                                    <Image style={{ width: 160, height: 160 }} source={{ uri: `data:image/jpeg;base64,${identifiedFace}` }} />
                                    <Text style={{color: 'white'}}>Identified</Text>
                                </View>
                            ) : (
                                <View style={{ height: 1 }} />
                            )}
                        </View>
                    </View>
                    <View style={{ flexDirection: 'row', marginBottom: 8 }}>
                        <Text style={{ fontSize: 18, color: 'white' }}>Identified: {maxSimilarityName}</Text>
                    </View>
                    <View style={{ flexDirection: 'row', marginBottom: 8 }}>
                        <Text style={{ fontSize: 18, color: 'white' }}>Similarity: {maxSimilarity}</Text>
                    </View>
                    <View style={{ flexDirection: 'row', marginBottom: 8 }}>
                        <Text style={{ fontSize: 18, color: 'white' }}>Liveness score: {maxLiveness}</Text>
                    </View>
                    <View style={{ flexDirection: 'row', marginBottom: 8}}>
                        <Text style={{ fontSize: 18, color: 'white' }}>Yaw: {maxYaw}</Text>
                    </View>
                    <View style={{ flexDirection: 'row', marginBottom: 8 }}>
                        <Text style={{ fontSize: 18, color: 'white' }}>Roll: {maxRoll}</Text>
                    </View>
                    <View style={{ flexDirection: 'row', marginBottom: 8 }}>
                        <Text style={{ fontSize: 18, color: 'white' }}>Pitch: {maxPitch}</Text>
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
});

export default ResultPage;