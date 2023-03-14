import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_body.dart';
import 'package:recycle_app/Screen/_Staff/home/listMenu.dart';
import 'package:recycle_app/Screen/login/login.dart';
import 'package:recycle_app/components/fonts.dart';

class Staff_HomeScreen extends StatefulWidget {
  const Staff_HomeScreen({super.key});
  //Location Page
  static String routeName = "/home_staff";

  @override
  State<Staff_HomeScreen> createState() => _Staff_HomeScreenState();
}

class _Staff_HomeScreenState extends State<Staff_HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              //TODO 1: Logout
              Text('Welcome Staff', style: Roboto14_B_black),
              MaterialButton(
                color: Colors.amber,
                child: const Text('Logout'),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                },
              ),
              const SizedBox(height: 20.0),

              //TODO 2: Add User
              ListMenu(
                header: "สร้างรายการ",
                subtitle: "รายการขยะที่จะรับแลก",
                iconEZ: const FaIcon(Icons.post_add, size: 28),
                colorEZ: Colors.green,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Staff_Bill()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
