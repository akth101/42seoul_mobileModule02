import 'package:flutter/material.dart';

class WeatherUI extends StatefulWidget {
  const WeatherUI({
    super.key,
  });

  @override
  State<WeatherUI> createState() => _WeatherUIState();
}

class _WeatherUIState extends State<WeatherUI> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return MaterialApp(
      home: Scaffold(
        appBar: topBarUI(),
        body: middleUI(screenSize),
        bottomNavigationBar: bottomBarUI(),
      ),
    );
  }

  BottomAppBar bottomBarUI() {
    return BottomAppBar(
        color: Colors.white,
        child: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
          Tab(icon: Icon(Icons.sunny), text: "Currently",),
          Tab(icon: Icon(Icons.calendar_today), text: "Today"),
          Tab(icon: Icon(Icons.calendar_month), text: "Weekly",),
          ],
        ),
      );
  }

  TabBarView middleUI(Size screenSize) {
    return TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(child: Text("Currently", style: TextStyle(fontSize: screenSize.width * 0.05),),),
          Center(child: Text("Today", style: TextStyle(fontSize: screenSize.width * 0.05),),),
          Center(child: Text("Weekly", style: TextStyle(fontSize: screenSize.width * 0.05),),),
      ]);
  }

  AppBar topBarUI() {
    return AppBar(
      leading: const Icon(Icons.search),
      titleSpacing: -8,
      backgroundColor: Colors.blue,
      title: const TextField(
        decoration: InputDecoration(
          hintText: "find location",
          border: InputBorder.none,
        ),
      ),
      actions: const [
        VerticalDivider(
          indent: 10,
          endIndent: 10,
        ),
        Padding(
            padding: EdgeInsets.only(right: 16, left: 6),
            child: Icon(Icons.gps_fixed_outlined)),
      ],
    );
  }
}
