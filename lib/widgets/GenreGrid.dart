import 'package:anim_search/providers/data_provider.dart';
import 'package:anim_search/screens/comic_by_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenreGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the data provider
    final dataProvider = Provider.of<DataProvider>(context);

    // Check if loading or has error
    if (dataProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (dataProvider.isError) {
      return Center(child: Text(dataProvider.errorMessage));
    }

    // Build the grid view for genres
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        childAspectRatio: 1.0, // Adjusts the height and width ratio of each item
        crossAxisSpacing: 10, // Space between columns
        mainAxisSpacing: 10, // Space between rows
      ),
      itemCount: dataProvider.genres.length,
      itemBuilder: (context, index) {
        final genre = dataProvider.genres[index];
        return GestureDetector(
          onTap: () {
            // Handle genre tap if needed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComicByCategory(genre: genre,),
              ),
            );
          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category, size: 50), // You can change the icon
                  SizedBox(height: 10),
                  Text(
                    genre.name, // Assuming 'name' is the field for genre name
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
