import 'package:anim_search/models/anime_model.dart';
import 'package:anim_search/models/comic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnimeDetailsHeader extends StatelessWidget {
  final Comic animeData;
  const AnimeDetailsHeader({super.key, required this.animeData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                animeData.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.5),
              Text(
                animeData.slug ?? "<no slug provided>",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1),
              Text(
                DateFormat.yMMMd().format(animeData.createdAt),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1),
              Text(
                animeData.rating.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1),
              Text(
                animeData.episodes.length <= 0
                    ? 'Ongoing'
                    : '${animeData.episodes} Episodes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '${animeData.rating}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                    backgroundColor: Colors.grey.withOpacity(.35),
                    strokeWidth: 6.0,
                    value: animeData.rating / 5,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                animeData.rating != 0
                    ? 'Ranked\n #${animeData.rating}'
                    : 'Ranked\n N/A',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),

      ],
    );
  }
}
