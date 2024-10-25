import 'package:anim_search/commons/constants.dart';
import 'package:anim_search/models/comic.dart';
import 'package:anim_search/screens/anime_details_screen.dart';
import 'package:flutter/material.dart';

class NewHomeCard extends StatelessWidget {
  final Comic homeData;
  final int cardIndex;

  const NewHomeCard({super.key, 
    required this.homeData,
    this.cardIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    // final device = MediaQuery.of(context);
    // final screenHeight = device.size.height;
    // final screenWidth = device.size.width;
    return InkWell(
      onTap: () async => await Navigator.of(context).pushNamed(
        AnimeDetailScreen.routeName,
        arguments: homeData.id,
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: homeData.id,
                child: Image.network(
                  "${Constants.domain_uri}/${homeData.poster}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    homeData.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(

                  icon: Icon(null),
                  onPressed: null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
