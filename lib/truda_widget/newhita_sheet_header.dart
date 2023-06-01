import 'package:flutter/material.dart';

class NewHitaSheetHeader extends StatelessWidget {
  const NewHitaSheetHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images_sized/newhita_charge_quick_pic.png',
          height: 50,
        ),
        Container(
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xffD3ABFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            // border: Border.all(
            //   color: const Color(0xffD3ABFF),
            //   width: 2,
            // ),
          ),
          alignment: AlignmentDirectional.bottomCenter,
          child: Container(
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xffA965F5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              // border: Border.all(
              //   color: const Color(0xffD3ABFF),
              //   width: 2,
              // ),
            ),
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xff7942B5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                height: 25,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                ),
              ),
            ),
          ),
        ),
        // 解决列里面两个同色块会有缝隙问题
        Container(
          height: 0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
