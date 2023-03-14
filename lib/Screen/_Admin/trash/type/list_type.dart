import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recycle_app/Screen/_Admin/trash/item/trash_item.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/edit/dialog_option.dart';
import 'package:recycle_app/components/fonts.dart';

class ListTile_trashType extends StatefulWidget {
  const ListTile_trashType({
    super.key,
    required this.typeId,
    required this.image_icon,
    required this.title,
    required this.data,
  });
  final typeId;
  final image_icon;
  final title;
  final data;

  @override
  State<ListTile_trashType> createState() => _ListTile_trashTypeState();
}

class _ListTile_trashTypeState extends State<ListTile_trashType> {
  Timer? _timer;
  bool delay = false;
  int? count = 0;

  //TODO 1: get length data ItemType
  Future<void> getItemOfType({required String typeId}) async {
    final item_col = FirebaseFirestore.instance
        .collection('trash')
        .doc(typeId)
        .collection('item')
        .get();

    var result = await item_col.then((value) {
      count = value.size;
    });
  }

  //TODO 0: First call whenever run
  @override
  void initState() {
    super.initState();
    getItemOfType(typeId: widget.typeId);
  }

  @override
  Widget build(BuildContext context) {
    //===========================================================================================================
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        //TODO : One Click
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Admin_trashTypeItemScreen(
              data: widget.data,
            ),
          ),
        ),

        //TODO : Click Hold
        onLongPress: () => Dialog_trashTypeOption(
          context: context,
          typeId: widget.typeId,
          image_url: widget.image_icon,
          data: widget.data,
        ),
        child: Container(
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
                //TODO 1: Image Icon
                Image.network(
                  widget.image_icon,
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10.0),

                //TODO 2: Content 50%
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO 2.1: Title
                      Text(widget.title, style: Roboto16_B_black),
                      const SizedBox(height: 5.0),
                      //TODO 2.2: Amount list
                      Row(
                        children: [
                          Text("จำนวนชนิดขยะ:", style: Roboto14_black),
                          const SizedBox(width: 5.0),
                          Text("$count", style: Roboto14_B_greenB),
                          const SizedBox(width: 5.0),
                          Text("รายการ", style: Roboto14_black),
                        ],
                      ),
                    ],
                  ),
                ),

                //TODO 3.: Icon Arrow
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: const Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
