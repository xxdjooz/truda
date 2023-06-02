import 'dart:async';

import 'package:flutter/material.dart';
import 'package:truda/truda_utils/truda_log.dart';

import '../../truda_common/truda_colors.dart';

class TrudaTimeCountWidget extends StatefulWidget {
  int? left_time_inter;
  Function cancel;

  TrudaTimeCountWidget(this.left_time_inter, this.cancel);

  @override
  _TrudaTimeCountWidgetState createState() => _TrudaTimeCountWidgetState();
}

class _TrudaTimeCountWidgetState extends State<TrudaTimeCountWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget.left_time_inter == null) {
        timer.cancel();
        _timer = null;
        widget.cancel.call();
      } else {
        if (widget.left_time_inter! <= 0) {
          timer.cancel();
          _timer = null;
          widget.cancel.call();
          return;
        }
        TrudaLog.debug('TrudaTimeCountWidget ${widget.left_time_inter}');
        setState(() {
          widget.left_time_inter = widget.left_time_inter! - 1000;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    int left_time_inter = widget.left_time_inter ?? 0;
    var leftTimeS = left_time_inter ~/ 1000;
    var seconds = leftTimeS;
    var strH = seconds ~/ 3600;
    var strM = seconds % 3600 ~/ 60;
    var strS = seconds % 60;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color(0x7F000000),
              borderRadius: BorderRadiusDirectional.all(Radius.circular(6))),
          child: Text(
            strH.toString(),
            style: TextStyle(
                color: TrudaColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(end: 3),
          child: Text(
            ":",
            style: TextStyle(
                color: TrudaColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color(0x7F000000),
              borderRadius: BorderRadiusDirectional.all(Radius.circular(6))),
          child: Text(
            strM.toString(),
            style: TextStyle(
                color: TrudaColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(end: 3),
          child: Text(
            ":",
            style: TextStyle(
                color: TrudaColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color(0x7F000000),
              borderRadius: BorderRadiusDirectional.all(Radius.circular(6))),
          child: Text(
            strS.toString(),
            style: TextStyle(
                color: TrudaColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
