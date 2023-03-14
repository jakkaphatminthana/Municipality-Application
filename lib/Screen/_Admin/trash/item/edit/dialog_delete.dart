import 'package:flutter/material.dart';
import 'package:recycle_app/Screen/_Admin/trash/item/trash_item.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/service/database.dart';

DatabaseEZ db = DatabaseEZ.instance;

Dialog_trashTypeItemDelete({
  required BuildContext context,
  required String typeId,
  required String itemId,
  required data_type,
}) {
  //TODO 1: Cancle Button
  Widget cancelButton(BuildContext context) {
    return TextButton(
      child: Text("Cancel", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  //TODO 2: Continute Button
  Widget continueButton(BuildContext context) {
    return TextButton(
      child: Text("Delete", style: Roboto16_B_red),
      onPressed: () {
        ConfrimDelete(
          context: context,
          typeId: typeId,
          itemId: itemId,
        );
      },
    );
  }

  //TODO 3.: Dialog input
  AlertDialog DialogShow = AlertDialog(
    title: Text("ยืนยันการลบข้อมูล", style: Roboto18_B_black),
    actions: [continueButton(context), cancelButton(context)],
    //TODO 3.2: Content Dialog
    content: Text('คุณต้องการลบข้อมูลนี้หรือไม่', style: Roboto16_black),
  );

  //TODO 4: ShowDialog
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => DialogShow,
  );
}

//==================================================================================================================
//TODO : OnClick, Create Database on Firebase <<--------------------------------
ConfrimDelete({
  required BuildContext context,
  required String typeId,
  required String itemId,
}) async {
  //Delete on firebase
  await db.deleteTrashItem(typeId: typeId, itemId: itemId).then((value) {
    print("delete success");
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Admin_trashTypeItemScreen(data: data_type),
    //   ),
    // );
  }).catchError((e) => print("faild delete: $e"));
}
