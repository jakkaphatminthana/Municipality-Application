import 'package:flutter/material.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_add/bill_strpper.dart';
import 'package:recycle_app/Screen/_Staff/bill/bill_scanQr.dart';
import 'package:recycle_app/Screen/_Staff/bill/list_bill.dart';
import 'package:recycle_app/components/fonts.dart';

class Staff_Bill extends StatefulWidget {
  Staff_Bill({super.key, this.listsData});
  var listsData;

  @override
  State<Staff_Bill> createState() => _Staff_BillAddState();
}

class _Staff_BillAddState extends State<Staff_Bill> {
  @override
  Widget build(BuildContext context) {
    double pointSum = 0;

    //รวบรวมคะแนนสะสมทั้งหมด
    if (widget.listsData != null) {
      for (int i = 0; i < widget.listsData.length; i++) {
        var point = widget.listsData[i].price * widget.listsData[i].weight;
        double roundedTotal = double.parse(point.toStringAsFixed(2));

        pointSum += roundedTotal;
      }
    }

    //==========================================================================================================
    return Scaffold(
      appBar: AppBar(
        title: const Text('สร้างรายการรับขยะ'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  //TODO 1: Listtile Create
                  build_createList(),

                  //TODO 2: Show Object
                  (widget.listsData == null)
                      ? Container()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: widget.listsData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile_BillAdd(
                                index: index,
                                listData: widget.listsData,
                                typeId: widget.listsData[index].typeId,
                                trashId: widget.listsData[index].trashId,
                                weight: widget.listsData[index].weight,
                                price: widget.listsData[index].price,
                              );
                            },
                          ),
                        ),
                  (widget.listsData == null)
                      ? Container()
                      : Column(
                          children: [
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("รวมทั้งหมด:", style: Roboto16_B_black),
                                Text(
                                    '${double.parse(pointSum.toStringAsFixed(2))}',
                                    style: Roboto20_B_black), //show sum
                              ],
                            ),
                            const SizedBox(height: 5.0),

                            //TODO 3: Button Next
                            MaterialButton(
                              height: 50,
                              minWidth: MediaQuery.of(context).size.width,
                              color: Colors.green,
                              child:
                                  Text("ดำเนินการต่อ", style: Roboto16_B_white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Staff_BillScanQR(
                                        listData: widget.listsData),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  //==========================================================================================================

  //TODO 1: Widget create
  Widget build_createList() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Staff_BillAdd(
              listsData: widget.listsData,
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFA1A1A1),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: Color(0xFF545454),
              size: 35,
            ),
            Text('เพิ่มรายการขยะ', style: Roboto12_B_gray),
          ],
        ),
      ),
    );
  }
}
