import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proj/style.dart';
import 'controller/player_controller.dart';
class ArtistList extends StatelessWidget {
  const ArtistList({super.key});

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
              CupertinoIcons.search_circle,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
        title: Text(
          'ARTISTS',
          style: ourStyle("n", 30, Colors.white),
        ),
      ),
      body: FutureBuilder<List<ArtistModel>>(
        future: audioQuery.queryArtists(
          sortType: ArtistSortType.ARTIST,
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
        ),
        builder: (context, item){
          if (item.data == null) {
            return const CircularProgressIndicator();
          }

          // 'Library' is empty.
          if (item.data!.isEmpty) return const Text("Nothing found!");
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(index>0 && item.data![index].artist.substring(0,1).compareTo(item.data![index-1].artist.substring(0,1)) != 0)Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
                      child: Text(item.data![index].artist.substring(0,1).toUpperCase(),
                        style: ourStyle("Bold", 23, Colors.white),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: CupertinoColors.systemGrey.withOpacity(0.2),
                        ),
                        child: Obx(()=> ListTile(
                          title: Text(
                            item.data![index].artist,
                            style: ourStyle("bold", 18, Colors.white),
                          ),
                          leading:  QueryArtworkWidget(
                            controller: audioQuery,
                            id: item.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Image(image: AssetImage('assets/disk.png')),
                          ),
                          subtitle: Text(
                            item.data![index].artist,
                            style: ourStyle("regular", 14, Colors.white),
                          ),
                          trailing: Icon(
                            controller.songIndex.value == index && controller.isPlaying.value?CupertinoIcons.pause_circle_fill:CupertinoIcons.play_circle,
                            color: Colors.white,
                          ),
                          onTap: (){
                            /*Get.to(
                                  ()=>  MusicPlayer(data: item.data?,
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
                            controller.playSong(item.data![index].uri, controller.isPlaying.value,index);*/
                          },
                        ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
