import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_app/Screen/_Admin/AddUser/AddUser.dart';
import 'package:recycle_app/Screen/_Admin/AddUser/form_addUser.dart';
import 'package:recycle_app/Screen/_Admin/home/listMenu.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/trash_type.dart';
import 'package:recycle_app/Screen/login/login.dart';
import 'package:recycle_app/components/fonts.dart';

class Admin_HomeScreen extends StatefulWidget {
  const Admin_HomeScreen({super.key});
  //Location Page
  static String routeName = "/dashboard";

  @override
  State<Admin_HomeScreen> createState() => _Admin_HomeScreenState();
}

class _Admin_HomeScreenState extends State<Admin_HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ไม่สามารถกดกลับได้")),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Admin Dashboard'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                //TODO 1: Logout
                Text('Welcome Admin', style: Roboto14_B_black),
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
                  header: "Create Account",
                  subtitle: "สร้างบัญชีผู้ใช้",
                  iconEZ:
                      const FaIcon(FontAwesomeIcons.solidUserCircle, size: 28),
                  colorEZ: const Color(0xFFF9DF8C),
                  press: () {
                    Navigator.pushNamed(context, Admin_AddUser.routeName);
                  },
                ),
                const SizedBox(height: 10.0),

                //TODO 3: Trash
                ListMenu(
                  header: "Garbage",
                  subtitle: "จัดการข้อมูลขยะ",
                  iconEZ: const FaIcon(FontAwesomeIcons.recycle, size: 28),
                  colorEZ: const Color(0xFF10A19D),
                  press: () {
                    Navigator.pushNamed(context, Admin_trashTypeScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
