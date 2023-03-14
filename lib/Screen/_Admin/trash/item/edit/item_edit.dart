import 'package:flutter/material.dart';
import 'package:recycle_app/Screen/_Admin/trash/item/add/dialog_itemAdd.dart';
import 'package:recycle_app/Screen/_Admin/trash/item/edit/dialog_delete.dart';
import 'package:recycle_app/Screen/_Admin/trash/item/trash_item.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/components/textfield_style.dart';
import 'package:recycle_app/components/varidator.dart';
import 'package:recycle_app/service/database.dart';

class Admin_trashTypeItemEdit extends StatefulWidget {
  const Admin_trashTypeItemEdit({super.key, required this.data_item});
  final data_item;

  @override
  State<Admin_trashTypeItemEdit> createState() =>
      _Admin_trashTypeItemEditState();
}

class _Admin_trashTypeItemEditState extends State<Admin_trashTypeItemEdit> {
  //formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
  //db = ติดต่อ firebase
  final _formKey = GlobalKey<FormState>();
  DatabaseEZ db = DatabaseEZ.instance;

  TextEditingController TC_name = TextEditingController();
  TextEditingController TC_point = TextEditingController();
  TextEditingController TC_subtitle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final trashId = widget.data_item.id;
    final typeId = widget.data_item!.get('typeId');
    final nameFB = widget.data_item!.get('name');
    final pointFB = widget.data_item!.get('point');
    final subtitleFB = widget.data_item!.get("subtitle");

    //กำหนดค่าเริ่มต้นของ textfield ให้แสดงเป็นไปตามข้อมูล firebase
    TC_name = TextEditingController(text: nameFB); //ค่าเริ่มต้นตาม firebase
    TC_point =
        TextEditingController(text: '$pointFB'); //ค่าเริ่มต้นตาม firebase
    TC_subtitle = TextEditingController(
        text:
            (subtitleFB == '---') ? '' : subtitleFB); //ค่าเริ่มต้นตาม firebase

    //=========================================================================================================
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขข้อมูลขยะ", style: Roboto16_B_white),
        actions: [
          //TODO 1.1: Save Icon
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              //TODO : Update on Firebase -------------------------------------------------<<<<
              if (_formKey.currentState!.validate()) {
                //สั่งประมวลผลข้อมูลที่กรอก
                _formKey.currentState?.save();
                var pointDouble = double.parse(TC_point.text);

                // print('TC_name: ${TC_name.text}');
                // print('TC_point: ${TC_point.text}');
                // print('TC_sub: ${TC_subtitle.text}');

                //TODO : UPDATE Database on Firebase
                await db
                    .updateTrashItem(
                  trashId: trashId,
                  typeId: typeId,
                  name: TC_name.text,
                  point: pointDouble,
                  subtitle: TC_subtitle.text,
                )
                    .then((value) {
                  print("update success");
                  Navigator.of(context).pop();
                }).catchError((e) => print("update error: $e"));
              }
            },
          ),

          //TODO 1.2: Delete Icon
          IconButton(
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              //TODO : Delete on Firebase -------------------------------------------------<<<<
              Dialog_trashTypeItemDelete(
                context: context,
                typeId: typeId,
                itemId: trashId,
                data_type: widget.data_item,
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              //TODO 2: TextField
              const SizedBox(height: 15.0),
              buildItemNameTF(TC_name),
              const SizedBox(height: 20.0),
              buildItemPointTF(TC_point),
              const SizedBox(height: 20.0),
              buildItemSubtitleTF(TC_subtitle),
            ],
          ),
        ),
      ),
    );
  }

  //=============================================================================================================
//TODO : TextField Name
  TextFormField buildTypeNameTF(text_controller, new_value) {
    return TextFormField(
      //พิมพ์เฉพาะตัวเลข
      keyboardType: TextInputType.name,
      controller: text_controller,
      maxLength: 25,
      minLines: 1,
      style: Roboto14_black,
      decoration: styleTextField(
        'ชนิดขยะ',
        'ชื่อประเภทขยะ',
      ),
      validator: ValidatorEmpty,
      onSaved: (value) => text_controller.text = value,
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
}
