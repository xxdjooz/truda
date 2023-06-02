import 'package:flutter/material.dart';


// 普遍页面
class TrudaPageDemo extends StatefulWidget {
  const TrudaPageDemo({Key? key}) : super(key: key);

  @override
  State<TrudaPageDemo> createState() => _TrudaPageDemoState();
}

class _TrudaPageDemoState extends State<TrudaPageDemo> {
  int num = 0;
  void add(){
    setState(() {
      num++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('$num'),
          OutlinedButton(
            onPressed: () {
              add();
            },
            child: Text('点击我加一'),
          ),
        ],
      ),
    );
  }
}

// 使用了Get框架的页面