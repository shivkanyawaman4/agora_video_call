import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = '74ded8a2e51c474483a0f8d3231ba2ee';
String token =
    "00674ded8a2e51c474483a0f8d3231ba2eeIADGx5nZqn5y0uRKZn+VTKSGRt8UlmhUW3EKSiW3xxi9S8JBJDUAAAAAEADnfDPKalE3YgEAAQBqUTdi";

class VideoCall extends StatefulWidget {
  const VideoCall({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  int _remoteUid = 0;
  late RtcEngine _engine;
  bool muted = false;
  bool isCameraOn = true;
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

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
    _engine.leaveChannel();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _isCameraOn() {
    setState(() {
      isCameraOn = !isCameraOn;
    });
    if (isCameraOn) {
      _engine.disableVideo();
    } else {
      _engine.enableVideo();
    }
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF223A5E),
        title: const Text('Online Consultation'),
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
              )),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: _isCameraOn,
                  child: Icon(
                    isCameraOn ? Icons.videocam_off : Icons.videocam,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: const Color(0xFF223A5E).withOpacity(0.8),
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed: _onToggleMute,
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: const Color(0xFF223A5E).withOpacity(0.8),
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed: _onSwitchCamera,
                  child: const Icon(
                    Icons.flip_camera_ios,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: const Color(0xFF223A5E).withOpacity(0.8),
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed: () => _onCallEnd(context),
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderLocalPreview() {
    return RtcLocalView.SurfaceView();
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      print(
          'remote&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& uid: $_remoteUid');

      return RtcRemoteView.SurfaceView(
        uid: _remoteUid,
        channelId: 'abc',
      );
    } else {
      print(
          'remote&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& uid: $_remoteUid');
      // 2541264718
      // 1654885898

      return const Text(
        'Please wait remote user to join',
        style: TextStyle(fontSize: 22, color: Color(0xff223A5E)),
        textAlign: TextAlign.center,
      );
    }
  }
}
