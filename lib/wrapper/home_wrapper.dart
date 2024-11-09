import 'package:flutter/material.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DefaultTabController(
          length: 4, // Number of tabs
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: TabBar(
              tabs: [
                Tab(text: "Search"),
                Tab(text: "PlayList"),
                Tab(text: "Tab 3"),
                Tab(text: "Tab 4"),
              ],
            ),
            body: TabBarView(
              children: [
                Center(child: Text('Content for Tab 1')),
                Center(child: Text('Content for Tab 2')),
                Center(child: Text('Content for Tab 3')),
                Center(child: Text('Content for Tab 4')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
