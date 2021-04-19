import 'dart:io';

import 'package:flutter/material.dart';
import 'package:near/logic/providers/provider_app.dart';
import 'package:near/presentations/screen_home.dart';
import 'package:near/presentations/screen_join.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _confirmExit(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Constants.appName),
          actions: [
            Switch(
              value: Provider.of<AppProvider>(context).isDarkMode,
              onChanged: (value) => {
                if (value)
                  Provider.of<AppProvider>(context, listen: false)
                      .setTheme('dark')
                else
                  Provider.of<AppProvider>(context, listen: false)
                      .setTheme('light')
              },
            ),
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: pageChanged,
          children: <Widget>[
            Home(),
            Join(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _page,
            onTap: navigationTap,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.backup,
                ),
                label: "Conference",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.insert_drive_file,
                ),
                label: "Create-id",
              ),
            ]),
      ),
    );
  }

  void navigationTap(pageIdx) {
    _pageController.jumpToPage(pageIdx);
  }

  void pageChanged(pageIdx) {
    setState(() {
      this._page = pageIdx;
    });
  }

  _confirmExit(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure to exit?'),
          content: Text("You wont be connected"),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () => exit(0),
            ),
            TextButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
