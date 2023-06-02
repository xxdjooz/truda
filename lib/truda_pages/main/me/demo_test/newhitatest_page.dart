import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:truda/truda_entities/truda_match_host_entity.dart';
import 'package:truda/truda_pages/call/remote/truda_remote_controller.dart';
import 'package:truda/truda_pages/her_video/newhitavideo_test.dart';
import 'package:truda/truda_pages/main/me/demo_test/newhita_test_image_picker.dart';
import 'package:truda/truda_pages/main/me/demo_test/newhita_test_webp.dart';
import 'package:truda/truda_utils/newhita_aic_handler.dart';
import 'package:truda/truda_utils/newhita_log.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../truda_common/truda_constants.dart';
import '../../../../truda_common/truda_language_key.dart';
import '../../../../truda_dialogs/truda_dialog_match_one.dart';
import '../../../../truda_entities/truda_aiv_entity.dart';
import '../../../../truda_http/truda_http_urls.dart';
import '../../../../truda_http/truda_http_util.dart';
import '../../../../truda_services/newhita_storage_service.dart';
import '../../../../truda_utils/newhita_third_util.dart';
import '../../../../truda_utils/newhita_voice_player.dart';
import '../../../../truda_widget/gift/newhita_gift_data_helper.dart';
import '../../../../truda_widget/gift/newhita_vap_player.dart';
import '../../../../truda_widget/newhita_gradient_boder.dart';
import '../../../../truda_widget/newhita_gradient_circular_progress_indicator.dart';
import '../../../../truda_widget/newhita_stacked_list.dart';
import '../../../some/newhita_media_view_page_2.dart';
import '../../../vip/newhita_vip_controller.dart';
import 'newhita_mock_dialog_page.dart';

class NewHitaTestPage extends StatefulWidget {
  const NewHitaTestPage({Key? key}) : super(key: key);

  @override
  State<NewHitaTestPage> createState() => _NewHitaTestPageState();
}

class _NewHitaTestPageState extends State<NewHitaTestPage> {
  var myVapController = NewHitaVapController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    NewHitaAudioCenter2.stopPlayRing();
  }

  /// 消耗掉一张体验卡
  void consumeOneCard() {
    TrudaHttpUtil()
        .post<void>(TrudaHttpUrls.useCardByAIBApi, errCallback: (err) {});
  }

  @override
  Widget build(BuildContext context) {
    Directionality.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Get.to(const NewHitaMockDailogPage());
                  },
                  child: Text('所有的弹窗到这里去看'),
                ),
                OutlinedButton(
                  onPressed: () {
                    var bean = TrudaMatchHost();
                    bean.video =
                        'http://yesme-public.oss-cn-hongkong.aliyuncs.com/app/resources/wang/20228291.mp4';
                    // aiv.filename =
                    //     'https://s3.hanilink.com/users/awss3/users/test/awss3/107780488/upload/anchor/upload/video/1551893908477493249compression.mp4';
                    // aiv.id = 445444747474747;
                    bean.userId = '107780488';
                    bean.portrait =
                        'https://oss.hanilink.com/users_test/107780487/upload/media/2022-03-29/_1648521386627_sendimg.JPEG';
                    bean.nickName = 'test test';
                    bean.muteStatus = 0;
                    TrudaDialogMatchOne.checkToShow(bean);
                  },
                  child: Text('match'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Text(TrudaLanguageKey.newhita_base_percent_location
                      .trArgs(['10'])),
                ),
                OutlinedButton(
                  onPressed: () {
                    consumeOneCard();
                  },
                  child: Text('consumeOneCard'),
                ),
                OutlinedButton(
                  onPressed: () {
                    testAiv();
                  },
                  child: Text('test aiv'),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Get.toNamed(NewHitaAppPages.vip);
                    NewHitaVipController.openDialog();
                  },
                  child: Text('vip'),
                ),
                OutlinedButton(
                  onPressed: () async {
                    WebView.platform = AndroidWebView();
                    var url =
                        'gojek://gopay/merchanttransfer?tref=0420221122115124H5LbCo6xsJID';
                    if (await canLaunch(url)) {
                      // launch(url);
                    }
                    var can = await canLaunch(url);
                    NewHitaLog.debug('$can');
                    // launch(url);
                  },
                  child: Text('test url_launcher'),
                ),
                OutlinedButton(
                  onPressed: () {
                    NewHitaAicHandler().testGetAicMsg();
                  },
                  child: Text('aic'),
                ),
                OutlinedButton(
                  onPressed: () {
                    TrudaRemoteController.startMeAib('107780488', '');
                  },
                  child: Text('startMeAib'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Get.to(NewHitaImageStackPage());
                  },
                  child: Text('images stack'),
                ),
                OutlinedButton(
                  onPressed: () {
                    NewHitaStorageService.to.prefs
                        .setBool(TrudaConstants.hadShowDragTip, false);
                  },
                  child: Text('hadShowDragTip false'),
                ),
                OutlinedButton(
                  onPressed: () {
                    NewHitaMediaViewPage2.startMe(context,
                        path:
                            // 'https://wscdn.hanilink.com/users/111142380/upload/media/2022-05-24/_1653403481431_sendimg.mp4',
                            'http://yesme-public.oss-cn-hongkong.aliyuncs.com/app/resources/wang/green.mp4',
                        cover: '',
                        type: 1,
                        heroId: 0);
                  },
                  child: Text('NewHitaMediaViewPage'),
                ),
                OutlinedButton(
                  onPressed: () {
                    NewHitaVideoTestPage.startMe(
                      context,
                      url:
                          // 'http://yesme-public.oss-cn-hongkong.aliyuncs.com/app/resources/wang/green.mp4',
                          // 涛哥上传的视频
                          'https://s3.sowotop.com/users/awss3/112646698/upload/media/video/2022_06_24_18_15_12/_1656074712164_.mp4',
                      // 辉阳压缩的视频
                      // 'https://s3.sowotop.com/users/awss3/112646698/upload/media/video/2022_06_24_18_15_12/_1656074712164_compression.mp4',
                      // 'http://yesme-public.oss-cn-hongkong.aliyuncs.com/app/resources/wang/video_640.mp4',
                    );
                  },
                  child: Text('Video test'),
                ),
                OutlinedButton(
                  onPressed: () {
                    NewHitaAudioCenter2.playRing();
                  },
                  child: Text('AudioCenter2'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            NewHitaTestImagePickerPage(
                          title: 'haha',
                        ),
                      ),
                    );
                  },
                  child: Text('image picker'),
                ),
                OutlinedButton(
                  onPressed: () {
                    AdjustEvent adjustEvent = AdjustEvent(
                        GetPlatform.isIOS == true
                            ? TrudaConstants.adjustEventKeyIos
                            : TrudaConstants.adjustEventKey);
                    adjustEvent.setRevenue(1.0, 'USD');
                    adjustEvent.transactionId =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    Adjust.trackEvent(adjustEvent);
                  },
                  child: Text('adjust pay 1'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Map<String, dynamic> map = {};
                    map["fb_currency"] = 'USD';
                    // 这里有个坑，传null进去会导致上传失败
                    map["fb_search_string"] = "test test";
                    NewHitaThirdUtil.facebookLog(1, 'USD', map);
                  },
                  child: Text('facebook pay 1'),
                ),
                OutlinedButton(
                  onPressed: () {
                    NewHitaGiftDataHelper.getGifts().then((value) {
                      myVapController.playGift(value!.first);
                    });
                  },
                  child: Text('Gift send'),
                ),
                NewHitaGradientCircularProgressIndicator(
                  colors: const [Colors.green, Colors.orange],
                  radius: 50.0,
                  stokeWidth: 3.0,
                  value: 0.3,
                ),
                MyImage(),
                SizedBox(
                  width: 140,
                  height: 140,
                  child: const NewHitaGradientBoder(
                    border: 4,
                    colorSolid: Colors.grey,
                    borderRadius: 8,
                    colors: [
                      Colors.yellow,
                      Colors.green,
                    ],
                    child: Padding(
                      padding: EdgeInsets.all(80.0),
                      child: Text('渐变边框'),
                    ),
                  ),
                ),
                CustomRotatedBox(
                  child: Text(
                    "A",
                    textScaleFactor: 5,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
              child: NewHitaVapPlayer(
            vapController: myVapController,
          )),
          Row(
            children: [
              Image.asset('assset/s/.png'),
              Expanded(child: Text('奥迪阿娇发动机覅发来的房间啊aaaaaa aaa aaaaaa aaaa', )),
            ],
          ),
          SizedBox(
            width: 375,
            height: 400,
            child: Column(
              children: [
                Image.asset(
                  'assset/s/.png',
                  width: double.infinity,
                ),
                Expanded(child: ListView()),
              ],
            ),
          ),
          SizedBox(
            width: 375,
            height: 400,
            child: Image.asset(
              'assset/s/.png',
              width: 200,
              height: 200,
            ),
          ),
          Container(
            width: 100,
            padding: EdgeInsets.symmetric(vertical: 100),
            margin: EdgeInsets.symmetric(vertical: 100),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Image.asset(
              'assset/s/.png',
              width: 200,
              height: 200,
            ),
          ),
          Stack(
            children: [
              Positioned(
                left: 10,
                right: 10,
                top: 10,
                bottom: 20,
                child: Image.asset('name'),
              ),
              PositionedDirectional(
                start: 10,
                end: 10,
                top: 10,
                bottom: 20,
                child: Image.asset(
                  'name',
                  matchTextDirection: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void testAiv() {
    TrudaAivBean aiv = TrudaAivBean();
    // aiv.filename =
    //     'https://yesme-public.oss-cn-hongkong.aliyuncs.com/app/testMp4.mp4';
    aiv.filename =
        // 'http://yesme-public.oss-cn-hongkong.aliyuncs.com/app/resources/wang/20228291.mp4';
        // 'https://media.w3.org/2010/05/sintel/trailer.mp4';
        // 'http://yesme-public.oss-cn-hongkong.aliyuncs.com/app/resources/wang/20228291.mp4';
        'https://wss3.hanilink.com/users/test/awss3/107813538/upload/media/video/2023_02_24_19_56_02/_1677239762056_.mp4';
    // aiv.filename =
    //     'https://s3.hanilink.com/users/awss3/users/test/awss3/107780488/upload/anchor/upload/video/1551893908477493249compression.mp4';
    // aiv.id = 445444747474747;
    aiv.userId = '107780488';
    aiv.nickname = '1057644';
    aiv.portrait =
        'https://oss.hanilink.com/users_test/107780487/upload/media/2022-03-29/_1648521386627_sendimg.JPEG';
    aiv.nickname = 'test test';
    aiv.muteStatus = 0;
    // aiv.isCard = 0;
    TrudaRemoteController.startMeAiv(aiv);
  }
}

class CustomRotatedBox extends SingleChildRenderObjectWidget {
  CustomRotatedBox({Key? key, Widget? child}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomRenderRotatedBox();
  }
}

class CustomRenderRotatedBox extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  Matrix4? _paintTransform;

  @override
  void performLayout() {
    _paintTransform = null;
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
      //根据子组件大小计算出旋转矩阵
      _paintTransform = Matrix4.identity()
        ..translate(size.width / 2.0, size.height / 2.0)
        ..rotateZ(math.pi / 2) // 旋转90度
        ..translate(-child!.size.width / 2.0, -child!.size.height / 2.0);
    } else {
      size = constraints.smallest;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      // 根据偏移，需要调整一下旋转矩阵
      final Matrix4 transform =
          Matrix4.translationValues(offset.dx, offset.dy, 0.0)
            ..multiply(_paintTransform!)
            ..translate(-offset.dx, -offset.dy);
      _paint(context, offset, transform);
    } else {
      //...
    }
  }

  void _paint(PaintingContext context, Offset offset, Matrix4 transform) {
    // 为了不干扰其他和自己在同一个layer上绘制的节点，所以需要先调用save然后在子元素绘制完后
    // 再调用restore显示，关于save/restore有兴趣可以查看Canvas API doc
    context.canvas
      ..save()
      ..transform(transform.storage);
    context.paintChild(child!, offset);
    context.canvas.restore();
  }
}
