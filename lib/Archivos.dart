import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'MenuText.dart';

class filesScreen extends StatefulWidget {
  const filesScreen({Key? key}) : super(key: key);
  @override
  _filesScreen createState() => _filesScreen();
}

class _filesScreen extends State<filesScreen> {
  int count = 1;
  List<Widget> files = [];
  List<String> nombres = [];
  var contenido = "";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _Controller = TextEditingController();

  @override
  void initState() {
    retrieveData().then((value) => populateWidget());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            title: Text("Archivos guardados"),
            backgroundColor: Colors.lightBlueAccent),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: new ListView(
            children: <Widget>[
              Material(
                type: MaterialType.transparency,
                child: ListTile(
                    enabled: true,
                    title: Text('Nuevo'),
                    subtitle: Text('Crear nuevo proyecto.'),
                    leading: Icon(Icons.add),
                    onTap: _addFile),
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    return files[index];
                  })
            ],
          ),
        ));
  }

  ListTile fileTile(String titulo) {
    return ListTile(
      title: Text(titulo),
      trailing: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.lightBlueAccent,
          padding: const EdgeInsets.all(15),
        ),
        child: Icon(Icons.delete),
        onPressed: () => deleteFile(titulo),
      ),
      leading: Icon(Icons.arrow_right_outlined),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return MenuText(titulo);
          }),
        );
      },
    );
  }

  void _addFile() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Nuevo proyecto'),
        content: const Text('Nombre del nuevo proyecto'),
        actions: <Widget>[
          TextFormField(
            controller: _Controller,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: _newState,
                child: const Text('OK'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> retrieveData() async {
    final SharedPreferences prefs = await _prefs;
    nombres = prefs.getStringList("Archivos") ?? [];
  }

  Future<void> saveData() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("Archivos", nombres);
  }

  void populateWidget() {
    files = [];
    setState(() {
      for (var item in nombres) {
        files.add(Material(
          type: MaterialType.transparency,
          child: fileTile(item),
        ));
      }
    });
  }

  void _newState() {
    nombres.add(_Controller.text);
    saveData();
    Navigator.pop(context, 'OK');
    setState(() {
      files.add(Material(
        type: MaterialType.transparency,
        child: fileTile(_Controller.text),
      ));
      count += 1;
    });
  }

  void deleteFile(String name) {
    nombres.remove(name);
    populateWidget();
    saveData();
  }
}
