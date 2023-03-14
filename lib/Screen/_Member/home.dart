import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:recycle_app/Screen/_Member/history/history_list.dart';
import 'package:recycle_app/Screen/_Member/profile/profile.dart';
import 'package:recycle_app/components/appbar/appbar.dart';
import 'package:recycle_app/components/fonts.dart';
import '../login/login.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({super.key});
  //Location Page
  static String routeName = "/home";

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  //TODO 1: cut email -> Card ID
  cutEmailToCard() {
    final UserMail = user?.email.toString();
    List<String>? splited = UserMail?.split("@");
    final data_map = splited?.asMap();
    final nameEmail = data_map![0];
    return nameEmail;
  }

  @override
  Widget build(BuildContext context) {
    //========================================================================================================
    //TODO 1: ทำให้ไม่สามารถกด back page ได้
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
          title: AppbarTitle(
            press: () {},
          ),
          actions: [
            //ไปหน้า Profile
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Member_profileScreen(
                      cardId: cutEmailToCard(),
                    ),
                  ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.solidUserCircle,
                color: Colors.white,
                size: 35,
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //TODO 2: Card Container
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF309059),
                          Color(0xFF1CAD5A),
                          Color(0xFF39D2C0)
                        ],
                        stops: [0, 1, 1],
                        begin: AlignmentDirectional(0, -1),
                        end: AlignmentDirectional(0, 1),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          //TODO 2.1: Header Text
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("แต้มสะสมของฉัน", style: Roboto16_B_white),
                              Text(
                                  cutEmailToCard().replaceAllMapped(
                                      RegExp(r'(\d{1})(\d{4})(\d{5})(\d+)'),
                                      (Match m) =>
                                          "${m[1]}-${m[2]}-${m[3]}-${m[4]}"),
                                  style: Roboto14_white),
                            ],
                          ),

                          //TODO 2.2: Point
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 50.0, left: 10.0),
                            child: Text("1024.55", style: BaiJam40_B_yellow),
                          ),

                          //TODO 2.3: Name
                          Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Text(
                              "นายธนวัตณ์ พันธร",
                              style: Roboto14_B_white,
                            ),
                          ),

                          //TODO 2.4 Qr code
                          Align(
                            alignment: const AlignmentDirectional(1, -1),
                            child: Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: const BoxDecoration(
                                color: Color(0x34FFFFFF),
                              ),
                              child: QrImage(
                                data: cutEmailToCard(),
                              ),
                            ),
                          ),

                          //TODO 2.5: Date create
                          Align(
                            alignment: const AlignmentDirectional(1, 0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 150),
                              child: Text(
                                'ออกให้เมื่อ: 10-11-22',
                                style: Roboto14_black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //TODO 3: History Head
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ประวัติธุรกรรม", style: Roboto14_B_black),
                      const Icon(
                        Icons.filter_list_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),

                //TODO 4: List History
                ListTile_History(
                  status: "get",
                  title: "ได้รับจากรถขยะ",
                  date: "16 พฤศจิกายน 2565",
                  point: "200",
                ),

                ListTile_History(
                  status: "buy",
                  title: "ใช้แต้มสะสมแลกสินค้า",
                  date: "18 พฤศจิกายน 2565",
                  point: "250.5",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
