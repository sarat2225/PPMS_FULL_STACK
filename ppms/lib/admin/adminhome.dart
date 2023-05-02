import 'package:flutter/material.dart';
import 'package:ppms/global/appbar.dart';
import 'package:ppms/admin/admindashboard.dart';
import 'package:ppms/admin/listofstudents.dart';
import 'package:ppms/admin/listofprofessors.dart';

class NavigationMenu extends StatefulWidget {
  final int currentPage;
  final Function(int) onPageChanged;

  NavigationMenu({required this.currentPage, required this.onPageChanged});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage;
  }

  @override
  void didUpdateWidget(NavigationMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != oldWidget.currentPage) {
      setState(() {
        _currentPage = widget.currentPage;
      });
    }
  }

  void _handlePageChange(int page) {
    setState(() {
      _currentPage = page;
    });
    widget.onPageChanged(page);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 240,
      color: Colors.white,
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text("Dashboard"),
            selected: _currentPage == 1,
            onTap: () {
              _handlePageChange(1);
            },
          ),
          PopupMenuDivider(),
          ListTile(
            leading: Icon(Icons.school),
            title: Text("Students"),
            selected: _currentPage == 2,
            onTap: () {
              _handlePageChange(2);
            },
          ),
          PopupMenuDivider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Faculty"),
            selected: _currentPage == 3,
            onTap: () {
              _handlePageChange(3);
            },
          ),
          PopupMenuDivider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            selected: _currentPage == 4,
            onTap: () {
              _handlePageChange(4);
            },
          ),
        ],
      ),
    );
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int currentPage = 1;

  void _handlePageChange(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: CustomAppBar(
          pageTitle: 'Home Page',
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 60,
            ),
            NavigationMenu(
                currentPage: currentPage, onPageChanged: _handlePageChange),
            if (currentPage == 1) Expanded(child: Dashboard()),
            if (currentPage == 2) Expanded(child: StudentTable()),
            if (currentPage == 3) Expanded(child: professorTable()),
          ],
        ),
      ),
    );
  }
}
