import 'package:anim_search/commons/constants.dart';
import 'package:anim_search/models/chapter_image.dart';
import 'package:anim_search/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewChapterImages extends StatefulWidget {
  final int comicId;
  final int displayOrder;

  const ViewChapterImages({super.key, required this.comicId, required this.displayOrder});

  @override
  _ViewChapterImagesState createState() => _ViewChapterImagesState();
}

class _ViewChapterImagesState extends State<ViewChapterImages> {
  final ScrollController _scrollController = ScrollController();
  late int currentComicId;
  late int currentChapterIndex;
  String currentChapterTitle = '';
  late int currentChapterId; // This will store the actual chapterId from the data
  @override
  void initState() {
    super.initState();
    currentComicId = widget.comicId;
    currentChapterIndex = widget.displayOrder;

    // Fetch initial data
    _fetchChapterImages();
  }

  void _fetchChapterImages() {
    Future.microtask(() async {
      final provider = Provider.of<DataProvider>(context, listen: false);

      // Fetch episode and images by comicId and displayOrder
      await provider.GetEpisodeByComicIdAndDisplayOrder(currentComicId, currentChapterIndex);
        currentChapterId = provider.currentChapterId;
        // Now we can safely post the history
        _createHistory();
        provider.getMaxDisplayOrder(currentComicId);
    });
  }

  Future<void> _createHistory() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = int.parse(prefs.getString("userId")!);

    final provider = Provider.of<DataProvider>(context, listen: false);

    final success = await provider.postHistory(userId, currentComicId, currentChapterId);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to record reading history.')),
      );
    }
  }

  void _goToNextChapter() async {
    final provider = Provider.of<DataProvider>(context, listen: false);

    // Fetch the max display order from the API
    final maxDisplayOrder = await provider.getMaxDisplayOrder(currentComicId);

    setState(() {
      // Check if the next chapter is within the maximum display order
      if (currentChapterIndex < maxDisplayOrder) {
        currentChapterIndex++; // Increase the chapter ID
        _fetchChapterImages(); // Fetch new chapter images
      } else {
        // Optionally show a message that this is the last chapter
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are at the last chapter.')),
        );
      }
    });
  }


  void _goToPreviousChapter() {
    setState(() {
      // Ensure the chapter ID is greater than or equal to 1
      if (currentChapterIndex > 1) {
        currentChapterIndex--; // Decrease the chapter ID
        _fetchChapterImages(); // Fetch new chapter images
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter $currentChapterIndex'), // You can customize this title
      ),
      body: Consumer<DataProvider>(builder: (context, provider, child) {
        if (provider.isLoading && provider.chapterImages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.chapterImages.isEmpty) {
          return const Center(child: Text('No images found for this chapter.'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: provider.chapterImages.length,
                itemBuilder: (context, index) {
                  ChapterImages chapterImage = provider.chapterImages[index];
                  return Column(
                    children: [
                      Image.network(
                        "${Constants.domain_uri}/${chapterImage.url}",
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            color: Colors.red,
                            size: 50,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goToPreviousChapter,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _goToNextChapter,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
