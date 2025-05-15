//import 'package:bibliotech/screens/home/homepage.dart';
import 'package:flutter/material.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});
  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          //inserisco le schermate
          Container(),
          Container(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.home_rounded), text: "Home"),
            Tab(icon: Icon(Icons.list), text: "Library"),
            Tab(icon: Icon(Icons.auto_graph_rounded), text: "Statistics"),
          ],
        ),
      ),
    );
  }
}
