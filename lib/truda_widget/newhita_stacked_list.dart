import 'package:flutter/material.dart';
import 'package:truda/truda_widget/newhita_net_image.dart';

class NewHitaStackedList extends StatelessWidget {
  final double sizeW = 44.0;
  final double offsetW = 20.0;
  List<String>? list;

  NewHitaStackedList({Key? key, required this.list}) : super(key: key);

  double _getImageStackWidth() {
    if (list?.isNotEmpty != true) return 0;
    return offsetW * (list!.length - 1) + sizeW;
  }

  List<Widget> _getStackItems() {
    List<Widget> _list = <Widget>[];
    if (list?.isNotEmpty != true) return _list;
    for (var i = 0; i < list!.length; i++) {
      double off = 20.0 * i;
      _list.add(PositionedDirectional(
        start: off,
        child: CircleAvatar(
          child: NewHitaNetImage(
            list![i],
            width: sizeW,
            height: sizeW,
            isCircle: true,
            errorWidget: (context, url, error) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.asset(
                  'assets/images_sized/newhita_base_avatar.webp',
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        ),
      ));
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    // 最多显示三个
    if (list != null && list!.length > 3) {
      list = list!.sublist(0, 3);
    }
    return Container(
        height: sizeW,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: _getImageStackWidth(),
              height: double.infinity,
              child: Stack(
                children: _getStackItems(),
              ),
            ),
          ],
        ));
  }
}

class NewHitaImageStackPage extends StatelessWidget {
  final double sizeW = 50.0;
  final double offsetW = 20.0;

  int _getSpaceStackFlex(BuildContext context, int imageNumber) {
    int maxNum = (MediaQuery.of(context).size.width - 16).toInt();
    int num = (offsetW * (imageNumber - 1) + sizeW).toInt();
    return maxNum - num + 1;
  }

  int _getImageStackFlex(BuildContext context, int imageNumber) {
    int num = (offsetW * (imageNumber - 1) + sizeW).toInt();
    return num;
  }

  double _getImageStackWidth(int imageNumber) {
    return offsetW * (imageNumber - 1) + sizeW;
  }

  List<Widget> _getStackItems(int count) {
    List<Widget> _list = <Widget>[];
    for (var i = 0; i < count; i++) {
      double off = 20.0 * i;
      _list.add(Positioned(
        left: off,
        child: CircleAvatar(
          child: Image(
            image: AssetImage("assets/newhita_base_logo.png"),
            width: sizeW,
            height: sizeW,
          ),
        ),
      ));
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('头像堆叠'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                height: 40,
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: _getImageStackWidth(8),
                      height: double.infinity,
                      child: Stack(
                        children: _getStackItems(8),
                      ),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                )),
            Container(
                height: 40,
                child: Container(
                  color: Colors.teal,
                  child: Stack(
                    children: _getStackItems(8),
                  ),
                )),
            Container(
                color: Colors.grey,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: _getSpaceStackFlex(context, 8),
                      child: Container(
                        color: Colors.yellow,
                        height: 40,
                      ),
                    ),
                    Expanded(
                      flex: _getImageStackFlex(context, 8),
                      child: Container(
                        color: Colors.red,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: <Widget>[
                            CircleAvatar(
                              child: Image(
                                image: AssetImage("assets/newhita_base_logo.png"),
                                width: sizeW,
                                height: sizeW,
                              ),
                            ),
                            Positioned(
                              right: 20,
                              child: CircleAvatar(
                                child: Image(
                                  image:
                                      AssetImage("assets/newhita_base_logo.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 40,
                              child: CircleAvatar(
                                child: Image(
                                  image:
                                      AssetImage("assets/newhita_base_logo.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 60,
                              child: CircleAvatar(
                                child: Image(
                                  image:
                                      AssetImage("assets/newhita_base_logo.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 80,
                              child: CircleAvatar(
                                child: Image(
                                  image:
                                      AssetImage("assets/newhita_base_logo.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 100,
                              child: CircleAvatar(
                                child: Image(
                                  image:
                                      AssetImage("assets/newhita_base_logo.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 120,
                              child: CircleAvatar(
                                child: Image(
                                  image:
                                      AssetImage("assets/newhita_base_logo.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 140,
                              child: CircleAvatar(
                                child: Image(
                                  image:
                                      AssetImage("assets/newhita_base_logo.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
