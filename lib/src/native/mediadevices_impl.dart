import 'dart:async';

import 'package:flutter/services.dart';

import '../interface/media_stream.dart';
import '../interface/mediadevices.dart';
import 'media_stream_impl.dart';
import 'utils.dart';

class MediaDeviceNative extends MediaDevices {
  @override
  Future<MediaStream> getUserMedia(Map<String, dynamic> mediaConstraints) async {
    var channel = WebRTC.methodChannel();
    try {
      final response = await channel.invokeMethod<Map<dynamic, dynamic>>(
        'getUserMedia',
        <String, dynamic>{'constraints': mediaConstraints},
      );
      if (response == null) {
        throw Exception('getUserMedia return null, something wrong');
      }
      String streamId = response['streamId'];
      var stream = MediaStreamNative(streamId, 'local');
      stream.setMediaTracks(response['audioTracks'], response['videoTracks']);
      return stream;
    } on PlatformException catch (e) {
      throw 'Unable to getUserMedia: ${e.message}';
    }
  }

  @override
  Future<MediaStream> getDisplayMedia(Map<String, dynamic> mediaConstraints) async {
    var channel = WebRTC.methodChannel();
    try {
      final response = await channel.invokeMethod<Map<dynamic, dynamic>>(
        'getDisplayMedia',
        <String, dynamic>{'constraints': mediaConstraints},
      );
      if (response == null) {
        throw Exception('getDisplayMedia return null, something wrong');
      }
      String streamId = response['streamId'];
      var stream = MediaStreamNative(streamId, 'local');
      stream.setMediaTracks(response['audioTracks'], response['videoTracks']);
      return stream;
    } on PlatformException catch (e) {
      throw 'Unable to getDisplayMedia: ${e.message}';
    }
  }

  @override
  Future<List<dynamic>> getSources() async {
    var channel = WebRTC.methodChannel();
    try {
      final response = await channel.invokeMethod<Map<dynamic, dynamic>>(
        'getSources',
        <String, dynamic>{},
      );
      List<dynamic> sources = response?['sources'];
      return sources;
    } on PlatformException catch (e) {
      throw 'Unable to getSources: ${e.message}';
    }
  }
}
