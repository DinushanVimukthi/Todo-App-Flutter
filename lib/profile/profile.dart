import 'dart:html';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data/loginData.dart';
import '../login.dart';
import '../user.dart';

Widget profilePage(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  User user = LoginData.getLoggedUser();
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      'userImage',
      (int viewId) => ImageElement()
        ..height = 50
        ..width = 10
        ..src = userProvider.userImage
        ..style.borderRadius = '50%');

  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (!kIsWeb)
        CircleAvatar(
          radius: 100,
          backgroundImage: NetworkImage(userProvider.userImage),
        ),
      if (kIsWeb)
        const SizedBox(
          width: 200,
          height: 200,
          child: HtmlElementView(
            viewType: 'userImage',
          ),
        ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Name: ',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            userProvider.userName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Email: ',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            user.email ?? 'No email',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Motive: ',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            userProvider.userMotive,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                LoginData.logoutUser(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.app_badge_fill,
                        color: Colors.white,
                      ),
                      Text(
                        'Logged out successfully',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ));
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ))
        ],
      ),
    ],
  ));
}
