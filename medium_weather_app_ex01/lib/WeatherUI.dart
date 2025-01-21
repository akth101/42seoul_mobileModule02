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
      title: Autocomplete<Map<String, dynamic>>(
        displayStringForOption: (option) => "${option['name']} ${option['admin1']} ${option['country']}", 
        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) async {
          if (textEditingValue.text == '') {
            return const Iterable<Map<String, dynamic>>.empty();
          }
          final weatherProvider = context.read<WeatherApiData>();
          await weatherProvider.fetchCityData(textEditingValue.text);
          
          return weatherProvider.searchResults
              .where((result) => result['name'].toString().toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()));
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final option = options.elementAt(index);
                    return ListTile(
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: option['name'],
                              style: const TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: " ${option['admin1']}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            TextSpan(
                              text: " ${option['country']}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          );
        },
        onSelected: (Map<String, dynamic> selection) {
          debugPrint('Selected: ${selection['name']} ${selection['admin1']} ${selection['country']}');
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
