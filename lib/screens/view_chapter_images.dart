import 'package:anim_search/commons/constants.dart';
import 'package:anim_search/models/chapter_image.dart';
import 'package:anim_search/providers/data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewChapterImages extends StatefulWidget {
  final int chapterId;

  const ViewChapterImages({Key? key, required this.chapterId}) : super(key: key);

  @override
  _ViewChapterImagesState createState() => _ViewChapterImagesState();
}

class _ViewChapterImagesState extends State<ViewChapterImages> {
  final ScrollController _scrollController = ScrollController();
  late int currentChapterId;

  @override
  void initState() {
    super.initState();
    currentChapterId = widget.chapterId;

    // Fetch initial data
    Future.microtask(() => Provider.of<DataProvider>(context, listen: false)
        .getAllChapterImagesByChapterId(currentChapterId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter Images'),
      ),
      body: Consumer<DataProvider>(
        builder: (context, provider, child) {
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
