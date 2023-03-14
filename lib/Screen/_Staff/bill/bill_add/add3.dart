import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/components/textfield_style.dart';

import '../../../../components/dividerDash.dart';

class Staff_BillAddStep3 extends StatefulWidget {
  Staff_BillAddStep3(
      {super.key,
      required this.type,
      required this.trash,
      required this.weight,
      required this.price,
      required this.totalPrice});

  final TextEditingController type;
  final TextEditingController trash;
  final TextEditingController weight;
  final TextEditingController price;
  final TextEditingController totalPrice;

  @override
  State<Staff_BillAddStep3> createState() => _Staff_BillAddStep3State();
}

class _Staff_BillAddStep3State extends State<Staff_BillAddStep3> {
  //TODO 1: GET TrashType Data
  Future<DocumentSnapshot> getTypeWithId(typeId) async {
    return await FirebaseFirestore.instance
        .collection('trash')
        .doc(typeId)
        .get();
  }

  //TODO 2: GET TrashItem Data
  Future<DocumentSnapshot> getTrashWithTypeId(typeId, trashId) async {
    return await FirebaseFirestore.instance
        .collection('trash')
        .doc(typeId)
        .collection('item')
        .doc(trashId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    //กำหนดสีของรูปภาพ
    ColorFilter colorFilter =
        const ColorFilter.mode(Colors.green, BlendMode.srcATop);
    //====================================================================================================
    //TODO 1: ดึงข้อมูล Type Trash <<--------------------------------------------
    return FutureBuilder<DocumentSnapshot>(
      future: getTypeWithId(widget.type.text),
      builder: (context, snapshot) {
        //TODO 1.2: Content
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
              const SizedBox(height: 5.0),
              Text(typeName, style: Roboto16_B_greenB),
              const SizedBox(height: 25.0),

              //TODO 3: ดึงข้อมูล Trash Item <<--------------------------------------------
              FutureBuilder<DocumentSnapshot>(
                  future: getTrashWithTypeId(typeId, widget.trash.text),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final trashId = snapshot.data?.id;
                      final trashName = snapshot.data?.get('name');
                      final trashSubtitle = snapshot.data?.get('subtitle');
                      final trashPrice = snapshot.data?.get('point');

                      double weightDB = double.parse(widget.weight.text);
                      double total = weightDB * trashPrice;
                      double roundedTotal =
                          double.parse(total.toStringAsFixed(2));
                      widget.price.text = "$trashPrice";
                      widget.totalPrice.text = "$roundedTotal";

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //TODO 3.1: Trash Name
                          Text("ชนิดขยะ", style: Roboto16_B_black),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.double_arrow,
                                  color: Color(0xFF00883C),
                                  size: 20,
                                ),
                                const SizedBox(width: 5.0),
                                Text(trashName, style: Roboto16_green)
                              ],
                            ),
                          ),
                          const SizedBox(height: 15.0),

                          //TODO 3.2: Trash Weight
                          Text("น้ำหนัก (กิโลกรัม)", style: Roboto16_B_black),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.double_arrow,
                                  color: Color(0xFF00883C),
                                  size: 20,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  "${widget.weight.text} กก.",
                                  style: Roboto16_green,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          //TODO 4.1: สรุปราคาขยะ
                          const Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                          build_TextBetween(
                            title: "ราคาต่อหน่วย:",
                            value: "$trashPrice",
                            styleValue: Roboto16_B_black,
                          ),
                          const SizedBox(height: 5.0),
                          build_TextBetween(
                            title: "น้ำหนัก:",
                            value: widget.weight.text,
                            styleValue: Roboto16_B_black,
                          ),
                          const SizedBox(height: 15.0),

                          //TODO 4.2: ผลรวมแต้ม
                          const DottedLine(
                            lineThickness: 2,
                            dashLength: 5,
                            dashColor: Color(0xFFDBDBDB),
                          ),
                          const SizedBox(height: 5.0),
                          build_TextBetween(
                            title: "รวมทั้งหมด",
                            value: "$roundedTotal",
                            styleValue: Roboto20_B_green,
                          ),
                          const SizedBox(height: 5.0),
                          const DottedLine(
                            lineThickness: 2,
                            dashLength: 5,
                            dashColor: Color(0xFFDBDBDB),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error Trash: ${snapshot.error}");
                    } else {
                      return const SpinKitCircle(
                        color: Colors.green,
                        size: 50,
                      );
                    }
                  }),
              const SizedBox(height: 20.0),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("Error Type: ${snapshot.error}");
        } else {
          return const SpinKitCircle(
            color: Colors.green,
            size: 50,
          );
        }
      },
    );
  }

  //===========================================================================================================
  //TODO 1: Widget Text SpaceBetween
  Widget build_TextBetween(
      {required title, required value, required styleValue}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Roboto16_B_black),
        Text(value, style: styleValue),
      ],
    );
  }
}
