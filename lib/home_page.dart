import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proj/playlist.dart';
import 'package:proj/seekbar.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    audioPlayer.setAudioSource(ConcatenatingAudioSource(children: []));
    super.initState();
  }
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
  Stream <SeekBarData> get _seekBarDataStream => rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
    audioPlayer.positionStream,
    audioPlayer.durationStream,
      (Duration position, Duration? duration,)
      {
        return SeekBarData(position, duration ?? Duration.zero);
      }
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.red.shade700,
                  Colors.red.shade400,
                  Colors.red.shade700
            ]
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Playlist(),),);
                      },
                        child: const CircularIconWidget(icon: CupertinoIcons.music_albums,color: Colors.white,)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('PLAYING FROM ALBUM',style: GoogleFonts.roboto(color: Colors.grey.shade200,fontSize: 14,letterSpacing: 1),),
                        const SizedBox(height: 5,),
                        const Text('Album Name',style: TextStyle(color: Colors.white,fontSize: 16.5,fontWeight: FontWeight.bold,letterSpacing: 1),)
                      ],
                    ),
                    const CircularIconWidget(icon: Icons.playlist_add,color: Colors.white)
                  ],
                ),
                const SizedBox(height: 30,),
                Expanded(
                  child: PageView.builder(itemBuilder:(context, index) => Column(
                    children: [
                      Container(
                        height: MediaQuery.sizeOf(context).height/2.2,
                        width: MediaQuery.sizeOf(context).width/1.2,
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          image: const DecorationImage(image: AssetImage('assets/22.jpg',),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Red',style: GoogleFonts.poppins(fontSize: 38),),
                                const Icon(CupertinoIcons.heart, color: Colors.white)
                              ],
                            ),
                            Text('Taylor Swift',style: GoogleFonts.poppins(fontSize: 20),)
                          ],
                         ),
                       ),
                    ],
                  ),
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height/6,
                  width: MediaQuery.sizeOf(context).width,
                  child: StreamBuilder(stream: _seekBarDataStream, builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      position: positionData?.duration ?? Duration.zero,
                      duration: positionData?.duration ?? Duration.zero,
                      onChangedEnd: audioPlayer.seek,
                    );
                  }, ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircularIconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  const CircularIconWidget({
    super.key, required this.icon, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
          color: Colors.white.withOpacity(0.1),
      ),
      child: Icon(icon,color: Colors.white,),
    );
  }
}
