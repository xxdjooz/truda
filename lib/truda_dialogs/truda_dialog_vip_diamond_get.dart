import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../truda_common/truda_colors.dart';
import '../truda_common/truda_language_key.dart';
import '../truda_widget/truda_gradient_button.dart';
// 领取钻石
class TrudaDialogVipDiamondGet extends StatefulWidget {
  int diamond;

  TrudaDialogVipDiamondGet({
    Key? key,
    required this.diamond,
  }) : super(key: key);

  @override
  State<TrudaDialogVipDiamondGet> createState() =>
      _TrudaDialogVipDiamondGetState();
}

class _TrudaDialogVipDiamondGetState extends State<TrudaDialogVipDiamondGet>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsetsDirectional.only(top: 30, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Image.asset(
                        'assets/images_sized/newhita_invite_dialog_pic.png',
                        height: 150,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Text(
                        TrudaLanguageKey.newhita_vip_diamond_get
                            .trArgs([widget.diamond.toString()]),
                        style: TextStyle(
                          color: TrudaColors.baseColorYellow,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                PositionedDirectional(
                    end: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: Get.back,
                      child: Container(
                        padding: EdgeInsetsDirectional.only(
                            start: 10, end: 10, top: 10, bottom: 10),
                        child: Image.asset(
                          'assets/images/newhita_close_white.png',
                          width: 26,
                          height: 26,
                        ),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: TrudaGradientButton(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffFFDEB0),
                              Color(0xffFFA733),
                            ],
                            begin: AlignmentDirectional.centerStart,
                            end: AlignmentDirectional.centerEnd,
                          ),
                          border: Border.all(
                            color: TrudaColors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        TrudaLanguageKey.newhita_base_confirm.tr,
                        style: TextStyle(
                            color: const Color(0xFFB4442D), fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
