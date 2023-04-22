import 'package:flutter/material.dart';
import 'package:ppms/global/appbar.dart';

class NavigationMenu extends StatelessWidget {
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
            onTap: () {
              // Navigate to Dashboard screen
            },
          ),
          PopupMenuDivider(),
          ListTile(
            leading: Icon(Icons.school),
            title: Text("Students"),
            onTap: () {
              // Navigate to Students screen
            },
          ),
          PopupMenuDivider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Faculty"),
            onTap: () {
              // Navigate to Faculty screen
            },
          ),
          PopupMenuDivider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              // Navigate to Profile screen
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: CustomAppBar(
          pageTitle: 'Home Page',
        ),
        body: Row(
          children: [
            SizedBox(
              width: 60,
            ),
            NavigationMenu(),
            SizedBox(
              width: 240,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        color: Colors.red,
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        color: Colors.blue,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        color: Colors.green,
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        color: Colors.yellow,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
