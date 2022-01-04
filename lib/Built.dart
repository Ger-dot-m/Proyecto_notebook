import 'package:flutter/material.dart';

class Built extends StatelessWidget{
  Built(this.x);
  String x = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Text("Construido\n$x")),
    );
  }
}