import 'package:flutter/material.dart';
import 'package:recycle_app/Screen/_Admin/AddUser/addUser.dart';
import 'package:recycle_app/Screen/_Admin/home/home.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/add/dialog_typeAdd.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/trash_type.dart';
import 'package:recycle_app/Screen/_Member/home.dart';
import 'package:recycle_app/Screen/_Member/profile/profile.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_body.dart';
import 'package:recycle_app/Screen/_Staff/home/home.dart';
import 'package:recycle_app/Screen/login/login.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName:(context) => LoginScreen(),
  Admin_HomeScreen.routeName:(context) => Admin_HomeScreen(),
  Admin_AddUser.routeName:(context) => Admin_AddUser(),
  Admin_trashTypeScreen.routeName:(context) => Admin_trashTypeScreen(),

  MemberHomeScreen.routeName:(context) => MemberHomeScreen(),

  Staff_HomeScreen.routeName:(context) => Staff_HomeScreen(),
};
