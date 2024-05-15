import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proj/controller/player_controller.dart';
import 'package:proj/style.dart';

class Playlist extends StatelessWidget {
  const Playlist({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
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
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Text(
              "Add some songs",
              style: ourStyle("regular", 14, Colors.white),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, int n) {
                  return Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: ListTile(
                      title: Text(
                        "Music Name",
                        style: ourStyle("bold", 18, Colors.white),
                      ),
                      leading: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/u.jpeg'),
                                fit: BoxFit.contain),
                            color: Colors.white,
                          ),),
                      subtitle: Text(
                        "Artist Name",
                        style: ourStyle("regular", 14, Colors.white),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.play_circle,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
