import 'package:anim_search/models/ComicDetail.dart';
import 'package:anim_search/widgets/new_home_card.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:anim_search/providers/data_provider.dart';
import 'error_screen.dart';

class ComicByCategory extends StatefulWidget {
  final Genre genre;

  const ComicByCategory({super.key, required this.genre});

  @override
  State<ComicByCategory> createState() => _ComicByCategoryState();
}

class _ComicByCategoryState extends State<ComicByCategory> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await Provider.of<DataProvider>(context, listen: false).getComicByGenres(widget.genre.id);
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context);
    final screenHeight = device.size.height;
    final screenWidth = device.size.width;

    final homeData = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genre.name), // Use the genre name as the title
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
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
          child: LiveGrid.options(
            padding: EdgeInsets.all(15).copyWith(left: 20, right: 20),
            options: LiveOptions(
              showItemInterval: Duration(milliseconds: 100),
            ),
            itemCount: homeData.comics.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5 / 2.5,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemBuilder: (context, index, animation) => FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(begin: Offset(0, -0.1), end: Offset.zero).animate(animation),
                child: NewHomeCard(
                  homeData: homeData.comics[index],
                  cardIndex: index,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
