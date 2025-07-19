// AboutPage.js
import React from 'react';
import { View, Text, StyleSheet, Image, TouchableOpacity } from 'react-native';

const AboutPage = ({ navigation }) => {
  const goBackToHome = () => {
    navigation.goBack();
  };

  return (
    <View style={styles.container}>
      <View style={styles.appBar}>
        <View style={{flexDirection: 'row', flex: 1, alignItems: 'center'}}>
          <TouchableOpacity style={{ width: 50, height: 50, alignItems: 'center', justifyContent: 'center'}} onPress={goBackToHome}
          >
            <Image style={{  width: 24, height: 24, tintColor: '#FFFFFF',}}
              source={require('./assets/ic_arrow_left.png')}
            />
          </TouchableOpacity>

          <Text style={styles.title}>KBY-AI Technology</Text>
        </View>
      </View>
      <View style={styles.body}>
        <Text style={styles.description}>
        We are a leading provider of SDKs for advanced biometric authentication technology, including face recognition, liveness detection, and ID card recognition.
        </Text>
        <Text style={styles.description}>
      In addition to biometric authentication solutions, we provide software development services for computer vision and mobile applications.
        </Text>
        <Text style={styles.description}>
        With our team's extensive knowledge and proficiency in these areas, we can deliver exceptional results to our clients.
        </Text>
        <Text style={styles.description}>
        If you're interested in learning more about how we can help you, please don't hesitate to get in touch with us today.
        </Text>
        <Text style={styles.contact}>Please contact us:</Text>
        <View style={styles.contactRow}>
          <Image source={require('./assets/ic_email.png')} style={styles.icon} />
          <Text style={{ color: '#FFF',}}>Email: contact@kby-ai.com</Text>
        </View>
        <View style={styles.contactRow}>
          <Image source={require('./assets/ic_skype.png')} style={styles.icon} />
          <Text style={{ color: '#FFF',}}>Skype: live:.cid.66e2522354b1049b</Text>
        </View>
        <View style={styles.contactRow}>
          <Image source={require('./assets/ic_telegram.png')} style={styles.icon} />
          <Text style={{ color: '#FFF',}}>Telegram: kbyai</Text>
        </View>
        <View style={styles.contactRow}>
          <Image source={require('./assets/ic_whatsapp.png')} style={styles.icon} />
          <Text style={{ color: '#FFF',}}>WhatsApp: +19092802609</Text>
        </View>
        <View style={styles.contactRow}>
          <Image source={require('./assets/ic_github.png')} style={styles.icon} />
          <Text style={{ color: '#FFF',}}>Github: https://github.com/kby-ai</Text>
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

export default AboutPage;