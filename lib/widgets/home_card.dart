import 'package:anim_search/commons/constants.dart';
import 'package:anim_search/models/history.dart';
import 'package:anim_search/providers/data_provider.dart';
import 'package:anim_search/screens/view_chapter_images.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCard extends StatelessWidget {
  final History historyData;
  final int cardIndex;

  const HomeCard({
    super.key,
    required this.historyData,
    this.cardIndex = 0,
  });

  Future<void> _handleRemove(BuildContext context, int comicId) async {
    final prefs = await SharedPreferences.getInstance();
    int userId = int.parse(prefs.getString("userId")!);
    // Call the login method and capture the result
    bool result = await Provider.of<DataProvider>(context, listen: false).removeFromHistory(userId, comicId);
    if (result) {
      // Handle successful removal, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from history')),
      );
    } else {
      // Handle error, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove from history')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          // Comic Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Hero(
              tag: historyData.comicId!,
              child: Image.network(
                "${Constants.domain_uri}/${historyData.imageUrl}",
                width: 80,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10), // Spacing between image and text

          // Comic Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  historyData.comicName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5), // Spacing between title and chapter
                Text(
                  "Continue Chapter: ${historyData.episodeName}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewChapterImages(
                        comicId: historyData.comicId!,
                        displayOrder: historyData.displayOrder!,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Icon(Icons.remove_red_eye_sharp, color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  // Replace userId with the actual user ID when available
                  _handleRemove(context, historyData.comicId!);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Icon(LineAwesomeIcons.trash_alt, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
