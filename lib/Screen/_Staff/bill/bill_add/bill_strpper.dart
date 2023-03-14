import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_add/add1.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_add/add2.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_add/add3.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_body.dart';
import 'package:recycle_app/components/fonts.dart';
import 'package:recycle_app/models/bill-trash.dart';

class Staff_BillAdd extends StatefulWidget {
  Staff_BillAdd({super.key, required this.listsData});
  var listsData;

  @override
  State<Staff_BillAdd> createState() => _Staff_BillAddState();
}

class _Staff_BillAddState extends State<Staff_BillAdd> {
  int _currentStep = 0;
  TextEditingController type = TextEditingController();
  TextEditingController trash = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController totalPrice = TextEditingController();
  List<Bill_ListTrash> billListTrash = [];

  void _nextStep() {
    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      }
    });
  }

  void _prevStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //========================================================================================================
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('เพิ่มรายการขยะ'),
        ),
        body: SafeArea(
          //TODO : กำหนดสีของ Stepper
          child: Theme(
            data: ThemeData(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: const Color(0xFF00883C),
                  ),
            ),
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: _nextStep,
              onStepCancel: _prevStep,
              type: StepperType.horizontal,
              steps: [
                //TODO 1: Step 1 ---------------------------------------------------------<<<
                Step(
                  isActive: _currentStep >= 0,
                  state: (_currentStep >= 0)
                      ? StepState.complete
                      : StepState.indexed,
                  title: const Text('ประเภทขยะ'),
                  content: Staff_BillAddStep1(type: type, nextStep: _nextStep),
                ),

                //TODO 2: Step 2 ---------------------------------------------------------<<<
                Step(
                  isActive: _currentStep >= 1,
                  state: (_currentStep >= 1)
                      ? StepState.complete
                      : StepState.indexed,
                  title: const Text('รายละเอียด'),
                  content: Staff_BillAddStep2(
                    type: type,
                    trash: trash,
                    weight: weight,
                  ),
                ),

                //TODO 3: Step 3 ---------------------------------------------------------<<<
                Step(
                  isActive: _currentStep >= 2,
                  state: (_currentStep >= 2)
                      ? StepState.complete
                      : StepState.indexed,
                  title: const Text('ยืนยัน'),
                  content: Staff_BillAddStep3(
                    type: type,
                    trash: trash,
                    weight: weight,
                    price: price,
                    totalPrice: totalPrice,
                  ),
                ),
              ],
              controlsBuilder: buildControls,
            ),
          ),
        ),
      ),
    );
  }

  //========================================================================================================
  //TODO : Widget Controll Button Next
  Widget buildControls(BuildContext context, ControlsDetails controlsDetails) {
    if (_currentStep >= 1) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //TODO 1: NEXT
          ElevatedButton(
            onPressed: () {
              //TODO : Add Data to List <<--------------------------------------
              //Step 3
              if (_currentStep == 2) {
                double weightDB = double.parse(weight.text);
                double priceDB = double.parse(price.text);

                print('type = ${type.text}');
                print('trash = ${trash.text}');
                print('weight = ${weightDB}');
                print('price = ${price.text}');
                print('totalPrice = ${totalPrice.text}');

                setState(() {
                  billListTrash.add(Bill_ListTrash(
                    typeId: type.text,
                    trashId: trash.text,
                    weight: weightDB,
                    price: priceDB,
                  ));
                  (widget.listsData == null)
                      ? widget.listsData = billListTrash
                      : widget.listsData += billListTrash;
                });
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Staff_Bill(
                      listsData: widget.listsData,
                    ),
                  ),
                );
              } else {
                if (trash.text.trim().isEmpty || weight.text.trim().isEmpty) {
                  Fluttertoast.showToast(
                    msg: "กรุณาป้อนข้อมูลให้ครบถ้วน",
                    gravity: ToastGravity.BOTTOM,
                  );
                } else {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _nextStep();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(125, 35),
            ),
            child: Text("Continue", style: Roboto16_B_white),
          ),
          //TODO 2: CANCLE
          TextButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              //TODO 2: ป้องกัน dropdown ข้ามประเภทขยะ
              if (_currentStep == 1) {
                trash.text = '';
                weight.text = '';
                print('trash = ${trash.text}');
                print('weight = ${weight.text}');
                _prevStep();
              } else {
                _prevStep();
              }
            },
            style: TextButton.styleFrom(
              fixedSize: const Size(100, 35),
            ),
            child: Text("Cancle", style: Roboto16_B_gray),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
