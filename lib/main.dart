import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = '74ded8a2e51c474483a0f8d3231ba2ee';
const token =
    '00674ded8a2e51c474483a0f8d3231ba2eeIAAUN5afHwXNMCkAUSLC46UM2qrKhC/4w8Rq9vCw4vIqR8JBJDUAAAAAEADnfDPKxFwzYgEAAQDEXDNi';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _remoteUid = 0;
  late RtcEngine _engine;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initForAgora();
  }

  Future<void> initForAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed) {
          print('local user joined: $channel, $uid, $elapsed');
        },
        userJoined: (int uid, int elapsed) {
          print('remote user Joined: $uid, $elapsed');
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print('remote user left channel: $uid, $reason');
          setState(() {
            _remoteUid = 0;
          });
        },
      ),
    );
    await _engine.joinChannel(token, 'abc', null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _renderRemoteVideo(),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: _renderLocalPreview(),
                ),
              ))
        ],
      ),
    );
  }

  Widget _renderLocalPreview() {
    return const RtcLocalView.SurfaceView();
  }

  Widget _renderRemoteVideo() {

    if (_remoteUid != 0) {
      return  RtcRemoteView.SurfaceView(uid:_remoteUid,channelId: 'abc',);
    } else {
      return const Text(
        'Please wait remote user to join',
        style: TextStyle(fontSize: 22, color: Colors.red),
        textAlign: TextAlign.center,
      );
    }
  }
}
