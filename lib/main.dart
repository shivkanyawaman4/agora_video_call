import 'package:agora_video_call/video_call.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'api/local_notification.dart';
import 'api/utils.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> backgroundHandler(RemoteMessage message) async {}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBFFPJQhVmNK51_8yqCHROMRCG6FNGOyMc",
            authDomain: "agora-video-call-d7a1e.firebaseapp.com",
            projectId: "agora-video-call-d7a1e",
            storageBucket: "agora-video-call-d7a1e.appspot.com",
            messagingSenderId: "790841523559",
            appId: "1:790841523559:web:da922db6b8f9e10bd143c2",
            measurementId: "G-9PNENKXE8X"));
  } else {
    await Firebase.initializeApp();
  }
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
    });
    LocalNotificationService.initialize();
    // AwesomeNotifications().initialize(
    //     'resource://drawable/notification
    //     [
    //       NotificationChannel(
    //           channelKey: 'Cricstock',
    //           channelName: "Main Channel",
    //           channelDescription: "Main Channel Cricstock",
    //           defaultColor: blueColor,
    //           ledColor: Colors.white,
    //           playSound: true,
    //           icon: "resource://drawable/notification",
    //           enableLights: true,
    //           enableVibration: true)
    //     ],
    //     debug: false);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('getInitialMessage');
     
        Utils.notificationRouter('', 1);
      
    });

    FirebaseMessaging.onMessage.listen((message) {
      print('onMessage');
      if (message.notification != null) {
        LocalNotificationService.display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('onMessageOpenedApp');
     
        Utils.notificationRouter('', 2);
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home': (context) => const Home(),
        "/video_call": (context) => const JoiningScreen(),
      },
      initialRoute: "/video_call",
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    print('join call screen');
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            child: const Text('Join Call'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const VideoCall()));
            }),
      ),
    );
  }
}

class JoiningScreen extends StatefulWidget {
  const JoiningScreen({Key? key}) : super(key: key);

  @override
  State<JoiningScreen> createState() => _JoiningScreenState();
}

class _JoiningScreenState extends State<JoiningScreen> {
  @override
  Widget build(BuildContext context) {
    print('home screen');
    return Container(
      color: Colors.amber,
    );
  }
}
