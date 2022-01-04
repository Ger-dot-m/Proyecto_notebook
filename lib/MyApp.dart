import 'package:flutter/material.dart';
import 'Archivos.dart';
import 'Interprete.dart';

class Inicio extends StatefulWidget {
  Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _index = 0;
  List<Widget> _paginas = [Interprete(), filesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _paginas[_index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (index) {setState(() {_index = index;});},
          backgroundColor: Colors.lightBlueAccent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.code), label: 'Interprete'),
            BottomNavigationBarItem(icon: Icon(Icons.sticky_note_2_outlined), label: 'Archivos')
          ],
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        selectedFontSize: 10,
      ),
    );
  }
}
