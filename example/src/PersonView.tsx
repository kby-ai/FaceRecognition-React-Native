import React from 'react';
import { View, Text, StyleSheet, Image, TouchableOpacity, FlatList } from 'react-native';

const PersonView = ({ personList, deletePerson }) => {
    const renderItem = ({ item, index }) => {
        return (            
            <View style={{
                height: 70, flexDirection: 'row', alignItems: 'center', backgroundColor: '#313033',
                borderRadius: 12, marginBottom: 8
            }}>
                <View style={{ marginLeft: 16 }}>
                    <Image
                        source={{ uri: `data:image/jpeg;base64,${item.faceJpg}` }}
                        style={{ width: 56, height: 56, borderRadius: 28 }}
                    />
                </View>
                <View style={{ marginLeft: 16 }}>
                    <Text style={{color:'white'}}>{item.name}</Text>
                </View>
                <View style={{ flex: 1 }} />
                <TouchableOpacity style={{ marginRight: 12 }} onPress={() => deletePerson(index)}>
                    <Image
                        source={require('./assets/ic_delete.png')}
                        style={styles.buttonIcon}
                    />
                </TouchableOpacity>
                <View style={{ width: 8 }} />
            </View>
        );
    };

    return (
        <FlatList
            data={personList}
            renderItem={renderItem}
            keyExtractor={(item, index) => index.toString()}
        />
    );
};

const styles = StyleSheet.create({
    buttonIcon: {
        width: 24,
        height: 24,
        marginRight: 4,
        tintColor: '#FFFFFF',
    },
});

export default PersonView;
