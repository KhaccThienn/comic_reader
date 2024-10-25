import 'package:anim_search/widgets/new_home_card.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anim_search/providers/data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'error_screen.dart';

class AnimeFollowPage extends StatefulWidget {
  const AnimeFollowPage({super.key});

  @override
  State<AnimeFollowPage> createState() => _AnimeFollowPageState();
}

class _AnimeFollowPageState extends State<AnimeFollowPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = int.parse(prefs.getString("userId")!);
    await Provider.of<DataProvider>(context, listen: false).getAllFavourite(userId);
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context);
    final screenHeight = device.size.height;
    final screenWidth = device.size.width;

    final homeData = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(

          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text('Your Favourites', style: TextStyle(
                  fontSize: 20
              ),),
            ),
            Container(
              height: screenHeight,
              width: screenWidth,
              // margin: EdgeInsets.only(top: 20),
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
                child: LiveGrid.options(
                  padding:
                  EdgeInsets.all(15).copyWith(left: 20, right: 20),
                  options: LiveOptions(
                    showItemInterval: Duration(
                      milliseconds: 100,
                    ),
                  ),
                  itemCount: homeData.comics.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5 / 2.5,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index, animation) =>
                      FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, -0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: NewHomeCard(
                            homeData: homeData.comics[index],
                            cardIndex: index,
                          ),
                        ),
                      ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
