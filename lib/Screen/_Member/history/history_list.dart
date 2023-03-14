import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycle_app/components/fonts.dart';

class ListTile_History extends StatelessWidget {
  const ListTile_History({
    super.key,
    required this.status,
    required this.title,
    required this.date,
    required this.point,
  });

  final status;
  final title;
  final date;
  final point;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60.0,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F8),
          border: Border.all(
            color: const Color(0x4C000000),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            children: [
              //TODO 1: Icon Circle
              FaIcon(
                FontAwesomeIcons.circle,
                color: (status == "get")
                    ? const Color(0xFF1CAD5A)
                    : const Color(0xFFFF5A65),
                size: 24,
              ),
              const SizedBox(
                width: 10.0,
              ),

              //TODO 2: Container 60%
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                //TODO 2.1: Title Content
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Roboto14_B_black),
                    Text(date, style: Roboto12_black),
                  ],
                ),
              ),

              //TODO 3: Container 20%
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //TODO 3.1: Point
                    Row(
                      children: [
                        //symbol
                        (status == "get")
                            ? Text("+ $point", style: Roboto14_B_green)
                            : Text("- $point", style: Roboto14_B_red),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
