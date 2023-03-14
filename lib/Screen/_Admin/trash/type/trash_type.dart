import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/add/dialog_typeAdd.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/list_type.dart';
import 'package:recycle_app/components/fonts.dart';

class Admin_trashTypeScreen extends StatefulWidget {
  const Admin_trashTypeScreen({super.key});
  //Location Page
  static String routeName = "/garbage_type";

  @override
  State<Admin_trashTypeScreen> createState() => _Admin_trashTypeScreenState();
}

class _Admin_trashTypeScreenState extends State<Admin_trashTypeScreen> {
  var data_length;
  Timer? _timer_daley;
  bool daley = false;
  bool _isRefreshing = false;

  //TODO 1: get length data TypeTrash
  Future<void> getLengthData() async {
    final _collection = FirebaseFirestore.instance.collection('trash').get();
    var result = await _collection.then((value) {
      data_length = value.size;
      setState(() {});
    });
  }

  //TODO 2: Refresh Page
  Future<void> _refreshList() async {
    // Set the refreshing flag to true
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushReplacementNamed(context, Admin_trashTypeScreen.routeName);
  }

  //TODO 0: Always call first run
  @override
  void initState() {
    super.initState();
    getLengthData();
    _timer_daley = Timer(const Duration(milliseconds: 800), () async {
      setState(() {
        daley = true;
        print("len: $data_length");
      });
    });
  }

  @override
  void dispose() {
    _timer_daley?.cancel();
    super.dispose();
  }

  //Database collection
  final Stream<QuerySnapshot> _typeFB = FirebaseFirestore.instance
      .collection('trash')
      .orderBy('time_create', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    //========================================================================================================
    return Scaffold(
      appBar: AppBar(
        title: Text("จัดการข้อมูลขยะ", style: Roboto16_B_white),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: (data_length == 0)
                    ? build_notFound()
                    : StreamBuilder<QuerySnapshot>(
                        stream: _typeFB,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const SpinKitCircle(
                              color: Colors.green,
                              size: 50,
                            );
                          } else {
                            return ListView(
                              children: [
                                //TODO : Fetch data here
                                ...snapshot.data!.docs
                                    .map((QueryDocumentSnapshot<Object?> data) {
                                  //ได้ตัว Data มาละ ----------------------------------<<<
                                  final typeId = data.get('id');
                                  final image = data.get("image");
                                  final name = data.get("name");

                                  return ListTile_trashType(
                                    typeId: typeId,
                                    image_icon: image,
                                    title: name,
                                    data: data,
                                  );
                                }),
                              ],
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      //TODO : ปุ่มกดมุมขวาล่าง
      floatingActionButton: buildFloatingButton(context),
    );
  }

  //==========================================================================================================
  Widget buildFloatingButton(context) => FloatingActionButton(
        backgroundColor: const Color(0xFF00883C),
        child: const Icon(Icons.add),
        onPressed: () {
          Dialog_trashTypeAdd(context: context);
        },
      );

  //TODO Widget Not Found
  Widget build_notFound() {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          const Icon(
            Icons.find_in_page,
            color: Color(0xFFA5A5A5),
            size: 100,
          ),
          const SizedBox(height: 5.0),
          Text("Not Found", style: Roboto20_B_gray),
          Text("ไม่พบข้อมูล หรือยังไม่ได้สร้างข้อมูล", style: Roboto14_gray),
        ],
      ),
    );
  }
}
