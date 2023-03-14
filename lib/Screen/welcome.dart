import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_app/Screen/_Admin/home/home.dart';
import 'package:recycle_app/Screen/_Member/home.dart';
import 'package:recycle_app/Screen/_Staff/home/home.dart';
import 'package:recycle_app/Screen/login/login.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/service/auth.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.username});
  final username;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  var user_role;
  Timer? _timer;

  //TODO 1. Get User Role
  Future<void> getUserRole() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      user_role = event.data()!['role'];
    });
  }

  //TODO : First call whenever run
  @override
  void initState() {
    super.initState();
    getUserRole();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (user_role != null) {
        _timer!.cancel();
        if (user_role == 'Admin') {
          Navigator.pushReplacementNamed(context, Admin_HomeScreen.routeName);
        } else if (user_role == 'Member') {
          Navigator.pushReplacementNamed(context, MemberHomeScreen.routeName);
        } else if (user_role == 'Staff') {
          Navigator.pushReplacementNamed(context, Staff_HomeScreen.routeName);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //===========================================================================================================
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitRing(
              color: Colors.green,
              size: 80.0,
            ),
            const SizedBox(height: 10.0),
            Text('โปรดรอสักครู่...', style: Roboto14_B_black),
          ],
        ),
      ),
    );
  }
}
