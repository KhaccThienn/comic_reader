import 'package:anim_search/screens/view_chapter_images.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:provider/provider.dart';
import 'package:anim_search/providers/data_provider.dart'; // Adjust the import as needed
import 'package:anim_search/models/episode.dart'; // Adjust the import as needed

class EpisodeListScreen extends StatefulWidget {
  final int comicId;

  const EpisodeListScreen({Key? key, required this.comicId}) : super(key: key);

  @override
  _EpisodeListScreenState createState() => _EpisodeListScreenState();
}

class _EpisodeListScreenState extends State<EpisodeListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<DataProvider>(context, listen: false).getAllChapterByComic(widget.comicId);
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final List<Episode> episodes = dataProvider.episodes;

    return Scaffold(
      appBar: AppBar(
        title: Text('Episodes List'),
      ),
      body: dataProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: episodes.length,
        itemBuilder: (context, index) {
          final episode = episodes[index];

          // Format the created date
          String formattedDate = DateFormat.yMMMd().format(episode.createdAt!);

          return ListTile(
            title: Text(episode.title!), // Display episode title
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Episode ${episode.displayOrder}'), // Display order
                Text('Created on: $formattedDate'), // Display created date
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewChapterImages(chapterId: episode.id!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
