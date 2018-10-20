import 'package:flutter/material.dart';

Widget getDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(
            'Hello!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
        ListTile(
          title: Text('Record'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Lectures'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
