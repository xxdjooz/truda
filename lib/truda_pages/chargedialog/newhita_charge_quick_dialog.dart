import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_pages/chargedialog/vip_widget/newhita_vip_widget.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_common/truda_language_key.dart';
import '../../truda_entities/truda_charge_quick_entity.dart';
import '../../truda_widget/newhita_click_widget.dart';
import 'newhita_charge_dialog_manager.dart';
import 'newhita_charge_quick_controller.dart';

class NewHitaChargeQuickDialog extends StatefulWidget {
  String createPath;
  int? left_time_inter;
  String? upId;
  Function? closeCallBack;
  bool noMoneyShow;

  NewHitaChargeQuickDialog({
    Key? key,
    required this.createPath,
    required this.upId,
    required this.closeCallBack,
    this.noMoneyShow = false,
  }) : super(key: key);

  @override
  State<NewHitaChargeQuickDialog> createState() =>
      _NewHitaChargeQuickDialogState();
}

class _NewHitaChargeQuickDialogState extends State<NewHitaChargeQuickDialog> {
  @override
  void dispose() {
    super.dispose();
    widget.closeCallBack?.call();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(NewHitaChargeQuickController()
      ..upId = widget.upId
      ..createPath = widget.createPath);
    return GetBuilder<NewHitaChargeQuickController>(initState: (state) {
      // NewHitaLog.debug('NewHitaChargeCutDialog initState state=$state');
      NewHitaChargeDialogManager.isShowingChargeDialog = true;
    }, dispose: (state) {
      // NewHitaLog.debug('NewHitaChargeCutDialog dispose state=$state');
      NewHitaChargeDialogManager.isShowingChargeDialog = false;
    }, builder: (controller) {
      return Center(
        // alignment: AlignmentDirectional.center,
        // constraints: const BoxConstraints.tightFor(width: double.infinity),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.center,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images_sized/newhita_charge_quick_bg.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: -48,
                child: Image.asset(
                  'assets/images_sized/newhita_charge_quick_pic.png',
                  height: 50,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF3E8FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // vip商品
                    // NewHitaVipWidget(),
                    if (widget.noMoneyShow)
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: 10, end: 10, top: 20, bottom: 10),
                        child: Align(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            TrudaLanguageKey.newhita_call_no_diamond.tr,
                            style: TextStyle(
                              color: TrudaColors.textColorTitle,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: 10, end: 10, top: 20, bottom: 10),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            TrudaLanguageKey.newhita_charge_quick_diamond.tr,
                            style: TextStyle(
                              color: TrudaColors.textColorTitle,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    Column(
                      children: [
                        if (controller.normalProducts == null)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 140),
                            child: CircularProgressIndicator(),
                          ),
                        _cutProduct(controller),
                        const SizedBox(
                          height: 5,
                        ),
                        ..._commonProducts(controller),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -40,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    "assets/images/newhita_close_white.png",
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _cutProduct(NewHitaChargeQuickController controller) {
    if (controller.cutCommodite == null) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () => controller.chooseCommdite(controller.cutCommodite!),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                // gradient: const LinearGradient(
                //     begin: AlignmentDirectional.centerStart,
                //     end: AlignmentDirectional.centerEnd,
                //     colors: [
                //       Color(0xFF30152D),
                //       Color(0xFF471226),
                //     ]),
                color: TrudaColors.baseColorItem,
                // border: Border.all(
                //   color: const Color(0xFF722425),
                //   width: 1,
                // ),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              // margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    "assets/images_sized/newhita_diamond_big.png",
                    width: 44,
                    height: 44,
                  ),
                  SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${controller.cutCommodite?.value ?? '--'}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: TrudaColors.white),
                      ),
                      if ((controller.cutCommodite?.bonus ?? 0) > 0)
                      Text.rich(
                        TextSpan(
                          text: "",
                          style: TextStyle(
                              color: TrudaColors.baseColorTheme, fontSize: 12),
                          children: [
                            TextSpan(text: " +"),
                            TextSpan(
                              text: "${controller.cutCommodite?.bonus ?? '--'}",
                            ),
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Image.asset(
                                  "assets/images/newhita_diamond_small.png",
                                  width: 12,
                                  height: 12,
                                )),
                          ],
                        ),
                      )
                    ],
                  )),
                  Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                      minWidth: 62,
                    ),
                    height: 40,
                    padding: EdgeInsetsDirectional.only(start: 9, end: 9),
                    decoration: const BoxDecoration(
                        // color: TrudaColors.baseColorPink,
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              TrudaColors.baseColorGradient1,
                              TrudaColors.baseColorGradient2,
                            ]),
                        borderRadius:
                            BorderRadiusDirectional.all(Radius.circular(20))),
                    child: Text(
                      controller.cutCommodite?.showPrice ?? '',
                      style: const TextStyle(
                          color: TrudaColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              start: -3,
              top: 0,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images_sized/newhita_charge_cut.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  "${TrudaLanguageKey.newhita_base_percent_location.trArgs([
                        controller.cutCommodite?.discount?.toString() ?? '--'
                      ])} ${TrudaLanguageKey.newhita_base_off.tr}",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: TrudaColors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _commonProducts(NewHitaChargeQuickController controller) {
    if (controller.normalProducts == null) {
      return [];
    }
    var list = controller.normalProducts!;
    // 有折扣充值就显示两个普通充值
    if (list.length > 2 && controller.cutCommodite != null) {
      list = list.sublist(0, 2);
    }
    return list.map((e) => _commonProduct(controller, e)).toList();
  }

  Widget _commonProduct(NewHitaChargeQuickController controller,
      TrudaPayQuickCommodite commodite) {
    return NewHitaClickWidget(
      onTap: () => controller.chooseCommdite(commodite),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          //   color: const Color(0xFF722425),
          //   width: 1,
          // ),
          borderRadius: BorderRadius.circular(15),
          // borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              "assets/images_sized/newhita_diamond_big.png",
              fit: BoxFit.fill,
              width: 44,
              height: 44,
            ),
            const SizedBox(
              width: 10,
              height: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${commodite.value ?? '--'}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: TrudaColors.textColorTitle),
                ),
                // Text(
                //   "+${commodite.bonus ?? '--'}",
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 10,
                //       color: Colors.white),
                // ),
                Text.rich(
                  TextSpan(
                    text: "",
                    style: TextStyle(
                        color: TrudaColors.baseColorTheme, fontSize: 12),
                    children: [
                      TextSpan(text: " +"),
                      TextSpan(
                        text: "${commodite.bonus}",
                      ),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Image.asset(
                            "assets/images/newhita_diamond_small.png",
                            width: 12,
                            height: 12,
                          )),
                      // TextSpan(text: " +"),
                      // TextSpan(
                      //   text: "${commodite.exp ?? "--"} EXP",
                      // ),
                      // WidgetSpan(
                      //     alignment: PlaceholderAlignment.middle,
                      //     child: Image.asset(
                      //       width: 14,
                      //       height: 14,
                      //     )),
                    ],
                  ),
                )
              ],
            )),
            Container(
              padding: EdgeInsetsDirectional.only(start: 9, end: 9),
              alignment: Alignment.center,
              constraints: BoxConstraints(
                minWidth: 62,
              ),
              height: 40,
              decoration: BoxDecoration(
                  // color: TrudaColors.baseColorPink,
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        TrudaColors.baseColorGradient1,
                        TrudaColors.baseColorGradient2,
                      ]),
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(20))),
              child: Text(
                commodite.showPrice,
                style: TextStyle(
                    color: TrudaColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
