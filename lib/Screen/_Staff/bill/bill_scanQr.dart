import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/components/textfield_style.dart';

class Staff_BillScanQR extends StatefulWidget {
  Staff_BillScanQR({super.key, required this.listData});
  var listData;

  @override
  State<Staff_BillScanQR> createState() => _Staff_BillScanQRState();
}

class _Staff_BillScanQRState extends State<Staff_BillScanQR> {
  String? mode;
  TextEditingController cardCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //=========================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('สร้างรายการรับขยะ'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TODO 1: Header Title
                    const SizedBox(height: 15.0),
                    Text("ส่งแต้มสะสมนี้", style: Roboto18_B_black),
                    const SizedBox(height: 15.0),

                    //TODO 2: Point
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //title
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.coins,
                              color: Colors.black,
                              size: 24,
                            ),
                            const SizedBox(width: 5.0),
                            Text('จำนวนแต้มสะสม: ', style: Roboto16_B_black),
                          ],
                        ),
                        //point
                        Text('6812.0', style: Roboto20_B_green),
                      ],
                    ),
                    const Divider(thickness: 3, color: Colors.black),
                    const SizedBox(height: 15.0),

                    //TODO 3: head choice
                    Text('เลือกวิธีรับ:', style: Roboto14_B_black),
                    const SizedBox(height: 5.0),

                    //TODO 4: Button Scan
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          mode = "scan";
                        });
                        print(mode);
                      },
                      icon: const Icon(Icons.qr_code, size: 25),
                      label: Text('สแกนคิวอาร์โค้ด', style: Roboto16_B_white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEFB839),
                        fixedSize: Size(MediaQuery.of(context).size.width, 45),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    //TODO 5.1: Button Input
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (mode == "input") {
                            mode = null;
                          } else {
                            mode = "input";
                          }
                        });
                        print(mode);
                      },
                      icon: const Icon(Icons.keyboard_rounded, size: 25),
                      label: Text('กรอกเลขบัตร', style: Roboto16_B_white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6539EF),
                        fixedSize: Size(MediaQuery.of(context).size.width, 45),
                      ),
                    ),

                    //TODO 5.2: Textfield Card
                    (mode != "input")
                        ? Container()
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20.0),
                              TextFormField(
                                controller: cardCode,
                                obscureText: false,
                                maxLength: 13,
                                style: Roboto14_black,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: styleTextField('', 'กรอกเลขบัตร'),
                              ),
                              const SizedBox(height: 5.0),

                              //TODO 5.2.1: Button Search
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.search, size: 25),
                                label: Text('ค้นหา', style: Roboto16_B_white),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6539EF),
                                  fixedSize: const Size(120, 30),
                                ),
                              ),
                            ],
                          ),

                    //----------------------------------------------------------------------------------
                    //TODO : Button Finish
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MaterialButton(
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width,
                          color: Colors.green,
                          child: Text("ยืนยัน", style: Roboto16_B_white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
