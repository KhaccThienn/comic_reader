import 'dart:convert';
import 'dart:io';
import 'package:anim_search/commons/constants.dart';
import 'package:anim_search/models/ComicDetail.dart' as CD;
import 'package:anim_search/models/anime_model.dart';
import 'package:anim_search/models/chapter_image.dart';
import 'package:anim_search/models/comic.dart';
import 'package:anim_search/models/comic_review.dart';
import 'package:anim_search/models/episode.dart';
import 'package:anim_search/models/episode_and_images.dart';
import 'package:anim_search/models/history.dart';
import 'package:anim_search/models/home_card_model.dart';
import 'package:anim_search/models/recommendation_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider with ChangeNotifier {
  bool isLoading = false;
  bool isError = false;
  String errorMessage = '';

  List<Comic> comics = [];
  List<Comic> searchList1 = [];
  List<HomeCardModel> searchList = [];
  List<RecommendationModel> recommendationList = [];
  List<CD.Genre> genres = [];
  List<Episode> episodes = [];
  List<ChapterImages> chapterImages = [];
  List<ComicReview> reviews = [];
  List<History> histories = [];

  late int? genreId;
  late AnimeModel animeData = AnimeModel();
  late User user;
  late User user1;
  late Comic comic;
  late Episode episode;
  late CD.ComicDetail comicDetail;

  late int currentChapterId;
  late int currentChapterDisplayOrder;
  late EpisodeAndImages episodeAndImages;
  late int maxDisplayOrder = 10;


  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Auth/login";

    try {
      log.d(email);
      log.d(password);

      final response = await http.post(
        Uri.parse(uri),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      log.d(response.body);

      // Check if the response is successful
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        user = User.fromJson(jsonData as Map<String, dynamic>);

        if (user.role == "USER" || user.role == "user") {
          // Handle null cases properly
          await prefs.setString('userId', user.id?.toString() ?? "0");
          await prefs.setString('displayName', user.name ?? "Unknown");
          await prefs.setString('email', user.email ?? "No Email");
          await prefs.setString('avatar', user.avatar ?? ""); // Default to empty string if null

          notifyListeners();
          return true; // Return true indicating success
        } else {
          return false; // Return false for unauthorized login
        }
      } else {
        return false; // Return false for unsuccessful login
      }
    } catch (e) {
      log.e('Error occurred: $e');
      return false; // Return false for any exception
    }
  }

  Future<bool> register(
      {required String name,
        required String email,
        required String password,
        String role = "USER"}) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Auth/register";

    try {
      final response = await http.post(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "name": name,
            "email": email,
            "password": password,
            "role": role
          }));
      log.d(response.body);
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        user1 = User.fromJson(jsonData as Map<String, dynamic>);
        notifyListeners();
        return true; // Return true indicating success
      } else {
        return false; // Return false for unsuccessful registration
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> getUserData(int userId) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/User/onlyUser/$userId";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response.body);

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        user1 = User.fromJson(jsonData as Map<String, dynamic>);
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<bool> UpdateUser(
      {required int userId,
        required String name,
        required String email,
        required File? imageFile,
        String role = "USER"}) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/User/$userId";

    try {
      log.d({
        "name": name,
        "email": email,
        "ImageFile": imageFile,
        "role": role
      });
      final response = await http.put(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'multipart/form-data;',
          },
          body: jsonEncode({
            "name": name,
            "email": email,
            "ImageFile": imageFile,
            "role": role
          }));
      log.d(response.body);

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        user1 = User.fromJson(jsonData as Map<String, dynamic>);
        notifyListeners();
        return true; // Return true indicating success
      } else {
        return false; // Return false for unsuccessful
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<http.StreamedResponse> updateInformation(
      int userId, User model, bool hasFile, String filePath) async {
    String uri = "${Constants.domain_uri}/api/User/$userId";
    var request = http.MultipartRequest("PUT", Uri.parse(uri));

    // If there is no file, add an empty file
    if (!hasFile) {
      request.files.add(http.MultipartFile.fromBytes("ImageFile", [], filename: ""));
    } else {
      request.files.add(await http.MultipartFile.fromPath("ImageFile", filePath));
    }

    // Add fields from User model
    request.fields.addAll({
      "id": userId.toString(),
      "name": model.name!,
      "email": model.email!,
      "role": model.role!,
      "createdAt": model.createdAt?.toIso8601String() ?? "",
      "updatedAt": model.updatedAt?.toIso8601String() ?? "",
    });

    return request.send();
  }

  Future<bool> UpdatePassword(
      {required int userId,
        required String oldPass,
        required String newPass
      }) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/User/ChangePassword/$userId";

    try {
      log.d({
        "userId": userId,
        "oldPass": oldPass,
        "newPass": newPass,
      });
      final response = await http.put(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "OldPassword": oldPass,
            "NewPassword": newPass,
          }));
      log.d(response.body);

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        user1 = User.fromJson(jsonData as Map<String, dynamic>);
        notifyListeners();
        return true; // Return true indicating success
      } else {
        return false; // Return false for unsuccessful
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> getHomeData() async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Comic";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response.body);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        comics = jsonData.map((comic) => Comic.fromJson(comic)).toList();
        searchList1 = comics;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> searchData(String query) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Comic/search/${query}";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response.body);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        comics = jsonData.map((comic) => Comic.fromJson(comic)).toList();
        searchList1 = comics;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> getEpisodeByComicIdAndDisplayOrder(int comicId, int displayOrder) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Episode/ByComic/$comicId/DisplayOrder/$displayOrder";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response.body);

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        episode = Episode.fromJson(jsonData as Map<String, dynamic>);
        isLoading = false;
        notifyListeners();
      } else {
        isError = true;
        errorMessage = 'Failed to load episode';
      }
    } catch (e) {
      log.e('Error occurred: $e');
      isError = true;
      errorMessage = 'An error occurred while fetching the episode';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getAllFavourite(int userId) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Favourite/$userId";
    log.d(userId);
    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      log.d(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        comics = jsonData.map((comic) => Comic.fromJson(comic)).toList();
        isLoading = false;
        notifyListeners();
        // return true; // Return true indicating success
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<bool> checkFavouriteExist(int userId, int comicId) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Favourite/check/${userId}/${comicId}";

    try {
      final response = await http.get(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      log.d(response.statusCode);
      if (response.statusCode == 200) {
        notifyListeners();
        return true; // Return true indicating success
      } else {
        return false; // Return false for unsuccessful registration
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<bool> addToFavourite(int userId, int comicId) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Favourite/add";

    try {
      final response = await http.post(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "comicId": comicId,
            "userId": userId
          }));
      log.d(response.statusCode);
      if (response.statusCode == 200) {
        notifyListeners();
        return true; // Return true indicating success
      } else {
        return false; // Return false for unsuccessful registration
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<bool> removeFromFavourite(int userId, int comicId) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Favourite/remove/${userId}/${comicId}";

    try {
      final response = await http.delete(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "comicId": comicId,
            "userId": userId
          }));
      log.d(response.statusCode);
      if (response.statusCode == 200) {
        notifyListeners();
        return true; // Return true indicating success
      } else {
        return false; // Return false for unsuccessful registration
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> getReviewsByComicId(int comicId) async {
    Logger log = Logger();
    final String uri = "${Constants.domain_uri}/api/Review/getByComic/$comicId";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response.statusCode);
      log.d(response.body);

      switch(response.statusCode){
        case 200:
          List<dynamic> jsonData = jsonDecode(response.body);
          reviews = jsonData.map((review) => ComicReview.fromJson(review)).toList();
          isLoading = false;
          notifyListeners();
          break;

        case 204:
          reviews = [];
          isLoading = false;
          notifyListeners();
          break;

        default:
          isError = true;
          errorMessage = 'Failed to load reviews';
          break;
      }
    } catch (e) {
      log.e('Error occurred: $e');
      isError = true;
      errorMessage = 'An error occurred while fetching reviews';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> postComment(int userId, int comicId, String content) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Review";

    try {
      final response = await http.post(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "comment": content,
            "userId": userId,
            "comicId": comicId
          }));
      log.d(response.body);
      if (response.statusCode == 200) {
        notifyListeners();
        return true; // Return true indicating success
      } else {
        return false; // Return false for unsuccessful registration
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> getGenres() async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Genre";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response.body);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        genres = jsonData.map((comic) => CD.Genre.fromJson(comic)).toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> getComicByGenres(int genreId) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/Comic/by-genre/${genreId}";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response.body);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        comics = jsonData.map((comic) => Comic.fromJson(comic)).toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> getAnimeData(int malId) async {
    Logger log = Logger();
    final String uri = "${Constants.domain_uri}/api/Comic/$malId";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        comic = Comic.fromJson(jsonData as Map<String, dynamic>);
        log.d(comic.toString());
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> getAllChapterByComic(int comicId) async {
    Logger log = Logger();
    final String uri = "${Constants.domain_uri}/api/Episode/ByComic/$comicId";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        episodes = jsonData.map((ep) => Episode.fromJson(ep)).toList();
        log.e(comic);
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<int> getMaxDisplayOrder(int comicId) async {
    final url = "${Constants.domain_uri}/api/episode/max-display-order/$comicId"; // Replace with your actual API URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final int maxDisplayOrder = json.decode(response.body);
        notifyListeners(); // Notify listeners only if you get a valid response
        return maxDisplayOrder;
      } else {
        // Handle error response
        throw Exception(
            'Failed to fetch max display order. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      print('Error fetching max display order: $e');
      throw e; // You can also handle errors in a more user-friendly way
    }
  }

  Future<void> GetEpisodeByComicIdAndDisplayOrder(int comicId, int displayOrder) async {
    Logger log = Logger();
    final String uri = "${Constants.domain_uri}/api/Episode/ByComic/$comicId/DisplayOrder/$displayOrder";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response.body);
      log.d(response.statusCode);

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        episodeAndImages = EpisodeAndImages.fromJson(jsonData as Map<String, dynamic>);

        // Ensure episodeAndImages has a valid id and assign to currentChapterId
        currentChapterId = episodeAndImages.id!;  // Ensure this is the correct way to get chapterId
        log.d(currentChapterId);

        chapterImages = episodeAndImages.images!;
      } else {
        isError = true;
        errorMessage = 'Failed to load chapter images';
      }
    } catch (e) {
      log.e('Error occurred: $e');
      isError = true;
      errorMessage = 'An error occurred while fetching chapter images';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getAllChapterImagesByChapterId(int chapterId) async {
    Logger log = Logger();
    final String uri = "${Constants.domain_uri}/api/EpisodeImages/get-by-episode/$chapterId";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        chapterImages = jsonData.map((ci) => ChapterImages.fromJson(ci)).toList();
        currentChapterId = chapterId; // Store the current chapter ID
        log.e(comic);
      } else {
        isError = true;
        errorMessage = 'Failed to load chapter images';
      }
    } catch (e) {
      log.e('Error occurred: $e');
      isError = true;
      errorMessage = 'An error occurred while fetching chapter images';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAnimeDetailsData(int malId) async {
    Logger log = Logger();
    final String uri = "${Constants.domain_uri}/api/Comic/details/$malId";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response.body);
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        comicDetail = CD.ComicDetail.fromJson(jsonData as Map<String, dynamic>);
        log.d(comicDetail.toString());
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> getComicDetails(int comicId) async {
    Logger log = Logger();
    final String uri = "${Constants.domain_uri}/api/Episode/ByComic/$comicId";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        comic = Comic.fromJson(jsonData as Map<String, dynamic>);
        log.e(comic);
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<bool> postHistory(int userId, int comicId, int chapterId) async {
    Logger log = Logger();
    String uri = "${Constants.domain_uri}/api/History";

    try {
      final response = await http.post(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "EpisodeId": chapterId,
            "UserId": userId,
            "ComicId": comicId
          }));
      log.d(response.body);
      if (response.statusCode == 200) {
        notifyListeners();
        return true; // Return true indicating success
      } else {
        return false; // Return false for unsuccessful registration
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<void> getAllHistoryComics(int userId) async {
    Logger log = Logger();
    final String uri = "${Constants.domain_uri}/api/History/user/$userId";

    try {
      isLoading = true;
      isError = false;
      final response = await http.get(Uri.parse(uri));
      log.d(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        histories = jsonData.map((ep) => History.fromJson(ep)).toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<bool> removeFromHistory(int userId, int comicId) async {
    Logger log = Logger();
    final String uri = "${Constants.domain_uri}/api/History/user/$userId/comic/$comicId";

    try {
      isLoading = true;
      isError = false;
      final response = await http.delete(Uri.parse(uri));
      log.d(response.body);
      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log.e('Error occurred: $e');
      throw Exception(e);
    }
  }
}
