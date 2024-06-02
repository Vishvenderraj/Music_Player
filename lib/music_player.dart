import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:proj/style.dart';
import 'controller/player_controller.dart';

class MusicPlayer extends StatefulWidget {
  final List<SongModel> data;
  const MusicPlayer({super.key, required this.data});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer>
    with SingleTickerProviderStateMixin {
  var controller = Get.find<PlayerController>();
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    if (controller.isPlaying.value) {
      animationController.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
          child: BlurryContainer(
            padding: const EdgeInsets.all(15),
            color: Colors.white.withOpacity(0.4),
            elevation: 10,
            blur: 15,
            borderRadius: BorderRadius.circular(0),
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding:  EdgeInsets.all(5.0),
                            child:  Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                     Column(
                       children: [
                         Text("Playing From Album",style: ourStyle('n', 12, Colors.black),),
                         const SizedBox(height: 5,),
                         Text("Inner song",style: ourStyle("bold", 15, Colors.white),)
                       ],
                     ),
                     Container(
                       decoration: BoxDecoration(
                         color: Colors.black.withOpacity(0.2),
                         shape: BoxShape.circle,
                       ),
                       child: const Padding(
                         padding:  EdgeInsets.all(5.0),
                         child:  Icon(
                                Icons.more_horiz_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                       ),
                     ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(() => Center(
                    child: Container(
                      height: MediaQuery.sizeOf(context).height/2,
                      width:  MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: QueryArtworkWidget(
                        artworkBorder: BorderRadius.circular(20),
                        artworkWidth: double.infinity,
                        id: widget.data[controller.songIndex.value].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                          child: const Image(
                            fit: BoxFit.contain,
                            image: AssetImage(
                              'assets/disk.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(()=> Text(
                    widget.data[controller.songIndex.value].displayName,
                    style: ourStyle("bold", 27, Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(()=>Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.data[controller.songIndex.value].artist!,
                        style: ourStyle("normal", 25, Colors.white),
                      ),
                      Icon(
                        CupertinoIcons.heart_circle_fill,
                        color: Colors.grey.shade100,
                        size: 25,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        ()=> Row(
                          children: [
                            Text(controller.position.value,style: ourStyle("n", 11, Colors.white),),
                            Expanded(
                              child: Slider(
                                value: controller.value.value,
                                onChanged: (value) {
                                  controller.changeDurationToSeconds(value.toInt());
                                  value = value;
                                },
                                min: const Duration(seconds: 0).inSeconds.toDouble(),
                                max: controller.max.value,
                                activeColor: Colors.white,
                                inactiveColor: Colors.white.withOpacity(0.3),
                                autofocus: true,
                                thumbColor: Colors.white,
                              ),
                            ),
                            Text(controller.duration.value,style: ourStyle("n", 11, Colors.white),),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.shuffle,
                            color: Colors.grey.shade300,
                            size: 22,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          IconButton(
                            onPressed: (){
                              int prevIndex = controller.songIndex.value-1;
                              if(prevIndex<0)
                                {
                                  prevIndex = widget.data.length-1;
                                }
                              controller.playSong(widget.data[prevIndex].uri,true, prevIndex);
                            },
                            icon:const Icon(CupertinoIcons.backward_end_fill),
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (controller.isPlaying.value) {
                                animationController.reverse();
                                controller.audioPlayer.pause();
                                controller.playPause();
                              } else {
                                animationController.forward();
                                controller.audioPlayer.play();
                                controller.playPause();
                              }
                            },
                            child: BlurryContainer(
                              blur: 15,
                              height: 65,
                              width: 65,
                              elevation: 1,
                              shadowColor: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white.withOpacity(0.3),
                              child: Center(
                                child: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: animation,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                           IconButton(onPressed:  (){
                             int changeIndex = controller.songIndex.value+1;
                             if(changeIndex>=widget.data.length)
                               {
                                 changeIndex = 0;
                               }
                            controller.playSong(widget.data[changeIndex].uri, true, changeIndex);
                          }, icon: const Icon(CupertinoIcons.forward_end_fill),color: CupertinoColors.white,),
                          const SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            onTap: (){
                              controller.audioPlayer.loopMode;
                            },
                            child: Icon(
                              CupertinoIcons.repeat,
                              color: Colors.grey.shade300,
                              size: 25,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
