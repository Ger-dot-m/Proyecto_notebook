import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'Funciones.dart';
import 'Procesa.dart';
import 'Built.dart';

class MenuText extends StatefulWidget {
  String nombre = "";
  MenuText(this.nombre, {Key? key}) : super(key: key);

  @override
  _MenuTextState createState() => _MenuTextState(nombre);
}


class _MenuTextState extends State<MenuText> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final analiza = Separa(), formatos = Formato();
  final _controllerBoxText = TextEditingController();
  String nombre = "", contenido = "";
  Future<String>? dato;
  _MenuTextState(this.nombre);

  Future<void> getContent() async {
    final SharedPreferences prefs = await _prefs;
    contenido = prefs.getString(nombre) ?? "";
  }

  Future<void> saveContent() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(nombre, _controllerBoxText.text);
  }

  void renderData(){
    saveContent();
    List<String> entry, objts = analiza.getStatments(_controllerBoxText.text);
    String out = "";
    for(String item in objts){
      print(item);
      entry = analiza.getItem(item);
      out += formatos.Soluciona(entry)+"\n";
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Built(out);
      }),
    );
  }

  @override
  void initState() {
    getContent().then((value) {
      setState(() {
        _controllerBoxText.text = contenido;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save_alt),
          onPressed: renderData,
          backgroundColor: Colors.lightBlueAccent,
        ),
        backgroundColor: Colors.white12,
        appBar: AppBar(
          title: Text(nombre),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: BoxText());
  }

  Widget BoxText() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: TextField(
        controller: _controllerBoxText,
        autocorrect: false,
        cursorColor: Colors.red,
        cursorWidth: 3,
        maxLines: 500,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Escribe aquí",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

}
