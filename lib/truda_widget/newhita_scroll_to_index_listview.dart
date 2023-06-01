import 'dart:ui';
import 'package:flutter/material.dart';

class NewHitaScrollToIndex extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final Duration? duration;
  final double topDistance;
  final int itemCount;
  final NewHitaScrollToIndexController? controller;

  const NewHitaScrollToIndex(
      {Key? key,
        this.duration,
        this.topDistance = 0,
        required this.controller,
        required this.itemCount,
        required this.itemBuilder})
      : super(key: key);

  @override
  _NewHitaScrollToIndexState createState() => _NewHitaScrollToIndexState();
}

class _NewHitaScrollToIndexState extends State<NewHitaScrollToIndex> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scrollKey = GlobalKey();

  /// 每个item的key
  final Map<int, GlobalKey> keys = {};

  GlobalKey getKey(int index) {
    print("getKey() index = $index");
    GlobalKey _scrollKey = GlobalKey();
    keys[index] = _scrollKey;
    return _scrollKey;
  }

  @override
  void initState() {
    super.initState();
    _bindController();
  }

  // 绑定控制器
  void _bindController() {
    widget.controller?._bind(this);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: _scrollKey,
      controller: _scrollController,
      child: ListView.builder(
        padding: EdgeInsets.zero, // 不加这行，头部有个高度，怎么回事？
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 10),
          key: getKey(index),
          child: widget.itemBuilder.call(context, index),
        ),
        itemCount: widget.itemCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant NewHitaScrollToIndex oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _bindController();
    }
  }

  // 滑动到指定下标的item
  void scrollToIndex(int index) {
    if (index > keys.length) {
      return;
    }
    GlobalKey? key = keys[index];
    if (key?.currentContext != null) {
      RenderBox renderBox =
      key!.currentContext!.findRenderObject() as RenderBox;
      double dy = renderBox
          .localToGlobal(Offset.zero,
          ancestor: _scrollKey.currentContext!.findRenderObject())
          .dy;
      var offset = dy + _scrollController.offset;
      double stateTopHei = MediaQueryData.fromWindow(window).padding.top;
      _scrollController.animateTo(offset - stateTopHei - widget.topDistance,
          duration: widget.duration ?? Duration(milliseconds: 500),
          curve: Curves.linear);
    } else {
      print(
          "Please bind the key to the widget in the outermost layer of the Item layout");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}

class NewHitaScrollToIndexController {
  _NewHitaScrollToIndexState? _scrollToIndexState;

  /// 滑动到指定位置
  void to(int index) {
    _scrollToIndexState!.scrollToIndex(index);
  }

  void dispose() {
    this._scrollToIndexState = null;
  }

  void _bind(_NewHitaScrollToIndexState state) {
    this._scrollToIndexState = state;
  }
}
