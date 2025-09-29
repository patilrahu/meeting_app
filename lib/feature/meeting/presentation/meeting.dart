import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meeting_app/core/constant/color_constant.dart';
import 'package:meeting_app/core/constant/string_constant.dart';
import 'package:meeting_app/core/helper/internet_helper.dart';
import 'package:meeting_app/core/helper/navigation_helper.dart';
import 'package:meeting_app/core/helper/permission_helper.dart';
import 'package:meeting_app/core/helper/toast_helper.dart';
import 'package:meeting_app/feature/meeting/meeting_helper.dart';
import 'package:meeting_app/feature/meeting/widget/meeting_grid_widget.dart';
import 'package:meeting_app/feature/users/presentation/pages/users.dart';

class Meeting extends StatefulWidget {
  const Meeting({super.key});

  @override
  State<Meeting> createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> with WidgetsBindingObserver {
  RtcEngine? _engine;
  final List<int> _remoteUids = [];
  bool _joined = false;
  bool _videoEnabled = true;
  bool _audioEnabled = true;
  final Map<int, bool> _videoEnabledMap = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void checkPermission() async {
    bool granted = await PermissionHelper.requestPermissions();
    if (!granted) {
      ToastHelper.error(
        context,
        "Camera and microphone permissions are required to join the call.",
      );
    } else {
      joinMeeting();
    }
  }

  void joinMeeting() async {
    _engine = createAgoraRtcEngine();
    _engine = await MeetingHelper.joinMeeting(
      engine: _engine!,
      onUserError: (error) {
        ToastHelper.error(context, error);
      },
      onJoined: () {
        setState(() {
          _joined = true;
          _videoEnabledMap[0] = true;
        });
      },
      onUserJoined: (uid) {
        setState(() {
          _remoteUids.add(uid);
          _videoEnabledMap[uid] = true;
        });
      },
      onUserLeft: (uid) {
        setState(() {
          _remoteUids.remove(uid);
          _videoEnabledMap.remove(uid);
        });
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        _engine?.muteLocalAudioStream(true);
        _engine?.enableLocalVideo(false);
        break;
      case AppLifecycleState.resumed:
        _engine?.muteLocalAudioStream(!_audioEnabled);
        _engine?.enableLocalVideo(_videoEnabled);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        title: Text(
          StringConstant.splashName.toUpperCase(),
          style: TextStyle(
            fontFamily: GoogleFonts.novaScript().fontFamily,
            color: ColorConstant.redColor,
            fontSize: 25,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              NavigationHelper.push(context, Users());
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.person_outline_rounded,
                color: Colors.black,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Visibility(
                visible: !_joined && _engine == null,

                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      var checkInternet =
                          await ConnectivityHelper.hasInternet();
                      if (!checkInternet) {
                        ToastHelper.error(context, '❌ No Internet connection');
                        return;
                      }
                      checkPermission();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      height: 50,
                      child: Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 35),
                          Text(
                            'Create Instant Meeting',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_engine != null)
                Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: buildVideoGrid(
                            engine: _engine!,
                            remoteUids: _remoteUids,
                            localVideoEnabled: _videoEnabled,
                            videoEnabledMap: _videoEnabledMap,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () async {
                            await _engine!.leaveChannel();
                            await _engine?.stopScreenCapture();
                            setState(() {
                              _joined = false;
                              _remoteUids.clear();
                              _videoEnabled = true;
                              _audioEnabled = true;
                              _engine = null;
                            });
                          },
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 20),
                        FloatingActionButton(
                          backgroundColor: Colors.green,
                          onPressed: () async {
                            setState(() {
                              _videoEnabled = !_videoEnabled;
                            });
                            if (_videoEnabled) {
                              await _engine!.enableLocalVideo(true);
                              await _engine!.startPreview();
                            } else {
                              await _engine!.enableLocalVideo(false);
                              await _engine!.stopPreview();
                            }
                          },
                          child: Icon(
                            _videoEnabled ? Icons.videocam : Icons.videocam_off,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 20),
                        FloatingActionButton(
                          backgroundColor: Colors.blue,
                          onPressed: () async {
                            setState(() {
                              _audioEnabled = !_audioEnabled;
                            });
                            if (_audioEnabled) {
                              await _engine!.muteLocalAudioStream(false);
                            } else {
                              await _engine!.muteLocalAudioStream(true);
                            }
                          },
                          child: Icon(
                            _audioEnabled ? Icons.mic : Icons.mic_off,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              if (_engine != null)
                Positioned(
                  top: 30,
                  right: 10,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () async {
                      await _engine!.switchCamera();
                    },
                    child: const Icon(Icons.cameraswitch, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
