import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recycle_app/Screen/_Admin/AddUser/form_addUser.dart';

class Admin_AddUser extends StatefulWidget {
  const Admin_AddUser({super.key});
  //Location Page
  static String routeName = "/add_user";

  @override
  State<Admin_AddUser> createState() => _Admin_AddUserState();
}

class _Admin_AddUserState extends State<Admin_AddUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Admin_AddUserForm(),
            ],
          ),
        ),
      ),
    );
  }
}
