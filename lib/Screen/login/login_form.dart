import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_app/Screen/welcome.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/components/textfield_style_Icon.dart';
import 'package:recycle_app/components/varidator.dart';
import 'package:recycle_app/service/auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //AuthService = ตัวเรียกฟังก์ชันที่เกี่ยวกับ user
  //isLoading = ใช้ในตอนกดปุ่มแล้วรอโหลด
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool isLoading = false;

  TextEditingController username = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  void dispose() {
    username.dispose();
    pass.dispose();
    super.dispose();
  }

//==================================================================================================================
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
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

              //TODO 3. Button Login
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
                // Loading ?
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("LOGIN", style: Roboto20_B_white),

                //TODO 3.2 เมื่อกดปุ่มให้ทำการส่งข้อมูล TextField
                onPressed: () async {
                  //เมื่อกรอกข้อมูลถูกต้อง
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save(); //สั่งประมวลผลข้อมูลที่กรอก

                    if (isLoading) return;
                    setState(() => isLoading = true); //Loading

                    await _auth.LoginEmail(username.text, pass.text)
                        .then((value) {
                      //Check error register
                      if (value != "not_work") {
                        _formKey.currentState?.reset();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WelcomeScreen(username: username.text),
                          ),
                        );
                      } else {
                        setState(() => isLoading = false);
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}

//========================================================================================================================
//TODO : Form Email
TextFormField buildUsernameFormField(input) {
  return TextFormField(
    keyboardType: TextInputType.text,
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
