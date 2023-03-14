import 'package:flutter/material.dart';
import 'package:recycle_app/Screen/_Admin/trash/item/edit/item_edit.dart';
import 'package:recycle_app/components/fonts.dart';

class ListTile_trashTypeItem extends StatelessWidget {
  const ListTile_trashTypeItem({
    super.key,
    required this.itemData,
    required this.imageType,
    required this.title,
    required this.subtitle,
    required this.point,
  });

  final itemData;
  final imageType;
  final title;
  final subtitle;
  final point;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Admin_trashTypeItemEdit(
              data_item: itemData,
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          elevation: 2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F8),
              border: Border.all(
                color: const Color(0x66595959),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                children: [
                  //TODO 1: Image Type
                  Image.network(
                    imageType,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10.0),

                  //TODO 2: Content Text 50%
                  Container(
                    width: MediaQuery.of(context).size.width * 0.47,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: Roboto16_B_black),
                        Text(subtitle, style: Roboto14_black)
                      ],
                    ),
                  ),
                  //TODO 3: Line Vertical
                  const VerticalDivider(
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                    color: Color(0x9A000000),
                  ),

                  //TODO 4: Point
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8.0),
                        Text(point, style: Roboto20_B_green),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
