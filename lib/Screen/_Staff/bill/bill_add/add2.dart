import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/components/textfield_style.dart';

class Staff_BillAddStep2 extends StatefulWidget {
  Staff_BillAddStep2({
    super.key,
    required this.type,
    required this.trash,
    required this.weight,
  });

  TextEditingController type = TextEditingController();
  TextEditingController trash = TextEditingController();
  TextEditingController weight = TextEditingController();

  @override
  State<Staff_BillAddStep2> createState() => _Staff_BillAddStep2State();
}

class _Staff_BillAddStep2State extends State<Staff_BillAddStep2> {
  var typeImage;
  var typeName;

  //TODO 1: GET TrashType Data
  Future<DocumentSnapshot> getTypeWithId(typeId) async {
    return await FirebaseFirestore.instance
        .collection('trash')
        .doc(typeId)
        .get();
  }

  //TODO 2: GET TrashItem Data
  Future<QuerySnapshot> getTrashWithTypeId(typeId) async {
    return await FirebaseFirestore.instance
        .collection('trash')
        .doc(typeId)
        .collection('item')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    //กำหนดสีของรูปภาพ
    ColorFilter colorFilter =
        const ColorFilter.mode(Colors.green, BlendMode.srcATop);
    //=========================================================================================================
    //TODO 1: ดึงข้อมูล Type Trash
    return FutureBuilder<DocumentSnapshot>(
      future: getTypeWithId(widget.type.text),
      builder: (context, snapshot) {
        //TODO 2: Content <<--------------------------------------------
        if (snapshot.hasData) {
          final typeId = snapshot.data?.id;
          final typeImage = snapshot.data?.get('image');
          final typeName = snapshot.data?.get('name');

          return Column(
            children: [
              //TODO 2.1: เส้นขอบ
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF00883C),
                    width: 4,
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    //TODO 2.2: รูปภาพเปลี่ยนสีได้
                    child: ColorFiltered(
                      colorFilter: colorFilter,
                      child: Image.network(
                        typeImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              const SizedBox(height: 8.0),
              Text(typeName, style: Roboto16_B_greenB),
              const SizedBox(height: 25.0),

              //TODO 3: Form Input <<---------------------------------------------------
              FutureBuilder<QuerySnapshot>(
                future: getTrashWithTypeId(typeId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //TODO 3.1: ข้อมูลของขยะ
                    List<DropdownMenuItem<String>> trashItems = [];
                    String? _selectedValue;

                    for (var document in snapshot.data?.docs ?? []) {
                      final id = document.id;
                      final name = document.get('name');
                      final subtitle = document.get('subtitle');

                      //TODO 3.2: เตรียมข้อมูล dropdown
                      trashItems.add(
                        DropdownMenuItem(
                          value: id,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(name, style: Roboto14_B_black),
                              Text(subtitle, style: Roboto14_black),
                            ],
                          ),
                        ),
                      );
                    }

                    //TODO 3.2: Dropdown data
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("เลือกชนิดขยะ", style: Roboto16_B_black),
                        const SizedBox(height: 5.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: //ลบเส้นออกใต้ออก
                              DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              //ทำให้แสดงข้อมูลที่ตั้งไว้
                              hint: const Text("โปรดเลือก"),
                              style: Roboto14_black,
                              value: (widget.trash.text == '')
                                  ? null
                                  : widget.trash.text,
                              isExpanded: true, //ทำให้กว้าง
                              items: trashItems,
                              onChanged: (value) {
                                setState(() {
                                  widget.trash.text = value!;
                                  print('value = $value');
                                  print('trash = ${widget.trash.text}');
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        //TODO 3.3: Textfield Input
                        Text('น้ำหนัก (กิโลกรัม)', style: Roboto16_B_black),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: widget.weight,
                          obscureText: false,
                          style: Roboto14_black,
                          keyboardType: TextInputType.number,
                          decoration: styleTextField('', 'น้ำหนักรวมของขยะ'),
                        ),
                        const SizedBox(height: 15.0),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return const SpinKitCircle(
            color: Colors.green,
            size: 50,
          );
        }
      },
    );
  }
}
