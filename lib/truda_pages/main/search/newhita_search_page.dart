import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_common/truda_language_key.dart';
import 'package:truda/truda_pages/main/search/newhita_search_bar.dart';

import '../../../truda_common/truda_colors.dart';
import '../../../truda_entities/truda_host_entity.dart';
import '../../../truda_widget/newhita_decoration_bg.dart';
import '../../../truda_widget/newhita_net_image.dart';
import '../../host/newhita_host_controller.dart';
import '../home/newhita_host_widget.dart';
import 'newhita_search_controller.dart';

class NewHitaSearchPage extends GetView<NewHitaSearchController> {
  NewHitaSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewHitaSearchController>(builder: (contro) {
      return Scaffold(
        backgroundColor: TrudaColors.baseColorBlackBg,
        // appBar: NewHitaAppBarSearch(
        //   backgroundColor: Colors.transparent,
        //
        // ),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            bottom: NewHitaAppBarSearch(
              leading: SizedBox(),
              backgroundColor: Colors.transparent,
              onSearch: contro.search,
              onRightTap: contro.search,
            )),
        extendBodyBehindAppBar: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const NewHitaDecorationBg(),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsetsDirectional.only(start: 5, end: 5),
                child: Text(
                  TrudaLanguageKey.newhita_recommend_tips.tr,
                  style: TextStyle(
                    color: TrudaColors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 17 / 23),
                    itemCount: controller.list?.length ?? 0,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      var bean = controller.list![index];
                      return NewHitaHostSearchWidget(
                        detail: bean,
                      );
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}

class NewHitaHostSearchWidget extends StatelessWidget {
  final TrudaHostDetail detail;

  const NewHitaHostSearchWidget({Key? key, required this.detail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NewHitaHostController.startMe(detail.userId!, detail.portrait);
      },
      child: Stack(
        children: [
          Positioned.fill(
              child: NewHitaNetImage(
            detail.portrait ?? "",
            radius: 10,
          )),
          // PositionedDirectional(
          //   top: 10,
          //   start: 10,
          //   child: NewHitaNetImage(
          //     detail.area?.path ?? "",
          //     radius: 9,
          //     width: 18,
          //     height: 18,
          //   ),
          // ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(7),
                        bottomRight: Radius.circular(7)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x8878185E)])),
              )),
          PositionedDirectional(
            top: 10,
            end: 10,
            child: NewHitaHostStateWidget(
              isDoNotDisturb: detail.isDoNotDisturb ?? 0,
              isOnline: detail.isOnline ?? 0,
            ),
          ),
          PositionedDirectional(
            bottom: 10,
            start: 10,
            end: 10,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.nickname ?? "",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // PositionedDirectional(
          //     bottom: 80,
          //     end: 10,
          //     child: GestureDetector(
          //         onTap: () {
          //           NewHitaChatController.startMe(detail.userId!);
          //         },
          //         child: Image.asset("assets/images/newhita_home_msg.png"))),
        ],
      ),
    );
  }
}
