import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/components/textfield_style.dart';
import 'package:recycle_app/service/database.dart';

//formkey = ตัวแสดงตัวแบบยูนืคของฟอร์มนี้
//db = ติดต่อ firebase
final _formKey = GlobalKey<FormState>();
DatabaseEZ db = DatabaseEZ.instance;
bool loading = false;

Dialog_billEdit({
  required BuildContext context,
  required listData,
  required index,
  required typeId,
  required trashId,
  required weight,
  required price,
}) {
  //new value
  TextEditingController TC_trash = TextEditingController();
  TextEditingController TC_weight = TextEditingController();
  TextEditingController TC_price = TextEditingController();
  var value_trashId;
  var value_weight;

  // กำหนดค่าเริ่มต้นของ textfield ให้แสดงเป็นไปตามข้อมูล firebase
  TC_trash = (value_trashId == null)
      ? TextEditingController(text: trashId) //ค่าเริ่มต้นตาม firebase
      : TextEditingController(text: value_trashId); //ค่าที่กำลังป้อน

  TC_weight = (value_weight == null)
      ? TextEditingController(text: '$weight') //ค่าเริ่มต้นตาม firebase
      : TextEditingController(text: value_weight); //ค่าที่กำลังป้อน

  TC_price = TextEditingController(text: '$price'); //ค่าเริ่มต้นตาม firebase

  //TODO 1: GET TrashItem Data
  Future<QuerySnapshot> getTrashWithTypeId(typeId) async {
    return await FirebaseFirestore.instance
        .collection('trash')
        .doc(typeId)
        .collection('item')
        .get();
  }
  

  //======================================================================================================================
  //TODO 1: Continute Button
  Widget continueButton(BuildContext context, setState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: TextButton(
        onPressed: () {
          ConfrimButton(
            context: context,
            formKey: _formKey,
            setState: setState,
            typeId: typeId,
            TC_trashId: TC_trash,
            TC_weight: TC_weight,
            TC_price: TC_price,
          );
        },
        child: (loading == false)
            ? Text("บันทึกการแก้ไข", style: Roboto16_B_greenB)
            : const CircularProgressIndicator(),
      ),
    );
  }

  //TODO 2: ShowDialog
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
                      //TODO 2.1: title
                      Text('แก้ไขข้อมูล', style: Roboto18_B_black),
                      const SizedBox(height: 15.0),

                      //TODO 3: Firebase GetData <<------------------------------
                      FutureBuilder<QuerySnapshot>(
                        future: getTrashWithTypeId(typeId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {

                            //TODO 3.1: ข้อมูลของขยะ
                            List<DropdownMenuItem<String>> trashItems = [];
                            String? _selectedValue;

                            for (var document in snapshot.data?.docs ?? []) {
                              final id = document.id;
                              final name = document.get('name');
                              final subtitle = document.get('subtitle');

                              //TODO 3.2: เตรียมข้อมูล dropdown
                              trashItems.add(
                                DropdownMenuItem(
                                  value: id,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child:
                                            Text(name, style: Roboto14_B_black),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: (subtitle == '---')
                                            ? Container()
                                            : Text(subtitle,
                                                style: Roboto14_black),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }


                            //TODO 3.3: Dropdown data
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("เลือกชนิดขยะ", style: Roboto14_B_brown),
                                const SizedBox(height: 5.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: //ลบเส้นออกใต้ออก
                                      DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      //ทำให้แสดงข้อมูลที่ตั้งไว้
                                      hint: const Text("โปรดเลือก"),
                                      style: Roboto14_black,
                                      value: (TC_trash.text == '')
                                          ? null
                                          : TC_trash.text,
                                      isExpanded: true, //ทำให้กว้าง
                                      items: trashItems,
                                      onChanged: (value) {
                                        setState(() {
                                          TC_trash.text = value!;
                                          print('value = $value');
                                          print('trash = ${TC_trash.text}');
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),

                                //TODO 3.4: Weigth input
                                Text(
                                  'น้ำหนัก (กิโลกรัม)',
                                  style: Roboto14_B_brown,
                                ),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  controller: TC_weight,
                                  obscureText: false,
                                  style: Roboto14_black,
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      styleTextField('', 'น้ำหนักรวมของขยะ'),
                                ),
                                const SizedBox(height: 15.0),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return const SpinKitCircle(
                              color: Colors.green,
                              size: 50,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              continueButton(context, setState),
            ],
          ),
        );
      });
    },
  );
}

//==========================================================================================================================
//TODO : OnClick, Create Database on Firebase <<--------------------------------
ConfrimButton({
  required BuildContext context,
  required formKey,
  required setState,
  required typeId,
  required TC_trashId,
  required TC_weight,
  required TC_price,
}) async {
  if (formKey.currentState!.validate()) {
    //สั่งประมวลผลข้อมูลที่กรอก
    formKey.currentState?.save();

    print('typeId: $typeId');
    print('TC_trashId: ${TC_trashId.text}');
    print('TC_weight: ${TC_weight.text}');
    print('price = ${TC_price.text}');
    setState(() {
      loading = false;
    });
  } else {
    setState(() {
      loading = false;
    });
  }
}
