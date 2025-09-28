import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MeetingHelper {
  static const channelName = "test123";
  static final _token = dotenv.env['AGORA_APP_TOKEN'];
  static final _appID = dotenv.env['AGORA_APP_ID'];
  static Future<RtcEngine> joinMeeting({
    required RtcEngine engine,
    required void Function() onJoined,
    required void Function(int uid) onUserJoined,
    required void Function(int uid) onUserLeft,
  }) async {
    await engine.initialize(
      RtcEngineContext(
        appId: _appID,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (err, msg) {
          log("message $err  $msg");
        },
        onJoinChannelSuccess: (connection, elapsed) {
          onJoined();
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          onUserJoined(remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          onUserLeft(remoteUid);
        },
      ),
    );
    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: _token ?? '',
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
    return engine;
  }
}
