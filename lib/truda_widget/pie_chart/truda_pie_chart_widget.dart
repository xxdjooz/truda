import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'truda_chart_utils.dart';

class TrudaPieChartController {
  _TrudaPieChartWidgetState? _state;
  Function(int index)? arrivePosition;
  void beginRoll() {
    _state?._beginToRotate();
  }

  void toIndex(int index) {
    _state?._stopRotateAndToPosition(index);
  }

  void close() {
    _state = null;
    arrivePosition = null;
  }
}

class TrudaPieChartWidget extends StatefulWidget {
  ///比例集合
  List<double> proportions;

  ///文案集合
  List<String> contents;

  // image 在assets里面的
  Map<int, ui.Image> images;

  ///颜色集合
  List<Color> colors;

  double startTurns = pi / 2;
  double radius = 130;
  TrudaPieChartController controller;
  TrudaPieChartWidget(this.proportions, this.colors,
      {Key? key,
      required this.contents,
      required this.radius,
      required this.images,
      required this.controller,
      this.startTurns = 0})
      : super(key: key);

  @override
  _TrudaPieChartWidgetState createState() => _TrudaPieChartWidgetState();
}

class _TrudaPieChartWidgetState extends State<TrudaPieChartWidget>
    with TickerProviderStateMixin {
  ///这个是 自动
  AnimationController? autoAnimationController;
  AnimationController? animationController;

  Animation<double>? tween;

  double turns = .0;

  final GlobalKey _key = GlobalKey();

  ///角加速度，类似摩擦力 的作用 ，让惯性滚动 减慢，这个意思是每一秒 ，角速度 减慢vA个pi。
  double vA = 40.0;

  Offset offset = Offset.zero;

  double pBy = .0;

  double pBx = .0;

  double pAx = .0;

  double pAy = .0;

  double mCenterX = .0;
  double mCenterY = .0;

  double? animalValue;

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
  }

  // 获取图片 本地为false 网络为true
  Future<ui.Image> loadImage(var path, bool isUrl) async {
    ImageStream stream;
    if (isUrl) {
      stream = NetworkImage(path).resolve(ImageConfiguration.empty);
    } else {
      stream = AssetImage(path, bundle: rootBundle)
          .resolve(ImageConfiguration.empty);
    }
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(ImageStreamListener(listener));
    }

    stream.addListener(ImageStreamListener(listener));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2 * widget.radius,
      height: 2 * widget.radius,
      child: GestureDetector(
        // onPanEnd: _onPanEnd,
        // onPanDown: _onPanDown,
        // onPanUpdate: _onPanUpdate,
        // onTap: _beginToRotate,
        // onDoubleTap: () => _stopRotateAndToPosition(3),
        child: CustomPaint(
          painter: TrudaPieChartPainter(turns, widget.startTurns, widget.proportions,
              widget.colors, widget.images, widget.contents, _key, currentPosi),
          key: _key,
        ),
      ),
    );
  }

  var currentPosi = -1;
  // 3s后滑倒指定位置
  void _autoToPosition(int index) {
    var len = widget.contents.length;
    var start = 0.0;
    // 转到指定位置 算法 位置（这里用负数是因为顺时针绘制又是顺时针转的）+ 多转的圈数
    final circle = -(index + 0.5) / len + 6;
    // 转的角度
    var end = circle * pi * 2;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this)
      ..addListener(() {
        // var posi = end * (autoAnimationController?.value ?? 0) / 1;
        // setState(() {
        //   turns = posi;
        // });
      });

    final Animation<double> curve = CurvedAnimation(
        parent: animationController!, curve: Curves.easeOutCubic);
    Animation tween = Tween<double>(begin: start, end: end).animate(curve);
    tween.addListener(() {
      setState(() {
        turns = tween.value;
        if (turns == end) {
          currentPosi = -1;
          widget.controller.arrivePosition?.call(index);
        } else {
          currentPosi = (len - (((turns / pi / 2) % 1) * len).ceil());
        }
      });
    });
    animationController!.forward();
  }

  void _stopRotateAndToPosition(int index) {
    if (autoAnimationController != null &&
        autoAnimationController!.isAnimating) {
      autoAnimationController!.stop(canceled: true);
      autoAnimationController!.dispose();
      autoAnimationController = null;
    }
    setState(() {
      turns = 0;
    });
    _autoToPosition(index);
  }

  // 10s后滑倒指定位置
  void _beginToRotate() {
    var len = widget.contents.length;
    var start = 0.0;
    // 转的角度
    var end = 10 * pi * 2;

    autoAnimationController = AnimationController(
        duration: const Duration(milliseconds: 10000), vsync: this)
      ..addListener(() {
        // if (autoAnimationController!.value >= 0.35) {
        //   _stopRotateAndToPosition();
        // }
      });

    final Animation<double> curve =
        CurvedAnimation(parent: autoAnimationController!, curve: Curves.easeIn);
    Animation<double> tween =
        Tween<double>(begin: start, end: end).animate(curve);
    tween.addListener(() {
      setState(() {
        turns = tween.value;
        if (turns == end) {
          currentPosi = -1;
        } else {
          currentPosi = (len - (((turns / pi / 2) % 1) * len).ceil());
        }
      });
    });
    autoAnimationController!.forward();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    pBx = details.globalPosition.dx;

    //后面的 点的 x坐标
    pBy = details.globalPosition.dy;

    //后面的点的 y坐标

    double dTurns = getTurns();

    setState(() {
      turns += dTurns;
    });

    pAx = pBx;
    pAy = pBy;
  }

  void _onPanDown(DragDownDetails details) {
    if (offset == Offset.zero) {
      //获取position
      RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
      offset = box.localToGlobal(Offset.zero);
      mCenterX = offset.dx + 130;
      mCenterY = offset.dy + 130;
    }

    pAx = details.globalPosition.dx; //初始的点的 x坐标
    pAy = details.globalPosition.dy; //初始的点的 y坐标
  }

  double getTurns() {
    ///计算 之前的点相对于水平的 角度
    ///
    ///
    /// o点（offset.dx+130,offset.dy+130）.
    /// C点 （offset.dx+260,offset.dy+130）.
    /// oc距离  130
    ///
    /// A点 （pAx,pAy）,
    /// B点  (pBx,pBy).
    /// AC距离
    double acDistance = TrudaChartUtils.distanceForTwoPoint(
        offset.dx + 2 * widget.radius, offset.dy + widget.radius, pAx, pAy);

    /// AO距离
    double aoDistance = TrudaChartUtils.distanceForTwoPoint(
        offset.dx + widget.radius, offset.dy + widget.radius, pAx, pAy);

    ///计算 cos aoc 的值 ，然后拿到 角 aoc
    ///
    double ocdistance = widget.radius;

    int c = 1;

    if (pAy < (offset.dy + widget.radius)) {
      c = -1;
    }

    double cosAOC = (aoDistance * aoDistance +
            ocdistance * ocdistance -
            acDistance * acDistance) /
        (2 * aoDistance * ocdistance);
    double AOC = c * acos(cosAOC);

    /// BC距离
    double bcDistance = TrudaChartUtils.distanceForTwoPoint(
        offset.dx + 2 * widget.radius, offset.dy + widget.radius, pBx, pBy);

    /// BO距离
    double boDistance = TrudaChartUtils.distanceForTwoPoint(
        offset.dx + widget.radius, offset.dy + widget.radius, pBx, pBy);

    c = 1;
    if (pBy < (offset.dy + widget.radius)) {
      c = -1;
    }

    ///计算 cos boc 的值，然后拿到角 boc；
    double cosBOC = (boDistance * boDistance +
            ocdistance * ocdistance -
            bcDistance * bcDistance) /
        (2 * boDistance * ocdistance);
    double BOC = c * acos(cosBOC);

    return BOC - AOC;
  }

  ///抬手的时候 ， 惯性滑动
  void _onPanEnd(DragEndDetails details) {
    double vx = details.velocity.pixelsPerSecond.dx;
    double vy = details.velocity.pixelsPerSecond.dy;
    if (vx != 0 || vy != 0) {
      onFling(vx, vy);
    }
  }

  void onFling(double velocityX, double velocityY) {
    //获取触点到中心点的线与水平线正方向的夹角
    double levelAngle =
        TrudaChartUtils.getPointAngle(mCenterX, mCenterY, pBx, pBy);
    //获取象限
    int quadrant = TrudaChartUtils.getQuadrant(pBx - mCenterX, pBy - mCenterY);
    //到中心点距离
    double distance =
        TrudaChartUtils.distanceForTwoPoint(mCenterX, mCenterY, pBx, pBy);
    //获取惯性绘制的初始角度
    double inertiaInitAngle = TrudaChartUtils.calculateAngleFromVelocity(
        velocityX, velocityY, levelAngle, quadrant, distance);

    if (inertiaInitAngle != null && inertiaInitAngle != 0) {
      //如果角速度不为0； 则进行滚动

      /// 按照 va的加速度 拿到 滚动的时间 。 也就是 结束后 惯性动画的 执行 时间， 高中物理
      double t = TrudaChartUtils.abs(inertiaInitAngle) / vA;
      double s = t * inertiaInitAngle / 2;

      animalValue = turns;
      var time = DateTime.now();
      int direction = 1;

      ///方向控制参数
      if (inertiaInitAngle < 0) {
        direction = -1;
      }
      autoAnimationController = AnimationController(
          duration: Duration(milliseconds: (t * 1000).toInt()), vsync: this)
        ..addListener(() {
          var animalTime = DateTime.now();
          int t1 =
              animalTime.millisecondsSinceEpoch - time.millisecondsSinceEpoch;
          setState(() {
            double s1 = (2 * inertiaInitAngle - direction * vA * (t1 / 1000)) *
                t1 /
                (2 * 1000);
            turns = animalValue! + s1;
          });
        });

      autoAnimationController!.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    autoAnimationController?.dispose();
  }
}

class TrudaPieChartPainter extends CustomPainter {
  GlobalKey _key = GlobalKey();

  double turns = .0;
  double startTurns = pi / 2;

  List<String> contents;
  Map<int, ui.Image> images;

  List<double> angles;

  List<Color> colors;

  double startAngles = 0;
  int currentPosi;

  TrudaPieChartPainter(this.turns, this.startTurns, this.angles, this.colors,
      this.images, this.contents, this._key, this.currentPosi);

  @override
  void paint(Canvas canvas, Size size) {
    drawAcr(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  void drawAcr(Canvas canvas, Size size) {
    startAngles = 0;
    // 把画布坐标放中间
    canvas.translate(size.width / 2, size.height / 2);
    // 因为现在0度在右边x轴，先逆时针90度，为了从上边作为第一个，顺时针绘制
    canvas.rotate(-pi / 2);

    /// 中心
    Rect rect = Rect.fromCircle(center: Offset.zero, radius: size.width / 2);
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    //画扇形
    for (int i = 0; i < angles.length; i++) {
      paint.color = currentPosi == i ? Colors.white : colors[i];
      canvas.drawArc(rect, 2 * pi * startAngles + turns + startTurns,
          2 * pi * angles[i], true, paint);
      startAngles += angles[i];
    }

    startAngles = 0;

    for (int i = 0; i < contents.length; i++) {
      canvas.save();

      // 新建一个段落建造器，然后将文字基本信息填入;
      ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        fontSize: 12.0,
      ));
      pb.pushStyle(ui.TextStyle(color: const Color(0xFFB4442D)));

      pb.addText(contents[i]);
      // 设置文本的宽度约束
      ui.ParagraphConstraints pc = const ui.ParagraphConstraints(width: 50);
      // 这里需要先layout,将宽度约束填入，否则无法绘制
      ui.Paragraph paragraph = pb.build()..layout(pc);

      double roaAngle =
          2 * pi * (startAngles + angles[i] / 2) + turns + startTurns;
      // 先把画布转到指定扇形中心，这时x轴在扇形中心，绘制文字会在扇形方向
      canvas.rotate((1) * roaAngle);
      // 先沿x轴移动一定距离，再转动90度，绘制文字就在扇形中心垂直方向了
      canvas.translate(90, 0);
      canvas.rotate(pi / 2);
      // 文字左上角起始点
      Offset offset = Offset(0 - paragraph.width / 2, 0);
      canvas.drawParagraph(paragraph, offset);

      // 位置 图片宽高30
      Rect pR = const Rect.fromLTWH(-15, -30, 30, 30);
      var image = images[i];
      if (image != null) {
        // 图片
        Rect iR = Rect.fromLTRB(
            0, 0, image.width.toDouble(), image.height.toDouble());
        canvas.drawImageRect(image, iR, pR, paint);
      }

      startAngles += angles[i];

      canvas.restore();
    }
  }
}
