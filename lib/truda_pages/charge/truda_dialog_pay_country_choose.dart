import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_common/truda_common_type.dart';
import '../../truda_entities/truda_hot_entity.dart';
import '../../truda_services/newhita_my_info_service.dart';
import '../../truda_widget/newhita_net_image.dart';

class TrudaDialogPayCountryChoose extends StatelessWidget {
  List<TrudaAreaData> areaList;
  TrudaCallback<TrudaAreaData> callback;
  int curArea;

  TrudaDialogPayCountryChoose({
    Key? key,
    required this.areaList,
    required this.curArea,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var levalbean = NewHitaMyInfoService.to.getMyLeval();
    var myLeval = levalbean?.grade ?? 0;
    return Align(
      alignment: AlignmentDirectional.center,
      child: Container(
        // width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 30,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: TrudaColors.baseColorItem,
          // border: Border.all(
          //   color: TrudaColors.baseColorBorder,
          //   width: 1,
          // ),
          borderRadius: BorderRadiusDirectional.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         TrudaLanguageKey.newhita_main_choose_country.tr,
            //         style: TextStyle(color: TrudaColors.white, fontSize: 14),
            //       ),
            //       GestureDetector(
            //         onTap: () => Get.back(),
            //         child: Icon(
            //           Icons.close_rounded,
            //           color: TrudaColors.white,
            //           size: 20,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            Wrap(
              children: areaList
                  .map(
                    (e) => Builder(
                      builder: (context) {
                        var area = e;
                        bool isCur = area.areaCode == curArea;
                        return Opacity(
                          opacity: 1,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              callback.call(area);
                            },
                            child: Container(
                              decoration: isCur
                                  ? BoxDecoration(
                                      color: TrudaColors.baseColorGreen,
                                      // border: Border.all(
                                      //   color: Colors.white54,
                                      //   width: 1,
                                      //   style: BorderStyle.solid,
                                      // ),
                                      borderRadius: BorderRadius.circular(30),
                                    )
                                  : BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 2),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      NewHitaNetImage(
                                        area.path ?? "",
                                        width: 22,
                                        height: 22,
                                        isCircle: true,
                                        borderWidth: 1,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    area.title ?? "",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isCur
                                          ? TrudaColors.textColor000
                                          : TrudaColors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // if (isCur)
                                  //   Image.asset(
                                  //       'assets/images/newhita_home_country_choosed.png'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
