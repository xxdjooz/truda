import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_language_key.dart';

class NewHitaWidgetDemo extends StatelessWidget {
  const NewHitaWidgetDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff545784),
                  Color(0xff8F97A6),
                ],
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
              ),
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(20),
                topEnd: Radius.circular(20),
              ),
            ),
          ),
          Image.asset('assets/images/newhita_call_report.png'),
          Text(
            TrudaLanguageKey.newhita_message_title.tr,
            style: const TextStyle(
                color: TrudaColors.textColor333,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
