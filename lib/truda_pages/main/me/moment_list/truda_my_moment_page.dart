import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_constants.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/main/me/moment_list/truda_my_moment_controller.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../truda_common/truda_colors.dart';
import '../../../../truda_common/truda_common_dialog.dart';
import '../../../../truda_dialogs/truda_dialog_confirm.dart';
import '../../../../truda_routes/newhita_pages.dart';
import '../../../../truda_widget/newhita_app_bar.dart';
import '../../../some/newhita_media_view_page.dart';

class TrudaMyMomentPage extends GetView<TrudaMyMomentController> {
  TrudaMyMomentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrudaMyMomentController>(builder: (contro) {
      return Scaffold(
        appBar: NewHitaAppBar(
          title: Text(
            TrudaLanguageKey.newhita_story_mine.tr,
          ),
          actions: [
            GestureDetector(
              child: Image.asset('assets/images/newhita_moment_create.png'),
              onTap: () {
                Get.toNamed(NewHitaAppPages.createMoment);
              },
            ),
            // const SizedBox(
            //   width: 10,
            // )
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: Container(
              color: TrudaColors.baseColorGrey,
              width: double.infinity,
              height: 10,
            ),
          ),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: TrudaColors.white,
        body: GetBuilder<TrudaMyMomentController>(builder: (controller) {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: controller.enablePullUp,
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: controller.dataList.isEmpty
                ? ListView(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: 300,
                        child: Image.asset(
                          'assets/images/newhita_base_empty.png',
                          height: 150,
                          width: 150,
                        ),
                      )
                    ],
                  )
                : ListView.builder(
                    itemCount: controller.dataList.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      var bean = controller.dataList[index];
                      String? updateTime;
                      var time = DateTime.fromMillisecondsSinceEpoch(
                          bean.updatedAt ?? 0);
                      updateTime = DateFormat('MM/dd').format(time);
                      return Container(
                        // margin: EdgeInsetsDirectional.only(bottom: 15.w),
                        padding: EdgeInsetsDirectional.all(10),
                        decoration: BoxDecoration(
                          color: TrudaColors.white,
                          borderRadius: BorderRadius.circular(14),
                          // border: Border(
                          //     top: BorderSide(color: Colors.white24, width: 1)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 10, 0),
                              child:  RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: DateFormat('MM').format(time),
                                      style: const TextStyle(
                                          color: TrudaColors.textColor333,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: DateFormat('/dd').format(time),
                                      style: const TextStyle(
                                          color: TrudaColors.textColor333,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (bean.pathArray?.isNotEmpty == true)
                                    GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 0,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 10,
                                        crossAxisCount:
                                            bean.pathArray!.length == 1 ? 2 : 3,
                                      ),
                                      itemCount: bean.pathArray!.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var media = bean.pathArray![index];
                                        var heroId = bean.createdAt ?? index;
                                        return GestureDetector(
                                          onTap: () {
                                            NewHitaMediaViewPage.startMe(
                                                context,
                                                path: media,
                                                cover: '',
                                                type: 0,
                                                heroId: heroId);
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Hero(
                                                tag: heroId,
                                                child: NewHitaNetImage(
                                                  media,
                                                  radius: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  if (bean.content != null &&
                                      bean.content!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        bean.content ?? '',
                                        style: const TextStyle(
                                          color: TrudaColors.textColor333,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (TrudaConstants.isFakeMode)
                                      Text(
                                        TrudaLanguageKey.newhita_reviewing.tr,
                                        style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          TrudaCommonDialog.dialog(
                                              TrudaDialogConfirm(
                                            callback: (i) {
                                              controller.removeBlack(bean.rid!);
                                            },
                                            title: TrudaLanguageKey
                                                .newhita_delete_tip.tr,
                                          ));
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.delete_outline,
                                              color: TrudaColors.textColor666,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              TrudaLanguageKey
                                                  .newhita_dialog_remove_black
                                                  .tr,
                                              style: const TextStyle(
                                                  color: TrudaColors
                                                      .textColor666,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
          );
        }),
      );
    });
  }
}
