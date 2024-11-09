import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';
import 'package:music_player/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Music App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SearchPage()
        // const MusicPlayer(
        //   videoId: "lYBUbBu4W08",
        // ),
        );
  }
}
