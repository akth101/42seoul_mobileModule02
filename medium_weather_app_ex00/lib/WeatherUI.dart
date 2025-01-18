import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'LocationData.dart';

class WeatherUI extends StatefulWidget {
  const WeatherUI({
    super.key,
  });

  @override
  State<WeatherUI> createState() => _WeatherUIState();
}

class _WeatherUIState extends State<WeatherUI> with TickerProviderStateMixin {
  late final TabController _tabController;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
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
          Tab(
            icon: Icon(Icons.sunny),
            text: "Currently",
          ),
          Tab(icon: Icon(Icons.calendar_today), text: "Today"),
          Tab(
            icon: Icon(Icons.calendar_month),
            text: "Weekly",
          ),
        ],
      ),
    );
  }

  TabBarView middleUI(Size screenSize) {
    debugPrint("detected location text changing");
    return TabBarView(controller: _tabController, children: <Widget>[
      changableText(screenSize, "Currently"),
      changableText(screenSize, "Today"),
      changableText(screenSize, "Weekly"),
    ]);
  }

  Center changableText(Size screenSize, String time) {
    final locateProvider = context.watch<LocationData>();
    return locateProvider.location == "" ? 
    Center(
      child: Text(
        time,
        style: TextStyle(fontSize: screenSize.width * 0.05),
      ),
    )
    : Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(fontSize: screenSize.width * 0.05),
          ),
          Text(
            locateProvider.location,
            style: TextStyle(fontSize: screenSize.width * 0.05),
          ),
        ],
      ),
    ); 
  }

  AppBar topBarUI() {
    return AppBar(
      leading: const Icon(Icons.search),
      titleSpacing: -8,
      backgroundColor: Colors.blue,
      title: TextField(
        controller: _textController,
        onSubmitted: (String value) async {
          final locateProvider = context.read<LocationData>();
          locateProvider.fixLocation(value);
        },
        decoration: const InputDecoration(
          hintText: "find location",
          border: InputBorder.none,
        ),
      ),
      actions:  [
        const VerticalDivider(
          indent: 10,
          endIndent: 10,
        ),
        Padding(
            padding: const EdgeInsets.only(right: 16, left: 6),
            child: GestureDetector(
              onTap: () {
                final locateProvider = context.read<LocationData>();
                locateProvider.fixGeoLocation();
              },
              child: const Icon(
                Icons.gps_fixed_outlined,
                ),
            ),
            ),
      ],
    );
  }
}
