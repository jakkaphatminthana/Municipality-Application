import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/trash_type.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/service/database.dart';

DatabaseEZ db = DatabaseEZ.instance;

Dialog_trashTypeDelete({
  required BuildContext context,
  required String typeId,
  required image,
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
      onPressed: ConfrimDelete(
        context: context,
        typeId: typeId,
        image: image,
      ),
    );
  }

  //TODO 3.: Dialog input
  AlertDialog DialogInput = AlertDialog(
    title: Text("ยืนยันการลบข้อมูล", style: Roboto18_B_black),
    actions: [continueButton(context), cancelButton(context)],
    //TODO 3.2: Content Dialog
    content: Text('คุณต้องการลบข้อมูลนี้หรือไม่', style: Roboto16_black),
  );

  //TODO 4: ShowDialog
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => DialogInput,
  );
}

//==================================================================================================================
//TODO : OnClick, Create Database on Firebase <<--------------------------------
GestureTapCallback ConfrimDelete({
  required BuildContext context,
  required typeId,
  required image,
}) {
  return () => Delete_TrashType(uid: typeId, img_url: image, context: context);
}

Delete_TrashType({
  required uid,
  required img_url,
  required BuildContext context,
}) async {
  Reference photoRef = await FirebaseStorage.instance.refFromURL(img_url);

  print("uid = $uid");
  print("img_url = $img_url");
  print("photo = $photoRef");

  //Delete on Storange
  await photoRef.delete().then((value) {
    print("delete img success");

    //Delete on firebase
    db.deleteTrashType(typeId: uid).then((value) {
      print('delete type');
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, Admin_trashTypeScreen.routeName);
    }).catchError((err) => print('delete type error: $err'));
  }).catchError((e) => print("delete error: $e"));
}
