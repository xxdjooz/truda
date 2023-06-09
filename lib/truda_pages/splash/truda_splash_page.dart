import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truda/truda_pages/splash/truda_splash_controller.dart';

import '../../truda_common/truda_colors.dart';
import '../../truda_widget/truda_decoration_bg.dart';

class TrudaSplashPage extends GetView<TrudaSplashController> {
  TrudaSplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<TrudaSplashController>(() => TrudaSplashController());
    return GetBuilder<TrudaSplashController>(builder: (contr) {
      return Scaffold(
        backgroundColor: TrudaColors.baseColorBlackBg,
        body: Container(
          decoration: BoxDecoration(
            image: GetPlatform.isIOS
                ? const DecorationImage(
                    image: AssetImage(
                      'assets/newhita_login_ios.webp',
                    ),
                    fit: BoxFit.fitWidth,
                  )
                : const DecorationImage(
                    image: AssetImage(
                      'assets/images_sized/newhita_login_bg.webp',
                    ),
                    fit: BoxFit.fitWidth,
                  ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Container(
              //   decoration: const BoxDecoration(
              //       gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     colors: [
              //       Colors.black38,
              //       Colors.black,
              //     ],
              //   )),
              // ),
              Column(
                children: <Widget>[

                  Expanded(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/newhita_base_logo.png',
                          width: 125,
                          height: 125,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
