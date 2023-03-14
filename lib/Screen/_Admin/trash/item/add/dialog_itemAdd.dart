import 'package:flutter/material.dart';
import 'package:recycle_app/Screen/_Admin/trash/item/trash_item.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/components/textfield_style.dart';
import 'package:recycle_app/components/varidator.dart';
import 'package:recycle_app/service/database.dart';

DatabaseEZ db = DatabaseEZ.instance;
final _formKey = GlobalKey<FormState>();
bool loading = false;

Dialog_trashTypeItemAdd({
  required BuildContext context,
  required typeId,
  required typeData,
}) {
  TextEditingController TC_trashName = TextEditingController();
  TextEditingController TC_trashSubtitle = TextEditingController();
  TextEditingController TC_typePoint = TextEditingController();

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
              ConfrimButton(
                context: context,
                formKey: _formKey,
                setState: setState,
                typeData: typeData,
                typeId: typeId,
                TC_name: TC_trashName,
                TC_subtitle: TC_trashSubtitle,
                TC_point: TC_typePoint,
              );
            },
    );
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
            title: Text('เพิ่มชนิดขยะ', style: Roboto18_B_black),
            content: Form(
              key: _formKey,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildItemNameTF(TC_trashName),
                    const SizedBox(height: 20.0),
                    buildItemPointTF(TC_typePoint),
                    const SizedBox(height: 20.0),
                    buildItemSubtitleTF(TC_trashSubtitle),
                  ],
                ),
              ),
            ),
            actions: [
              continueButton(context, setState),
              cancelButton(context),
            ],
          ),
        );
      });
    },
  );
}

//=============================================================================================================
//TODO : TextField Name
TextFormField buildItemNameTF(Text_controller) {
  return TextFormField(
    //พิมพ์เฉพาะตัวเลข
    keyboardType: TextInputType.name,
    controller: Text_controller,
    maxLength: 25,
    minLines: 1,
    style: Roboto14_black,
    decoration: styleTextField(
      'ชนิดขยะ',
      'ชื่อชนิดของขยะ',
    ),
    validator: ValidatorEmpty,
    onSaved: (value) => Text_controller.text = value,
  );
}

//TODO : TextField Subtitle
TextFormField buildItemSubtitleTF(Text_controller) {
  return TextFormField(
    //พิมพ์เฉพาะตัวเลข
    keyboardType: TextInputType.name,
    controller: Text_controller,
    maxLength: 25,
    minLines: 1,
    style: Roboto14_black,
    decoration: styleTextField(
      'เพิ่มเติม',
      'รายละเอียดเพิ่มเติม (ไม่ระบุก็ได้)',
    ),
    onSaved: (value) => Text_controller.text = value,
  );
}

//TODO : TextField Point
TextFormField buildItemPointTF(Text_controller) {
  return TextFormField(
    //พิมพ์เฉพาะตัวเลข
    keyboardType: TextInputType.number,
    controller: Text_controller,
    maxLength: 25,
    minLines: 1,
    style: Roboto14_black,
    decoration: styleTextField(
      'ราคา',
      'ราคา/หน่วย',
    ),
    validator: ValidatorEmpty,
    onSaved: (value) => Text_controller.text = value,
  );
}

//TODO : OnClick, Create Database on Firebase <<--------------------------------
ConfrimButton({
  required BuildContext context,
  required formKey,
  required setState,
  required typeData,
  required typeId,
  required TC_name,
  required TC_subtitle,
  required TC_point,
}) async {
  if (formKey.currentState!.validate()) {
    //สั่งประมวลผลข้อมูลที่กรอก
    formKey.currentState?.save();
    var pointDB = double.parse(TC_point.text);

    print("name: ${TC_name.text}");
    print("sub: ${TC_subtitle.text}");
    print("point: ${TC_point.text}");
    print("typeId: $typeId");

    //TODO : Upload data on Firebase <--------------------------
    await db
        .createTrashItem(
      typeId: typeId,
      name: TC_name.text,
      point: pointDB,
      subtitle: TC_subtitle.text,
    )
        .then((value) {
      print('Add success');
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Admin_trashTypeItemScreen(data: typeData),
        ),
      );
    }).catchError((e) => print("add error: $e"));
  } else {
    setState(() {
      loading = false;
    });
  }
}
