import 'package:flutter/material.dart';


// 普遍页面
class NewHitaPageDemo extends StatefulWidget {
  const NewHitaPageDemo({Key? key}) : super(key: key);

  @override
  State<NewHitaPageDemo> createState() => _NewHitaPageDemoState();
}

class _NewHitaPageDemoState extends State<NewHitaPageDemo> {
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