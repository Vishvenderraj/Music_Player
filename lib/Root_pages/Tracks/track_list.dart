import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proj/AudioPlayer/music_player.dart';
import 'package:proj/styles/style.dart';
import '../../controller/player_controller.dart';

class TrackList extends StatelessWidget {

  const TrackList({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    final OnAudioQuery audioQuery = OnAudioQuery();
    Future<Uint8List?> fetchAlbumArtwork(int songId) async {
      return await audioQuery.queryArtwork(songId, ArtworkType.AUDIO);
    }
   /* someName() async {                   //SCAN MEDIA
      File file = File( 'path');
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
              CupertinoIcons.search_circle,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
        title: Text(
          'TRACKS',
          style: ourStyle("n", 30, Colors.white),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(

          ignoreCase: true,
          sortType: SongSortType.TITLE,
        ),
        builder: (context, item){
          if (item.data == null) {
            return const CircularProgressIndicator(
              color: Colors.transparent,
            );
          }

          // 'Library' is empty.
          if (item.data!.isEmpty) return const Text("Nothing found!");
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: CupertinoColors.systemGrey.withOpacity(0.2),
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
                          nullArtworkWidget: const Image(image: AssetImage('assets/disk.png')),
                        ),
                        subtitle: Text(
                          item.data![index].artist ?? "Unknown Artist",
                          style: ourStyle("regular", 14, Colors.white),
                        ),
                        trailing: Icon(
                          controller.songIndex.value == index && controller.isPlaying.value?CupertinoIcons.pause_circle_fill:CupertinoIcons.play_circle,
                          color: Colors.white,
                        ),
                        onTap: () async{
                          Uint8List? artwork = await fetchAlbumArtwork(item.data![index].id);
                          Get.to(
                              ()=>  MusicPlayer(data: item.data!,artwork: artwork,
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
                          controller.playSong(item.data![index].uri,index);
                        },
                      ),
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
