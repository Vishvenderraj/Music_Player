import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proj/playlist.dart';


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
      home: const Playlist()
    );
  }
}

List<BottomNavigationBarItem> pages = const[
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.person,color: Colors.white),label: 'Artist'),
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.person,color: Colors.white),label: 'Album'),
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.person,color: Colors.white),label: 'Playlists'),
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
      bottomNavigationBar: BottomNavigationBar(items: pages,
        onTap: (idx){

        },
      ),
      );
  }
}
