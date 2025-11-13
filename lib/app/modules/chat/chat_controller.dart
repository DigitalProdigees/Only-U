import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ChatController extends GetxController {
  var isRecording = false.obs;
  var recordingDuration = Duration.zero.obs;
  var recordingTime = '00:00'.obs;
  Timer? _recordingTimer;
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
    super.onClose();
  }
}
