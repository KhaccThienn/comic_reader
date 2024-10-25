import 'package:anim_search/providers/data_provider.dart';
import 'package:anim_search/widgets/GenreGrid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCategoryPage extends StatefulWidget {
  const ListCategoryPage({Key? key}) : super(key: key);

  @override
  State<ListCategoryPage> createState() => _ListCategoryPageState();
}

class _ListCategoryPageState extends State<ListCategoryPage> {
  @override
  void initState() {
    super.initState();
    // Call getGenres when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).getGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GenreGrid()
    );
  }
}
