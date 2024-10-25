import 'package:anim_search/providers/data_provider.dart';
import 'package:anim_search/screens/anime_follow_page.dart';
import 'package:anim_search/screens/anime_grid_screen.dart';
import 'package:anim_search/screens/list_category_page.dart';
import 'package:anim_search/screens/login_screen.dart';
import 'package:anim_search/screens/profile_screen.dart';
import 'package:anim_search/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Future<void> getData() async {
    await Provider.of<DataProvider>(context, listen: false).getHomeData();
  }

  void searchData(String query) {
    Provider.of<DataProvider>(context, listen: false).searchData(query);
  }

  List<Widget> listWidget = [
    AnimeGridPage(),
    ListCategoryPage(),
    AnimeFollowPage(),
    ProfileScreen()
  ];

  Widget _buttonBuilder(String name, int myIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = myIndex;
          getData();
        });
      },
      child: FittedBox(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 2.5),
          decoration: BoxDecoration(
            color: _selectedIndex == myIndex ? Colors.white : Colors.orange,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.orange,
              width: .8,
            ),
          ),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: _selectedIndex == myIndex ? Colors.orange : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                  getData();
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Category'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Favourite'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('User Management'),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: FloatingSearchAppBar(
        colorOnScroll: Colors.white,
        liftOnScrollElevation: 0,
        elevation: 0,
        hideKeyboardOnDownScroll: true,
        title: Container(),
        hint: 'Search anime or manga',
        iconColor: Colors.orange,
        autocorrect: false,
        onFocusChanged: (isFocused) {
          if (!isFocused) {
            setState(() {
              getData();
            });
          }
        },
        leadingActions: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: IconButton(
                icon: Icon(
                  Icons.album_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                splashRadius: 25,
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                    getData();
                  });
                }),
          ),
        ],
        onSubmitted: (query) {
          setState(() {
            _selectedIndex = 0;
            searchData(query);
          });
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 25,
              margin: EdgeInsets.only(bottom: 10),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                children: [],
              ),
            ),
            Expanded(
              child: listWidget[_selectedIndex]
            ),
          ],
        ),
      ),
    );
  }
}
