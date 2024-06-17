import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../controller/player_controller.dart';
import '../../AudioPlayer/music_player.dart';
import '../../styles/style.dart';

class ArtistSongs extends StatefulWidget {
  const ArtistSongs({super.key, required this.artistName, required this.id});
  final String artistName;
  final int id;

  @override
  State<ArtistSongs> createState() => _ArtistSongsState();
}

class _ArtistSongsState extends State<ArtistSongs> {

  final OnAudioQuery audioQuery = OnAudioQuery();
  var controller = Get.put(PlayerController());
  List<SongModel> listofsongs = [];

  Future<void> fetchSongs() async {
    List<SongModel> songs = await audioQuery.querySongs();
    setState(() {
      listofsongs = songs.where((song) => song.artist == widget.artistName).toList();
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
                  type: ArtworkType.ARTIST,
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
                          Expanded(child: Text(widget.artistName,style: ourStyle("bold", 33, Colors.white),)),
                           Expanded(
                            flex: 0,
                            child:  GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayer(data: listofsongs),),);
                                controller.playList(listofsongs[0].uri,0,listofsongs[0].artist,listofsongs[0].album);
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
                    listofsongs.isEmpty?
                    const Center(child: CircularProgressIndicator(
                      color: Colors.green,
                    ),)
                        : Expanded(
                      child: ListView.builder(
                        itemCount: listofsongs.length,
                        itemBuilder: (context, index) {
                          SongModel song = listofsongs[index];
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
                                      child: Icon(controller.songArtist.value == widget.artistName && controller.songIndex.value == index && controller.isPlaying.value?Icons.pause_circle_outline:Icons.play_circle_filled_outlined,color: Colors.black,),
                                    ),
                                    onTap: (){
                                      Get.to(
                                            ()=>  MusicPlayer(data: listofsongs,
                                        ),
                                        transition: Transition.downToUp,
                                      );
                                      controller.playSong(song.uri,index);
                                      controller.songArtist.value = song.artist ?? 'unknown';
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
