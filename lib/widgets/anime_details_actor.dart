import 'package:anim_search/models/ComicDetail.dart';
import 'package:flutter/material.dart';

class AnimeDetailsActor extends StatelessWidget {
  final ComicDetail comic;

  const AnimeDetailsActor({super.key, required this.comic});

  Widget moveLabel(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      // Điều chỉnh padding cho đẹp
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 7,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic extractedGenre;
    // Đảm bảo genreList không null và xử lý trường hợp rỗng
    final List<Actor> actorList = comic.actors ?? [];

    if (actorList.isEmpty) {
      return Center(
          child: Text(
              "No genres available")); // Hiển thị thông báo khi danh sách trống
    }

    return GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        childAspectRatio: 6 / 1.5,
        crossAxisSpacing: 4,
        children: actorList
            .map((item) =>
                moveLabel(item.name)) // Sử dụng item.name trong moveLabel
            .toList());
    // Điều chỉnh khoảng cách ngang
  }
}
