import 'package:anim_search/commons/constants.dart';
import 'package:anim_search/models/ComicDetail.dart';
import 'package:anim_search/models/comic.dart';
import 'package:anim_search/models/episode_and_images.dart';
import 'package:anim_search/providers/data_provider.dart';
import 'package:anim_search/screens/episode_list_screen.dart';
import 'package:anim_search/widgets/anime_details_actor.dart';
import 'package:anim_search/widgets/anime_details_director.dart';
import 'package:anim_search/widgets/anime_details_genres.dart';
import 'package:anim_search/widgets/anime_details_header.dart';
import 'package:anim_search/widgets/recommendation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimeDetailScreen extends StatefulWidget {
  static const routeName = '/animedetailscreen';

  const AnimeDetailScreen({super.key});

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  var _isInit = true;
  var _isFavorite = false;
  late int comicId;
  
  final TextEditingController _commentController =
      TextEditingController(); // Controller for comment field
  bool _isSubmitting = false; // State to track submission status

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      comicId = ModalRoute.of(context)!.settings.arguments as int;
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.getAnimeData(comicId);
      dataProvider.getAnimeDetailsData(comicId);
      dataProvider.getReviewsByComicId(comicId); // Fetch comments for this comic
      _checkFavorite(comicId);
    }
    _isInit = false;
  }

  Future<void> _checkFavorite(int comicId) async {
    final prefs = await SharedPreferences.getInstance();
    var userId = int.parse(prefs.getString("userId")!);
    final result = await Provider.of<DataProvider>(context, listen: false)
        .checkFavouriteExist(userId, comicId);
    if (result) {
      setState(() {
        _isFavorite = result;
      });
    }
  }

  Future<void> _toggleFavorite(int comicId) async {
    final prefs = await SharedPreferences.getInstance();
    var userId = int.parse(prefs.getString("userId")!);
    final result = _isFavorite
        ? await await Provider.of<DataProvider>(context, listen: false)
            .removeFromFavourite(userId, comicId)
        : await await Provider.of<DataProvider>(context, listen: false)
            .addToFavourite(userId, comicId);
    if (result) {
      setState(() {
        _isFavorite = !_isFavorite; // Đổi trạng thái yêu thích
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_isFavorite
                ? "Added to favorites!"
                : "Removed from favorites!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error when Toggle Favorite")),
      );
    }
  }

  // Method to handle posting a comment without reloading the screen
  Future<void> _postComment() async {

    final prefs = await SharedPreferences.getInstance();
    var userId = int.parse(prefs.getString("userId")!);

    // Assuming you have a function `postComment` in your DataProvider
    final success = await Provider.of<DataProvider>(context, listen: false)
        .postComment(userId, comicId, _commentController.text);

    if (success) {
      _commentController.clear(); // Clear the comment field on success

      // Update comments list without rebuilding the entire screen
      await Provider.of<DataProvider>(context, listen: false)
          .getReviewsByComicId(comicId); // Fetch new comments

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Comment posted successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to post comment.")),
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final Comic animeData = dataProvider.comic!;
    final ComicDetail comicDetail = dataProvider.comicDetail!;
    final device = MediaQuery.of(context);
    final screenWidth = device.size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.orange,
      body: !dataProvider.isLoading
          ? Container(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: screenWidth / 1.3,
                    width: screenWidth,
                    color: Colors.orange,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.multiply),
                      child: Hero(
                        tag: animeData.id,
                        child: Image.network(
                          "${Constants.domain_uri}/${animeData.poster}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(top: screenWidth / 1.5),
                    clipBehavior: Clip.none,
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25)
                                .copyWith(top: 25),
                            child: AnimeDetailsHeader(
                              animeData: animeData,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // Adjust alignment
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to EpisodeListScreen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EpisodeListScreen(
                                          comicId: animeData
                                              .id, // Pass comicId to EpisodeListScreen
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.orange, // Button color
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10), // Button padding
                                  ),
                                  child: Text(
                                    "Read",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5)),
                                ElevatedButton(
                                  onPressed: () => _toggleFavorite(comicId),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade200,
                                    // Button color
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10), // Button padding
                                  ),
                                  child: Icon(
                                    _isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15)
                                .copyWith(top: 25),
                            child: Html(
                              data: animeData.description,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: const Text(
                              'Genre',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            child: AnimeDetailsGenres(
                              comic: comicDetail,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: const Text(
                              'Main Character',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            child: AnimeDetailsActor(
                              comic: comicDetail,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: const Text(
                              'Author',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            child: AnimeDetailsDirector(
                              comic: comicDetail,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: const Text(
                              'Comics Like This',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            height: screenWidth / 2,
                            width: screenWidth,
                            margin: EdgeInsets.symmetric(vertical: 15)
                                .copyWith(bottom: 35),
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: dataProvider.comics.length,
                              itemBuilder: (context, index) =>
                                  RecommendationCard(
                                recData: dataProvider.comics[index],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: const Text(
                              'Comments',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          // Post Comment Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'Post a Comment',
                              style: TextStyle(
                                fontSize: 18,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextField(
                              controller: _commentController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: "Write your comment here...",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey), // Define border color
                                  // No borderRadius for squared corners
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: _postComment,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: _isSubmitting
                                    ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text('Post Comment', style: TextStyle(color: Colors.black,),),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              child: dataProvider.reviews.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: dataProvider.reviews.length,
                                      itemBuilder: (context, index) {
                                        final comment =
                                            dataProvider.reviews[index];
                                        // Format the date as dddd-MM-yy (e.g., Friday-12-23)
                                        String formattedDate =
                                            DateFormat('EEEE MM, yyyy')
                                                .format(comment.createdAt!);
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          // Add margin between comments
                                          padding: const EdgeInsets.all(10),
                                          // Padding inside the box
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            // Add a border
                                            borderRadius: BorderRadius.circular(
                                                10), // Round the edges
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      "${Constants.domain_uri}/${comment.userAvatar}",
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  // Space between avatar and text
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        comment.userName!,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        formattedDate,
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              // Space between the header and comment
                                              Text(comment.comment!),
                                              // Space between comment
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text("No comments yet."),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5,
              ),
            ),
    );
  }
}
