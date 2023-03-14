import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/components/varidator.dart';
import 'package:recycle_app/service/auth.dart';

import '../../../components/textfield_style_Icon.dart';

class Admin_AddUserForm extends StatefulWidget {
  const Admin_AddUserForm({super.key});

  @override
  State<Admin_AddUserForm> createState() => _Admin_AddUserFormState();
}

class _Admin_AddUserFormState extends State<Admin_AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  AuthService auth = AuthService();
  TextEditingController username = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //=============================================================================================================
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //TODO 1. Form Email
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: buildUsernameFormField(username),
          ),

          //TODO 2. Form Password
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: buildPasswordFormField(pass),
          ),
          const SizedBox(height: 30),

          //TODO 3.1 Button Add
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              fixedSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
              side: const BorderSide(width: 2.0, color: Colors.white), //ขอบ
              elevation: 2.0, //เงา
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text("Add User", style: Roboto20_B_white),

            //TODO 3.2 เมื่อกดปุ่มให้ทำการส่งข้อมูล TextField
            onPressed: () async {
              //เมื่อกรอกข้อมูลถูกต้อง
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save(); //สั่งประมวลผลข้อมูลที่กรอก

                //TODO : Add User Firebase <-----------------------------------------
                auth
                    .signUpWithEmailPasswordAdminPastor(
                      username.text,
                      pass.text,
                    )
                    .then((value) => print("form ok"))
                    .catchError((e) => print(e));
              }
            },
          ),
        ],
      ),
    );
  }

  //========================================================================================================================
//TODO : Form Email
  TextFormField buildUsernameFormField(input) {
    return TextFormField(
      keyboardType: TextInputType.number,
      obscureText: false, //ปิดตา
      decoration: styleTextField_icon("เลขบัตรสมาชิก", FontAwesomeIcons.idCard),
      maxLength: 13,
      validator: ValidatorUsername,
      onSaved: (value) {
        input.text = value!;
      },
    );
  }

//TODO : Password Form
  TextFormField buildPasswordFormField(input) {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: styleTextField_icon("รหัสผ่าน", Icons.lock),
      validator: ValidatorPassword,
      onSaved: (value) {
        input.text = value!;
      },
    );
  }
}
