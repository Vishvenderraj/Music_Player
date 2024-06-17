import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proj/Main%20pages/Album/album_list.dart';
import 'package:proj/Main%20pages/Artist/artist_list.dart';
import 'package:proj/Main%20pages/Playlist/playlist.dart';
import 'package:proj/styles/style.dart';
import 'package:proj/Main%20pages/Tracks/track_list.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Fleet',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle:  GoogleFonts.roboto(
            fontSize: 25,
          ),
        ),
        textTheme: TextTheme(
          labelMedium: GoogleFonts.roboto(
            fontSize: 25,
          ),
          bodyMedium: GoogleFonts.roboto(
            fontSize: 25,
          ),
        ).apply(bodyColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MySecondHomePage(),
    );
  }
}
int _selectedIndex = 0;
List<BottomNavigationBarItem> pages = [
  BottomNavigationBarItem(icon: const Icon(CupertinoIcons.person,),label: 'Artist',backgroundColor: Colors.black.withOpacity(0.6)),
  BottomNavigationBarItem(icon: const Icon(Icons.album_outlined),label: 'Album',backgroundColor: Colors.black.withOpacity(0.6)),
  BottomNavigationBarItem(icon: const Icon(CupertinoIcons.music_note_2),label: 'Tracks',backgroundColor: Colors.black.withOpacity(0.6)),
  BottomNavigationBarItem(icon: const Icon(CupertinoIcons.music_note_list),label: 'Playlist',backgroundColor: Colors.black.withOpacity(0.6)),
];

 List getBody = const [
   ArtistList(),
   AlbumList(),
   TrackList(),
   Playlist(),
 ];

class MySecondHomePage extends StatefulWidget {
  const MySecondHomePage({super.key});

  @override
  State<MySecondHomePage> createState() => _MySecondHomePageState();
}

class _MySecondHomePageState extends State<MySecondHomePage> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      bottomNavigationBar: SizedBox(
        height: MediaQuery.sizeOf(context).height*0.075,
        child: BottomNavigationBar(
          elevation: 10,
          type: BottomNavigationBarType.shifting,
          unselectedLabelStyle: ourStyle("bold", 15, Colors.grey),
          selectedLabelStyle: ourStyle("bold", 15, Colors.white),
          selectedIconTheme: const IconThemeData(color: CupertinoColors.white),
          unselectedIconTheme: const IconThemeData(color: CupertinoColors.systemGrey2),
          currentIndex: _selectedIndex,
          items: pages,
          onTap: (idx){
            setState(() {
              _selectedIndex = idx;
            });
          },
        ),
      ),
      body: getBody[_selectedIndex],
      );
  }
}
