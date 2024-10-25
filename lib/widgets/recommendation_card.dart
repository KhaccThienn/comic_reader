import 'package:anim_search/commons/constants.dart';
import 'package:anim_search/models/comic.dart';
import 'package:flutter/material.dart';
import '../screens/anime_details_screen.dart';
import '../models/recommendation_model.dart';

class RecommendationCard extends StatelessWidget {
  final Comic recData;

  const RecommendationCard({super.key, 
    required this.recData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      clipBehavior: Clip.none,
      child: InkWell(
        onTap: () => Navigator.of(context).pushReplacementNamed(
          AnimeDetailScreen.routeName,
          arguments: recData.id,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "${Constants.domain_uri}/${recData.poster}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              recData.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
