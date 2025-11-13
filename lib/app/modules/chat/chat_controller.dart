import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../services/one_to_one_chat_service.dart';



class ChatController extends GetxController {
  final AudioRecorder _audioRecorder = AudioRecorder();
  var isRecording = false.obs;
  var recordingDuration = Duration.zero.obs;
  var recordingTime = '00:00'.obs;
  Timer? _recordingTimer;
  String? _currentRecordingPath;
  var isLoadingAudio = false.obs;
  late final AudioPlayer _audioPlayer;
  late final AudioPlayer _previewPlayer;
  var isPlaying = false.obs;
  var isPlayingPreview = false.obs;
  var currentlyPlayingUrl = ''.obs;
  var playbackPosition = Duration.zero.obs;
  var playbackDuration = Duration.zero.obs;
  var previewPosition = Duration.zero.obs;
  var previewDuration = Duration.zero.obs;
  var recordedAudioPath = ''.obs;
  StreamSubscription? _durationSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _completeSub;
  StreamSubscription? _previewDurationSub;
  StreamSubscription? _previewPositionSub;
  StreamSubscription? _previewCompleteSub;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _initializeAudioPlayer();
    _initializePreviewPlayer();
  }

  void _initializeAudioPlayer() {
    _audioPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    _durationSub = _audioPlayer.onDurationChanged.listen((duration) {
      playbackDuration.value = duration;
    });

    _positionSub = _audioPlayer.onPositionChanged.listen((position) {
      playbackPosition.value = position;
    });

    _completeSub = _audioPlayer.onPlayerComplete.listen((_) {
      isPlaying.value = false;
      playbackPosition.value = Duration.zero;
    });
  }

  void _initializePreviewPlayer() {
    _previewPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    _previewDurationSub = _previewPlayer.onDurationChanged.listen((duration) {
      previewDuration.value = duration;
    });

    _previewPositionSub = _previewPlayer.onPositionChanged.listen((position) {
      previewPosition.value = position;
    });

    _previewCompleteSub = _previewPlayer.onPlayerComplete.listen((_) {
      isPlayingPreview.value = false;
      previewPosition.value = Duration.zero;
    });
  }

  Future<void> toggleRecording(String groupId) async {
    if (isRecording.value) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> togglePreviewPlayback() async {
    if (recordedAudioPath.value.isEmpty) return;

    try {
      if (isPlayingPreview.value) {
        await _previewPlayer.pause();
        isPlayingPreview.value = false;
      } else {
        if (previewPosition.value.inSeconds >=
            previewDuration.value.inSeconds) {
          previewPosition.value = Duration.zero;
        }
        await _previewPlayer.play(DeviceFileSource(recordedAudioPath.value));
        isPlayingPreview.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to play preview: ${e.toString()}');
    }
  }

  Future<void> seekPreviewAudio(Duration position) async {
    try {
      await _previewPlayer.seek(position);
      previewPosition.value = position;
    } catch (e) {
      debugPrint('Error seeking preview: $e');
    }
  }

  Future<void> toggleAudioPlayback(String audioUrl) async {
    if (currentlyPlayingUrl.value == audioUrl && isPlaying.value) {
      await pauseAudio();
      return;
    }
    try {
      isLoadingAudio.value = true;
      if (currentlyPlayingUrl.value != audioUrl) {
        await _audioPlayer.stop();
        currentlyPlayingUrl.value = audioUrl;
        playbackPosition.value = Duration.zero;
        await _audioPlayer.setSourceUrl(audioUrl);
      }
      await _audioPlayer.resume();
      isPlaying.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to play audio: ${e.toString()}');
    } finally {
      isLoadingAudio.value = false;
    }
  }

  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
      isPlaying.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to pause audio: ${e.toString()}');
    }
  }

  Future<void> seekAudio(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      debugPrint('Error seeking audio: $e');
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        final dir = await getTemporaryDirectory();
        _currentRecordingPath =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          RecordConfig(encoder: AudioEncoder.aacLc),
          path: _currentRecordingPath.toString(),
        );

        isRecording.value = true;
        recordedAudioPath.value = '';
        recordingDuration.value = Duration.zero;
        _startTimer();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      _recordingTimer?.cancel();
      final path = await _audioRecorder.stop();

      if (path != null) {
        recordedAudioPath.value = path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop recording: $e');
    } finally {
      isRecording.value = false;
      recordingDuration.value = Duration.zero;
      recordingTime.value = '00:00';
    }
  }

  Future<void> sendRecordedAudio(
      {required String groupId, isGroupChat = true}) async {
    if (recordedAudioPath.value.isEmpty) return;

    try {
      final audioFile = File(recordedAudioPath.value);
      // final uploadService = UploadService();
      final oneToOneChatService = OneToOneChatService();

      // // Upload audio file
      // final downloadUrl = await uploadService.uploadAudio(audioFile);

      // if (isGroupChat) {
      //   // Send audio message to group
      //   await groupMessagingService.sendMessage(
      //     groupId: groupId,
      //     mediaLink: downloadUrl,
      //     messageType: 'audio',
      //   );
      // } else {
      //   // Send audio message to one-to-one chat
      //   await oneToOneChatService.sendMessage(
      //     chatID: groupId,
      //     mediaLink: downloadUrl,
      //     messageType: 'audio',
      //   );
      // }
      // // Clean up
      // await _cleanupRecording();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send audio message: ${e.toString()}');
    }
  }

  Future<void> cancelRecording() async {
    try {
      await _previewPlayer.stop();
      await _cleanupRecording();
    } catch (e) {
      debugPrint('Error canceling recording: $e');
    }
  }

  Future<void> _cleanupRecording() async {
    try {
      await _previewPlayer.stop();
      if (recordedAudioPath.value.isNotEmpty &&
          File(recordedAudioPath.value).existsSync()) {
        await File(recordedAudioPath.value).delete();
      }
      recordedAudioPath.value = '';
      _currentRecordingPath = null;
      previewPosition.value = Duration.zero;
      previewDuration.value = Duration.zero;
      isPlayingPreview.value = false;
    } catch (e) {
      debugPrint('Error cleaning up recording: $e');
    }
  }

  void _startTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordingDuration.value += const Duration(seconds: 1);
      recordingTime.value = _formatDuration(recordingDuration.value);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    _durationSub?.cancel();
    _positionSub?.cancel();
    _completeSub?.cancel();
    _previewDurationSub?.cancel();
    _previewPositionSub?.cancel();
    _previewCompleteSub?.cancel();
    _audioPlayer.dispose();
    _previewPlayer.dispose();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    super.onClose();
  }
}
