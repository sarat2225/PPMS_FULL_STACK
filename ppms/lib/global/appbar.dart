import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ppms/global/globals.dart';

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
        PopupMenuButton<String>(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          icon: Icon(Icons.person),
          onSelected: (value) {
            // Perform action based on the selected menu item
            if (value == "Reset Password") {
              // Navigate to profile screen
            } else if (value == 'Logout') {
              print('object');
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Reset Password',
                child: Row(
                  children: [
                    Icon(
                      Icons.key_outlined,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 8),
                    Text('Reset Password'),
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
