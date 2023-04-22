import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  String pageTitle;

  CustomAppBar({Key? key, required this.pageTitle}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.pageTitle),
      leading: Container(
        padding: EdgeInsets.all(10.0),
        child: SvgPicture.asset('assets/IITH_Logo.svg'),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            // Perform search action
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.person),
          onSelected: (value) {
            // Perform action based on the selected menu item
            if (value == "profile") {
              // Navigate to profile screen
            } else if (value == "logout") {
              // Perform logout action
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Profile',
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'Logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ];
          },
        )
      ],
    );
  }
}
