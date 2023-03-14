import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recycle_app/Screen/_Admin/trash/type/trash_type.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/components/textfield_style.dart';
import 'package:recycle_app/components/textfield_style_Icon.dart';
import 'package:recycle_app/components/varidator.dart';
import 'package:recycle_app/service/database.dart';
import 'package:uuid/uuid.dart';

DatabaseEZ db = DatabaseEZ.instance;
final _formKey = GlobalKey<FormState>();
bool loading = false;

Dialog_trashTypeAdd({required BuildContext context}) {
  TextEditingController TC_typeName = TextEditingController();

  //url รูปที่อัพโหลด
  File? value_image;
  var image_path;
  var image_file;

  //TODO 1: เลือกรูปภาพจาก gallery
  Future pickImage(setState) async {
    try {
      //นำภาพที่เลือกมาเก็บไว้ใน image
      final value_imageEZ =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      //เช็คว่าถ้าไม่ได้เลือกก็ออก
      if (value_imageEZ == null) return;
      // นำ path image ที่เราเลือกไปเก็บไว้ใน image_file เพื่อเอาไปใช้ในส่วนของการบันทึก
      image_path = value_imageEZ.path;
      // เอาภาพที่เลือกไว้มาเก็บไว้ใน image_path เพื่อเอาไปใช้ในส่วนของการบันทึก
      image_file = value_imageEZ;
      //แปลงเป็น File
      final imageTemporary = File(value_imageEZ.path);

      setState(() {
        // เอาไปเก็บไว้ใน image เเล้วอัพเดดน่าเเล้วภาพจะขึ้น
        value_image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //==========================================================================================================
  //TODO 1: Cancle Button
  Widget cancelButton(BuildContext context) {
    return TextButton(
      child: Text("ยกเลิก", style: Roboto16_B_gray),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  //TODO 2: Continute Button
  Widget continueButton(BuildContext context, setState) {
    return TextButton(
        child: (loading == false)
            ? Text("ยืนยัน", style: Roboto16_B_green)
            : const CircularProgressIndicator(),
        onPressed: (loading == true)
            ? null
            : () async {
                setState(() {
                  loading = true;
                });
                await ConfrimButton(
                  context: context,
                  setState: setState,
                  formKey: _formKey,
                  TC_typeName: TC_typeName,
                  image_file: image_file,
                  image_path: image_path,
                );
              });
  }

  //TODO 3: ShowDialog
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: AlertDialog(
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //TODO 3.1: title
                        Text('เพิ่มประเภทขยะ', style: Roboto18_B_black),
                        const SizedBox(height: 15.0),

                        //TODO 3.2: Upload Image
                        GestureDetector(
                          onTap: () => pickImage(setState),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0xFFA5A5A5),
                                width: 2,
                              ),
                            ),
                            child: (value_image != null)
                                ? Image.file(value_image!)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.cloud_upload_outlined,
                                        color: Color(0xFFA5A5A5),
                                        size: 50,
                                      ),
                                      Text("อัปโหลดรูปภาพ",
                                          style: Roboto14_gray),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        buildTypeNameTF(TC_typeName),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                continueButton(context, setState),
                cancelButton(context),
              ],
            ));
      });
    },
  );
}

//=============================================================================================================
//TODO : TextField Phone
TextFormField buildTypeNameTF(contro_type) {
  return TextFormField(
    //พิมพ์เฉพาะตัวเลข
    keyboardType: TextInputType.name,
    controller: contro_type,
    maxLength: 25,
    minLines: 1,
    style: Roboto14_black,
    decoration: styleTextField(
      'TypeName',
      'ชื่อประเภทขยะ',
    ),
    validator: ValidatorEmpty,
    onSaved: (value) => contro_type.text = value,
  );
}

//TODO : อัพโหลด ภาพลงใน Storage ใน firebase
uploadImage({gallery, image, uid}) async {
  // กำหนด _storage ให้เก็บ FirebaseStorage (สโตเลท)
  final _storage = FirebaseStorage.instance;
  // เอา path ที่เราเลือกจากเครื่องมาเเปลงเป็น File เพื่อเอาไปอัพโหลดลงใน Storage ใน Firebase
  var file = File(gallery);
  // เช็คว่ามีภาพที่เลือกไหม
  if (image != null) {
    //Upload to Firebase
    var snapshot = await _storage
        .ref()
        .child("images/trashType/$uid") //แหล่งเก็บภาพนี้
        .putFile(file);
    //เอาลิ้ง url จากภาพที่เราได้อัปโหลดไป เอาออกมากเก็บไว้ใน downloadUrl
    var downloadURL = await snapshot.ref.getDownloadURL();
    //ส่ง URL ของรูปภาพที่อัพโหลดขึ้น stroge แล้วไปใช้ต่อ
    // print("downloadURL = ${downloadURL}");
    return downloadURL;
  } else {
    return Text("ไม่พบรูปภาพ");
  }
}

//TODO : OnClick, Create Database on Firebase <<--------------------------------
ConfrimButton({
  required BuildContext context,
  required formKey,
  required setState,
  required TC_typeName,
  required image_file,
  required image_path,
}) async {
  if (formKey.currentState!.validate()) {
    //สั่งประมวลผลข้อมูลที่กรอก
    formKey.currentState?.save();

    //เช็ครูปภาพ
    if (image_file == null) {
      Fluttertoast.showToast(
        msg: "ไม่ได้อัปโหลดรูปภาพ",
        gravity: ToastGravity.BOTTOM,
      );
      setState(() {
        loading = false;
      });
    } else {
      //generate ID เพื่อใช้สร้าง id unique
      var uid = Uuid();
      String uuid = uid.v1();

      //อัพโหลดรูปภาพลง storage
      var image_url = await uploadImage(
        gallery: image_path,
        image: image_file,
        uid: uuid,
      );

      //TODO : Upload data on Firebase <--------------------------
      await db
          .createTrashType(
        uid: uuid,
        image_url: image_url,
        name: TC_typeName.text,
      )
          .then((value) {
        print('Add type success');
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
            context, Admin_trashTypeScreen.routeName);
      }).catchError((err) => print("Add type error"));
    }
  } else {
    setState(() {
      loading = false;
    });
  }
}
