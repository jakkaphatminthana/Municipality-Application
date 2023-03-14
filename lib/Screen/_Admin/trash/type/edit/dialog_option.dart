import 'package:flutter/material.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/edit/dialog_delete.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/edit/dialog_edit.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/trash_type.dart';
import 'package:recycle_app/components/fonts.dart';

Dialog_trashTypeOption({
  required BuildContext context,
  required typeId,
  required image_url,
  required data,
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
                  Dialog_trashTypeEdit(context: context, data: data);
                },
              ),
              const SizedBox(height: 8.0),

              //TODO 2: Delete
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                child: Text("ลบ", style: Roboto16_B_red),
                onPressed: () {
                  Dialog_trashTypeDelete(
                    context: context,
                    typeId: typeId,
                    image: image_url,
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
