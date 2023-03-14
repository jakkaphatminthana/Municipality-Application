import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_edit/dialog_option.dart';
import 'package:recycle_app/components/fonts.dart';

class ListTile_BillAdd extends StatelessWidget {
  const ListTile_BillAdd({
    super.key,
    required this.index,
    required this.listData,
    required this.typeId,
    required this.trashId,
    required this.weight,
    required this.price,
  });
  final index;
  final listData;
  final typeId;
  final trashId;
  final weight;
  final price;

  @override
  Widget build(BuildContext context) {
    //กำหนดสีของรูปภาพ
    ColorFilter colorFilter =
        const ColorFilter.mode(Colors.green, BlendMode.srcATop);

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

    //========================================================================================================
    return GestureDetector(
      onTap: () => Dialog_billOption(
        context: context,
        index: index,
        listData: listData,
        typeId: typeId,
        trashId: trashId,
        weight: weight,
        price: price,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: //TODO 1: ดึงข้อมูล Type Trash <<--------------------------------------------
            FutureBuilder<DocumentSnapshot>(
                future: getTypeWithId(typeId),
                builder: (context, snapshot) {
                  //TODO 1.2: Content
                  if (snapshot.hasData) {
                    final typeId = snapshot.data?.id;
                    final typeImage = snapshot.data?.get('image');
                    final typeName = snapshot.data?.get('name');

                    return //TODO 2: ดึงข้อมูล Trash Item <<--------------------------------------------
                        FutureBuilder<DocumentSnapshot>(
                      future: getTrashWithTypeId(typeId, trashId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final trashId = snapshot.data?.id;
                          final trashName = snapshot.data?.get('name');
                          final trashSubtitle = snapshot.data?.get('subtitle');
                          final trashPrice = snapshot.data?.get('point');

                          double total = weight * trashPrice;
                          double roundedTotal =
                              double.parse(total.toStringAsFixed(2));

                          //TODO 3: Content Card
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 85,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDEDED),
                              border: Border.all(
                                color: const Color(0xFFCECECE),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Row(
                                children: [
                                  //TODO 3.1: Image
                                  Image.network(
                                    typeImage,
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 10.0),

                                  //TODO 3.2: Text title
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(trashName,
                                            style: Roboto16_B_black),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          "น้ำหนัก: $weight กิโลกรัม",
                                          style: Roboto14_black,
                                        ),
                                      ],
                                    ),
                                  ),

                                  //TODO 3.3: Point
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('$roundedTotal',
                                            style: Roboto18_B_green)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error Trash: ${snapshot.error}");
                        } else {
                          return const SpinKitCircle(
                            color: Colors.green,
                            size: 50,
                          );
                        }
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error Type: ${snapshot.error}");
                  } else {
                    return const SpinKitCircle(
                      color: Colors.green,
                      size: 50,
                    );
                  }
                }),
      ),
    );
  }
}
