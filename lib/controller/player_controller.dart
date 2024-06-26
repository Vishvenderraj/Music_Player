import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController{

  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  final isPlaying = false.obs;
  var songAlbum = ''.obs;
  var songArtist = ''.obs;
  final songIndex = 0.obs;
  var duration = ''.obs;
  var position = ''.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;
  var heart = false.obs;
  var onRepeat = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

   isliked(){
    heart.value = !heart.value;
  }
  setRepeat(){
    onRepeat.value = !onRepeat.value;
  }
  checkRepeat(){
    onRepeat.value?audioPlayer.setLoopMode(LoopMode.one):audioPlayer.setLoopMode(LoopMode.off);
  }
  updatePosition(){
    audioPlayer.durationStream.listen((during) {
      duration.value = during.toString().split(".")[0];
      max.value = during!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((iniPosin) {
      position.value = iniPosin.toString().split(".")[0];
      value.value = iniPosin.inSeconds.toDouble();
    });
  }

  changeDurationToSeconds(seconds)
  {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playPause()
  {
    isPlaying.value = !isPlaying.value;
  }
  playList(String?uri,int index, String? artist, String? album)
  {
    audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
    audioPlayer.play();
    songIndex.value = index;
    songAlbum.value = album ?? 'unknown';
    songArtist.value = artist ?? 'unknown';
  }
  playSong(String? uri, int index)
  {
    songIndex.value = index;
    audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
    audioPlayer.play();
    isPlaying.value = true;
    updatePosition();
  }



  shuffle(){
    audioPlayer.shuffleModeEnabled;
  }
  repeat(){
    audioPlayer.loopMode;
  }
  Future<void>checkPermission() async
  {
    var status = await Permission.audio.request();
    if(status.isDenied)
      {
         const AlertDialog(title: Text("Please allow to use the application"),);
         checkPermission();
      }
  }
}