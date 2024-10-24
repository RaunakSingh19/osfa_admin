import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

FirebaseOptions firebaseOptions=  const FirebaseOptions(apiKey: 'AIzaSyCuePtnWKmrJwRbb3OhNmOkBeJugXbCAyk', appId: '1:738504089346:android:f8028c547436383efaec1b', messagingSenderId: '738504089346', projectId: 'ofsa-3c2fc');

//Platform.isAndroid ?
//
// use this if not working , the code , but this is useful when u use both the systems ios and android
//platform.isAndroid ? is used before the firebase (apikey:...)
//this is used to specify the operating system of the machine , but as of  now i am working on the android so that
//i am not using ios part and there for i dont feel need to specify the details of the platforms
// because from starting i dont write any bit of code and database connection code for ios