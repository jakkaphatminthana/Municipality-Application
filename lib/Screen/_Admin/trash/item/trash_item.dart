import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_app/Screen/_Admin/home/home.dart';
import 'package:recycle_app/Screen/_Admin/trash/item/add/dialog_itemAdd.dart';
import 'package:recycle_app/Screen/_Admin/trash/item/list_item.dart';
import 'package:recycle_app/components/fonts.dart';

class Admin_trashTypeItemScreen extends StatefulWidget {
  const Admin_trashTypeItemScreen({super.key, required this.data});
  final data;

  @override
  State<Admin_trashTypeItemScreen> createState() =>
      _Admin_trashTypeItemScreenState();
}

class _Admin_trashTypeItemScreenState extends State<Admin_trashTypeItemScreen> {
  var data_length;
  Timer? _timer_daley;
  bool daley = false;

  //TODO 1: get length data
  Future<void> getLengthData() async {
    final _collection = FirebaseFirestore.instance
        .collection('trash')
        .doc(widget.data.id)
        .collection('item')
        .get();
    var result = await _collection.then((value) {
      data_length = value.size;
      setState(() {});
    });
  }

  //TODO 0: Always call first run
  @override
  void initState() {
    super.initState();
    getLengthData();
    _timer_daley = Timer(const Duration(milliseconds: 500), () async {
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

  @override
  Widget build(BuildContext context) {
    final typeId = widget.data.id;
    final type = widget.data!.get('name');
    final imageType = widget.data!.get('image');

    //Database collection
    final Stream<QuerySnapshot> _trashFB = FirebaseFirestore.instance
        .collection('trash')
        .doc(typeId)
        .collection('item')
        .orderBy('timestamp', descending: true)
        .snapshots();
    //==========================================================================================================
    return Scaffold(
      appBar: AppBar(
        title: Text("ประเภท: $type", style: Roboto16_B_white),
        actions: [
          //1.Search
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
          ),

          //2.Search
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
                child: (data_length == 0)
                    ? build_notFound()
                    : StreamBuilder<QuerySnapshot>(
                        stream: _trashFB,
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
                                //TODO 1: Header Text
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("ชนิดขยะ", style: Roboto14_B_black),
                                    Text("ราคา/หน่วย", style: Roboto14_B_black),
                                  ],
                                ),
                                const SizedBox(height: 10.0),

                                //TODO : Fetch data here
                                ...snapshot.data!.docs
                                    .map((QueryDocumentSnapshot<Object?> data) {
                                  //ได้ตัว Data มาละ ----------------------------------<<<
                                  final title = data.get('name');
                                  final subtitle = data.get('subtitle');
                                  final point = data.get('point');

                                  //TODO 2: Trash List
                                  return ListTile_trashTypeItem(
                                    itemData: data,
                                    imageType: imageType,
                                    title: title,
                                    subtitle: subtitle,
                                    point: '$point',
                                  );
                                }),
                              ],
                            );
                          }
                        },
                      )),
          ],
        ),
      ),
      //TODO : ปุ่มกดมุมขวาล่าง
      floatingActionButton: buildFloatingButton(context),
    );
  }

  //==========================================================================================================
  //TODO : Add Item
  Widget buildFloatingButton(context) => FloatingActionButton(
        backgroundColor: const Color(0xFF00883C),
        child: const Icon(Icons.add),
        onPressed: () {
          Dialog_trashTypeItemAdd(
            context: context,
            typeId: widget.data.id,
            typeData: widget.data,
          );
        },
      );

  //TODO : Widget Not Found
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
