import 'package:anim_search/providers/data_provider.dart';
import 'package:anim_search/screens/anime_follow_page.dart';
import 'package:anim_search/screens/anime_grid_screen.dart';
import 'package:anim_search/screens/change_password.dart';
import 'package:anim_search/screens/history_screen.dart';
import 'package:anim_search/screens/list_category_page.dart';
import 'package:anim_search/screens/login_screen.dart';
import 'package:anim_search/screens/profile_screen.dart';
import 'package:anim_search/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
    HistoryScreen(),
    ProfileScreen(),
    ChangePassword()
  ];

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                var prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // Navigate to the login screen after logout
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
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
              title: Text('History'),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Change Password'),
              onTap: () {
                setState(() {
                  _selectedIndex = 5;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                _showLogoutConfirmation(context);
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
