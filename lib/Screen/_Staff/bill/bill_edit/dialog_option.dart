import 'package:flutter/material.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_body.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_edit/dialog_edit.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/service/database.dart';

DatabaseEZ db = DatabaseEZ.instance;
final _formKey = GlobalKey<FormState>();

Dialog_billOption({
  required BuildContext context,
  required index,
  required listData,
  required typeId,
  required trashId,
  required weight,
  required price,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Center(
            child: Text("ตัวเลือก", style: Roboto16_B_black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                height: 1,
                thickness: 2,
                color: Color(0xFFC3C3C3),
              ),

              //TODO 1: Edit
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                child: Text("แก้ไข", style: Roboto16_B_yellow),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Staff_Bill(listsData: listData),
                    ),
                  );
                  Dialog_billEdit(
                    context: context,
                    listData: listData,
                    index: index,
                    typeId: typeId,
                    trashId: trashId,
                    weight: weight,
                    price: price,
                  );
                },
              ),
              const SizedBox(height: 8.0),

              //TODO 2: Delete
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                child: Text("ลบ", style: Roboto16_B_red),
                onPressed: () {
                  setState(() {
                    listData.removeAt(index);
                  });
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Staff_Bill(listsData: listData),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      });
    },
  );
}
