import 'package:anim_search/widgets/home_card.dart';
import 'package:anim_search/widgets/new_home_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:anim_search/providers/data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'error_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getData();
  }

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = int.parse(prefs.getString("userId")!);
    await Provider.of<DataProvider>(context, listen: false).getAllHistoryComics(userId);
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context);
    final screenHeight = device.size.height;
    final screenWidth = device.size.width;

    final homeData = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: homeData.isError
            ? ErrorScreen(homeData.errorMessage)
            : homeData.isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
            strokeWidth: 5,
          ),
        )
            : RefreshIndicator(
          onRefresh: getData,
          color: Colors.orange,
          strokeWidth: 2.5,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            itemCount: homeData.histories.length,
            itemBuilder: (context, index) {
              return HomeCard(
                historyData: homeData.histories[index],
                cardIndex: index,
              );
            },
          ),
        ),
      ),
    );
  }
}
