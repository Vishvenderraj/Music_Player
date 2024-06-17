import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proj/styles/style.dart';

import '../../controller/player_controller.dart';
import '../../AudioPlayer/music_player.dart';
class AlbumSongs extends StatefulWidget {
  const AlbumSongs({super.key, required this.albumName, required this.id});
  final String albumName;
  final int id;
  @override
  State<AlbumSongs> createState() => _AlbumSongsState();
}

class _AlbumSongsState extends State<AlbumSongs> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  var controller = Get.put(PlayerController());
  List<SongModel> listOfSongs = [];
  Future<Uint8List?> fetchAlbumArtwork(int songId) async {
    return await audioQuery.queryArtwork(songId, ArtworkType.AUDIO);
  }
  Future<void> fetchSongs() async {
    List<SongModel> songs = await audioQuery.querySongs();
    setState(() {
      listOfSongs = songs.where((song) => song.album == widget.albumName).toList();
    });
  }
  @override
  void initState() {
    fetchSongs();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height/3,
              width: MediaQuery.sizeOf(context).width,
              child: Stack(
                  fit: StackFit.expand,
                  children:[
                    QueryArtworkWidget(
                      artworkFit: BoxFit.cover,
                      controller: audioQuery,
                      type: ArtworkType.ALBUM,
                      nullArtworkWidget: const Image(image: AssetImage('assets/black.jpg'),fit: BoxFit.cover,), id: widget.id,
                    ),Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 25,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(child: Text(widget.albumName,style: ourStyle("bold", 33, Colors.white),)),
                              Expanded(
                                flex: 0,
                                child:  GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayer(data: listOfSongs),),);
                                    controller.playList(listOfSongs[0].uri,0,listOfSongs[0].artist,listOfSongs[0].album);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.play_arrow,color: CupertinoColors.white,),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),]
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height/1.593,
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Title(color: Colors.black, child: Text('Songs',style: ourStyle("bold", 20, Colors.black),),),
                    ),
                    listOfSongs.isEmpty?
                    const Center(child: CircularProgressIndicator(
                      color: Colors.green,
                    ),)
                        : Expanded(
                      child: ListView.builder(
                        itemCount: listOfSongs.length,
                        itemBuilder: (context, index) {
                          SongModel song = listOfSongs[index];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.shade300,),
                              child:  Obx(()=> ListTile(
                                title: Text(song.title,style: ourStyle("bold", 18, Colors.black),),
                                leading: QueryArtworkWidget(
                                  artworkFit: BoxFit.fill,
                                  controller: audioQuery,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Image(image: AssetImage('assets/disk.png'),), id: song.id,
                                ),
                                subtitle: Text(song.artist ?? 'Unknown Album',style: ourStyle("bold", 15, Colors.grey.shade500),),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Icon(controller.songAlbum.value == widget.albumName && controller.songIndex.value == index && controller.isPlaying.value?Icons.pause_circle_outline:Icons.play_circle_filled_outlined,color: Colors.black,),
                                ),
                                onTap: () async {
                                  Uint8List? artwork = await fetchAlbumArtwork(song.id);
                                  Get.to(()=>  MusicPlayer(data: listOfSongs,artwork: artwork,
                                    ),
                                    transition: Transition.downToUp,
                                  );
                                  controller.playSong(song.uri,index);
                                  controller.songAlbum.value = song.album ?? 'unknown';
                                },
                              ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
