import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'GpsData.dart';
import 'WeatherApiData.dart';

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


  AppBar topBarUI() {
    return AppBar(
      leading: const Icon(Icons.search),
      titleSpacing: -8,
      backgroundColor: Colors.blue,
      // title: TextField(
      //   controller: _textController,
      //   onChanged: (String value) async {
      //     final weatherProvider = context.read<WeatherApiData>();
      //     weatherProvider.fetchCityData(value);
      //   },
      //   decoration: const InputDecoration(
      //     hintText: "find location",
      //     border: InputBorder.none,
      //   ),
      // ),
      title: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) async {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          final weatherProvider = context.read<WeatherApiData>();
          await weatherProvider.fetchCityData(textEditingValue.text);
          
          final searchResults = weatherProvider.searchResults;
          final searchText = textEditingValue.text.toLowerCase();
          
          final filteredResults = searchResults.where((result) {
            final cityName = result['name'].toString().toLowerCase();
            return cityName.contains(searchText);
          });
          
          final cityNames = filteredResults.map((result) => result['name'].toString());
          debugPrint('Filtered city names: ${cityNames.toList()}');
          return cityNames;
        },
        onSelected: (String selection) {
          debugPrint('Selected: $selection');
        },
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
                final locateProvider = context.read<GpsData>();
                locateProvider.getCurrentLocation();
              },
              child: const Icon(
                Icons.gps_fixed_outlined,
                ),
            ),
            ),
      ],
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
  Center changableText(Size screenSize, String time) {
    final locateProvider = context.watch<GpsData>();
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

}
