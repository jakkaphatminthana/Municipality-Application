import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:recycle_app/Screen/_Member/home.dart';
import 'package:recycle_app/Screen/login/login.dart';
import 'package:recycle_app/components/fonts.dart';

import '../../../components/appbar/appbar.dart';

class Member_profileScreen extends StatelessWidget {
  const Member_profileScreen({super.key, required this.cardId});
  final cardId;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    //=======================================================================================================
    return Scaffold(
      appBar: AppBar(
        title: Text("โปรไฟล์ของฉัน", style: Roboto16_B_white),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  //TODO : QrCode
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                    ),
                    child: QrImage(data: cardId),
                  ),
                  const SizedBox(height: 10.0),

                  //TODO : CardID
                  Text(
                    cardId.replaceAllMapped(
                        RegExp(r'(\d{1})(\d{4})(\d{5})(\d+)'),
                        (Match m) => "${m[1]}-${m[2]}-${m[3]}-${m[4]}"),
                    style: Roboto18_B_black,
                  ),
                  const SizedBox(height: 5.0),

                  //TODO : Name
                  Text('นายปรมิณ์ จันทร์อังคาร', style: Roboto20_B_black),
                  const SizedBox(height: 30.0),

                  //TODO : Button Logout
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFff5963),
                      fixedSize: const Size(180, 45),
                      elevation: 2.0, //เงา
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      "ออกจากระบบ",
                      style: Roboto20_B_white,
                    ),
                    //เมื่อกดปุ่มนี้แล้วทำอะไรต่อ
                    onPressed: () {
                      FirebaseAuth.instance
                          .signOut()
                          .then(
                            (value) => Navigator.popAndPushNamed(
                              context,
                              LoginScreen.routeName,
                            ),
                          )
                          .catchError((err) => print("SignOut Faild : $err"));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
