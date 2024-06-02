import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proj/music_player.dart';
import 'package:proj/style.dart';
import 'controller/player_controller.dart';

class Playlist extends StatelessWidget {

  const Playlist({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    final OnAudioQuery audioQuery = OnAudioQuery();
   /* someName() async {                   //SCAN MEDIA
      File file = File('path');
      try {
        if (file.existsSync()) {
          file.deleteSync();
          _audioQuery.scanMedia(file.path); // Scan the media 'path'
        }
      } catch (e) {
        debugPrint('$e');
      }
    }*/
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.search_circle_fill,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
        title: Text(
          'Your Playlist',
          style: ourStyle("bold", 25, Colors.white),
        ),
        leading: const Icon(
          CupertinoIcons.music_note_list,
          color: Colors.white,
          size: 20,
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
          ignoreCase: true
        ),
        builder: (context, item){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Obx(()=> ListTile(
                      title: Text(
                        item.data![index].title,
                        style: ourStyle("bold", 18, Colors.white),
                      ),
                      leading:  QueryArtworkWidget(
                        controller: audioQuery,
                        id: item.data![index].id,
                        type: ArtworkType.AUDIO,
                      ),
                      subtitle: Text(
                        item.data![index].artist ?? "Unknown Artist",
                        style: ourStyle("regular", 14, Colors.white),
                      ),
                      trailing: Icon(
                        controller.songIndex.value == index && controller.isPlaying.value?CupertinoIcons.pause_circle_fill:CupertinoIcons.play_circle,
                        color: Colors.white,
                      ),
                      onTap: (){
                        Get.to(
                            ()=>  MusicPlayer(data: item.data!,
                            ),
                          transition: Transition.downToUp,
                        );
                        if(controller.isPlaying.value && controller.songIndex.value!=index)
                          {
                             controller.isPlaying.value = true;
                          }
                        else
                          {
                            controller.playPause();
                          }
                        controller.playSong(item.data![index].uri, controller.isPlaying.value,index);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      );
  }
}
