import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/components/textfield_style.dart';
import 'package:recycle_app/service/database.dart';

class Staff_BillAddStep1 extends StatefulWidget {
  Staff_BillAddStep1({super.key, required this.type, required this.nextStep});

  TextEditingController type = TextEditingController();
  final Function nextStep;

  @override
  State<Staff_BillAddStep1> createState() => _Staff_BillAddStep1State();
}

class _Staff_BillAddStep1State extends State<Staff_BillAddStep1> {
  //db = เรียก firebase database
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  DatabaseEZ db = DatabaseEZ.instance;
  final formKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> trash_data = FirebaseFirestore.instance
        .collection("trash")
        .orderBy('time_create', descending: true)
        .snapshots();
    //========================================================================================================
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TODO 1: Title Text
        Text('เลือกประเภทขยะ', style: Roboto16_B_black),
        const SizedBox(height: 10.0),

        //TODO 2: Stream FirebaseStore
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: StreamBuilder<QuerySnapshot>(
              stream: trash_data,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SpinKitCircle(
                    color: Colors.green,
                    size: 50,
                  );
                } else {
                  //TODO 3: GridView
                  return GridView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    children: [
                      //TODO : Fetch data here (Product normal) ------------------------------
                      ...snapshot.data!.docs
                          .map((QueryDocumentSnapshot<Object?> data) {
                        //ได้ตัว Data มาละ ----------<<<
                        final String typeId = data.id;
                        final String image = data.get("image");
                        final String name = data.get("name");
                        final bool status = data.get("status");

                        return build_CardTrash(
                          typeId: typeId,
                          image: image,
                          name: name,
                          callback: widget.nextStep,
                        );
                      }),
                    ],
                  );
                }
              }),
        ),
      ],
    );
  }

  //===========================================================================================================
  //TODO : Widget Card Trash
  Widget build_CardTrash({
    required image,
    required name,
    required typeId,
    required callback,
  }) {
    return GestureDetector(
      onTap: () {
        widget.type.text = typeId;
        callback();
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFA7A7A7),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(image, width: 65, height: 65, fit: BoxFit.cover),
              const SizedBox(height: .0),
              Text(name, style: Roboto14_B_black),
            ],
          ),
        ),
      ),
    );
  }
}
