import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/feature/meeting/meeting_helper.dart';

Widget buildVideoGrid({
  required RtcEngine engine,
  required List<int> remoteUids,
  required bool localVideoEnabled,
  required Map<int, bool> videoEnabledMap,
}) {
  final allUids = [0, ...remoteUids];

  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: allUids.length == 1 ? 1 : 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
    ),
    itemCount: allUids.length,
    itemBuilder: (context, index) {
      final uid = allUids[index];
      final isLocal = uid == 0;
      final videoEnabled = isLocal
          ? localVideoEnabled
          : videoEnabledMap[uid] ?? true;

      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 2)),
          child: _buildVideoView(uid, isLocal, videoEnabled, engine),
        ),
      );
    },
  );
}

Widget _buildVideoView(
  int uid,
  bool isLocal,
  bool videoEnabled,
  RtcEngine engine,
) {
  if (!videoEnabled) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: const Icon(
        Icons.videocam_off_outlined,
        size: 50,
        color: Colors.red,
      ),
    );
  }

  if (isLocal) {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  } else {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: engine,
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: MeetingHelper.channelName),
      ),
    );
  }
}
