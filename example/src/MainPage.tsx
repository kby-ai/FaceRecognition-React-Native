import React, { useEffect, useState } from 'react';
import { StatusBar, StyleSheet, View, TouchableOpacity, Image, Text } from 'react-native';
import { launchCamera, launchImageLibrary } from 'react-native-image-picker';
import { FaceRecognitionSdkView, FaceSDKModule } from 'face-recognition-sdk';
import SQLite from 'react-native-sqlite-storage';
import PersonView from './PersonView';
import Person from './Person';

const MainPage = ({ navigation }) => {

  const [persons, setPersons] = useState([]);

  useEffect(() => {
    // This function will be executed after the component is mounted
    const initSDKAsync = async () => {
      try {
        if(Platform.OS == 'ios') {
          var ret = await FaceSDKModule.setActivation("JT0eKB2YoRpN67t6Uu820HQFN2mGBmxcKdimmBw05PBmGB1avf0impc0g+VomsgQ7DemNOdQ56bp" +
            "2CaQmkE2b8nXxq+YTcbSNXEap0ds1kfRHS4R4tn/RHobGfaR97TPuLg+xP3Fn7Xro5xNjI1TiC50" +
            "SPEfFAgiu+mbQKMaTHxiTSEqQkIDtbAHpiqxip/vZFKyby+/uYTZkaaLVleC8EeA4UEl2TNxQLS5" +
            "eChxPQU/N9HIS/zij4ABeLpD8vbjq+EFptOE7guRbbdzpUHQwQ12eifCmCZZJhXFsIQR3WLWC9kR" +
            "mWaKZhqYIXSz87+wfcHH5PhwL3CkN+0d9i5fNg==");
          console.log("set activation:", ret);
        } else {
          var ret = await FaceSDKModule.setActivation("osTM1Du4CPuaDfAgyWBti2vOP6RPCqza0mtIDYLUTJalexklMhNTl7VThnVoqbdJ3/JrfwfKN71dM" + 
            "C8l271OZGyOnAzzbw1gzszJBteA0hewNksceE4yXd/Zv/WTW34c+E7Wu0QLKsQgNGZ+1kV/vfOvw" + 
            "fcn8ZNkfJycEu/f3tBpusxVWmSA8Hmj01AMpqwKdHCcLxlyAvnfWXAL2O4sHcbN5I3be+3AY6Q+J" + 
            "lSCbbvPL0P931mWpZggiRvBbud4mkdeKd1OFuldIKRhzQdWZYv+6MmRhtKl1LPfGnfKUqEycdDbM" + 
            "ypCr8wvvb33y6tqePW6700W2pcTr/c1l4Gw4g==");
          console.log("set activation:", ret);
        }

        ret = await FaceSDKModule.initSDK();

        console.log("init sdk:", ret);
      } catch (error) {
        console.error("Error setting activation:", error);
      }
    };

    const createDB = () => {
      // Create or open the database
      const db = SQLite.openDatabase({ name: 'person1.db', location: 'default' }, () => { }, errorCB);

      // Create the table
      db.transaction((tx) => {
        tx.executeSql(
          'CREATE TABLE person(name text, faceJpg text, templates text)',
          [],
          () => console.log('Table created successfully'),
          (error) => console.log('Error creating table:', error)
        );
      });
    }

    initSDKAsync();
    createDB();
    loadAllPersons();

    // Return a cleanup function to unsubscribe or perform cleanup
    return () => {
      // console.log('Component unmounted');
    };
  }, []); // The empty dependency array ensures the effect runs only once  

  const errorCB = (err) => {
    console.log("SQL Error: " + err);
  };

  const loadAllPersons = async () => {
    try {
      const db = SQLite.openDatabase({ name: 'person1.db', location: 'default' }, () => { }, errorCB);

      await db.transaction((tx) => {
        tx.executeSql(
          'SELECT * FROM person',
          [],
          (_, result) => {
            const rows = result.rows;
            const persons = [];
            for (let i = 0; i < rows.length; i++) {
              const row = rows.item(i);
              console.log("person: ", row.name);
              persons.push({
                name: row.name,
                faceJpg: row.faceJpg,
                templates: row.templates,
              });
            }
            setPersons(persons);
          },
          (error) => {
            console.log('Error loading persons:', error);
          }
        );
      });
    } catch (error) {
      console.log('Error opening database:', error);
    }
  };

  const insertPerson = async (person) => {
    try {
      const db = SQLite.openDatabase({ name: 'person1.db', location: 'default' }, () => { }, errorCB);

      await db.transaction((tx) => {
        tx.executeSql(
          'INSERT INTO person (name, faceJpg, templates) VALUES (?, ?, ?)',
          [person.name, person.faceJpg, person.templates],
          (_, result) => {

            setPersons([...persons, person]);
            console.log('Person inserted successfully1');
          },
          (error) => {
            console.log('Error inserting person:', error);
          }
        );
      });

    } catch (error) {
      console.log('Error opening database:', error);
    }
  }

  const deletePerson = async (index) => {
    try {
      const db = SQLite.openDatabase({ name: 'person1.db', location: 'default' }, () => { }, errorCB);

      const person = persons[index];

      await db.transaction((tx) => {
        tx.executeSql(
          'DELETE FROM person WHERE name = ?',
          [person.name],
          (_, result) => {
            console.log('Person deleted successfully');
            const updatedPersons = [...persons];
            updatedPersons.splice(index, 1);
            setPersons(updatedPersons);
          },
          (error) => {
            console.log('Error deleting person:', error);
          }
        );
      });
    } catch (error) {
      console.log('Error opening database:', error);
    }
  }

  const registerPerson = async (uri) => {
    var faceBoxes = await FaceSDKModule.extractFaces(uri);
    faceBoxes.forEach((face) => {
      const randomNumber = 10000 + Math.floor(Math.random() * 10000); // Generate a random number between 10000 and 19999
      const person = {
        name: 'Person' + randomNumber.toString(),
        faceJpg: face.faceJpg,
        templates: face.templates,
      };

      insertPerson(person)
    });
  };

  const enrollPerson = async () => {
    var options = {
      mediaType: 'photo'
    };

    launchImageLibrary(options, (response) => {
      if (response.didCancel) {
        return;
      }

      if (response.errorCode) {
        console.log('Error code:', response.errorCode);
        return;
      }

      console.log('Selected image:', response.assets[0]?.uri);
      registerPerson(response.assets[0]?.uri);
    });
  };
  
  const goToFaceRecognition = () => {
    // Implement navigation logic to FaceRecognitionView here
    navigation.navigate('FaceRecognition', {persons});
  };

  const goToSettings = () => {
    // Implement navigation logic to SettingsPage here
    navigation.navigate('SettingsPage');
  };

  const goToAbout = () => {
    navigation.navigate('About');
  };

  return (
    <View style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#1C1B1F" />
      <View style={styles.appBar}>
        <Text style={styles.appBarTitle}>Face Recognition</Text>
      </View>
      <View style={styles.body}>
        <View style={styles.card}>
          <Image
            source={require('./assets/ic_sparkles.png')}
            style={styles.cardIcon}
          />
          <Text style={styles.cardText}>
            We offer SDKs for Face Recognition, Liveness Detection, and ID Card Recognition.
          </Text>
        </View>
        <View style={{ height: 12 }} />
        <View style={styles.buttonsRow}>
          <TouchableOpacity
            style={styles.button}
            onPress={enrollPerson}
          >
            <Image
              source={require('./assets/person_search_icon.png')}
              style={styles.buttonIcon}
            />
            <Text style={styles.buttonText}>Enroll</Text>
          </TouchableOpacity>
          <View style={{ width: 16 }} />
          <TouchableOpacity
            style={styles.button}
            onPress={goToFaceRecognition}
          >
            <Image
              source={require('./assets/person_search_icon.png')}
              style={styles.buttonIcon}
            />
            <Text style={styles.buttonText}>Identify</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.buttonsRow}>
          <TouchableOpacity
            style={styles.button}
            onPress={goToSettings}
          >            
            <Image
              source={require('./assets/settings_icon.png')}
              style={styles.buttonIcon}
            />
            <Text style={styles.buttonText}>Settings</Text>
          </TouchableOpacity>
          <View style={{ width: 16 }} />
          <TouchableOpacity
            style={styles.button}
            onPress={goToAbout}
          >
            <Image
              source={require('./assets/info_icon.png')}
              style={styles.buttonIcon}
            />
            <Text style={styles.buttonText}>About</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.personView}>
          <PersonView personList={persons} deletePerson={deletePerson} />
        </View>
      </View>
      <View style={styles.footer}>
        <Image
          source={require('./assets/ic_kby.png')}
          style={styles.footerIcon}
        />
      </View>
      <View style={{ height: 16 }} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1C1B1F',
  },
  appBar: {
    height: 70,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#1C1B1F',
  },
  appBarTitle: {
    fontSize: 18,
    color: '#FFFFFF',
  },
  body: {
    marginTop: 8,
    flex: 1,
    marginHorizontal: 16,
  },
  card: {
    backgroundColor: '#49454F',
    borderRadius: 12,
    padding: 10,
    flexDirection: 'row',
    alignItems: 'center',
  },
  cardIcon: {
    width: 24,
    height: 24,
    marginRight: 10,
  },
  cardText: {
    fontSize: 14,
    color: '#FFFFFF',
  },
  buttonsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  button: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#4F378B',
    borderRadius: 12,
    paddingVertical: 10,
  },
  buttonIcon: {
    width: 24,
    height: 24,
    marginRight: 4,
  },
  buttonText: {
    fontSize: 15,
    color: '#FFFFFF',
  },
  personView: {
    flex: 1,
    // Implement styles for PersonView component here
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 4,
  },
  footerIcon: {
    width: 200,
    height: 28,
    resizeMode: 'contain'
  },
  footerText: {
    fontSize: 18,
    color: '#3C3C3C',
  },
});


export default MainPage;
