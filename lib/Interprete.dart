import 'models.dart';
import 'Funciones.dart';
import 'Procesa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Interprete extends StatefulWidget {
  Interprete({Key? key}) : super(key: key);
  @override
  _Interprete createState() => _Interprete();
}

class _Interprete extends State<Interprete> {
  String dato = "", dropdownValue = 'Función';
  List<String> objeto = [],
      items = ["Función", "Tabula", "Gráfica", "Evalúa", "Divide", "Raiz"];
  List<Widget> dato_pantalla = [];
  packages? _character = packages.Funciones;

  final analiza = Separa(), formatos = Formato();
  var _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Interprete"), backgroundColor: Colors.lightBlueAccent),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.arrow_forward_ios_rounded),
            backgroundColor: Colors.lightBlueAccent,
            onPressed: ejecuta),
        drawer: DrawerContent(),
        body: Body()
    );
  }
  Container DrawerContent(){
    return Container(
      width: MediaQuery.of(context).size.width*0.5,
      child: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent
          ),
          child: Drawer(
            child: new ListView(
              children: <Widget>[
                DrawerHeader(
                    child: Column(
                      children: [
                        Text(
                            "Comandos",
                            style: TextStyle(fontSize: 24, color: Colors.white)
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              value: dropdownValue,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: items.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(color: Colors.white, fontSize: 12))
                                );
                              }).toList(),
                            ),
                            TextButton(
                              onPressed: addHint,
                              child: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
                            ),
                          ],
                        )

                      ],
                    )
                ),
                /*
                Text("  Paquetes", style: TextStyle(color: Colors.white, fontSize: 24),),
                RButton(packages.Funciones, "Funciones"),
                RButton(packages.Algebra, "Álgebra"),
                RButton(packages.ALineal, "Álgebra lineal"),
                RButton(packages.Calculo, "Cálculo"),
                */
              ],
            ),
          )
      ),
    );
  }
  ListTile RButton(packages pack, String content){
    return ListTile(
      title:  Text(content, style: TextStyle(color: Colors.white),),
      leading: Radio<packages>(
        value: pack,
        groupValue: _character,
        onChanged: (packages? value) {
          setState(() {
            _character = value;
          });
        },
      ),
    );
  }
  Container Body(){
    return Container(
        decoration: BoxDecoration(color: Colors.black),
        child: new ListView(
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: ">",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                suffixIcon: IconButton(
                    color: Colors.lightBlueAccent,
                    onPressed: _controller.clear,
                    icon: Icon(Icons.clear)),
              ),
            ),
            ListView.builder(
                reverse: true,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: dato_pantalla.length,
                itemBuilder: (context, index) {
                  return dato_pantalla[index];
                })
          ],
        ));
  }

  void ejecuta() {
    dato = _controller.text;
    objeto = analiza.getItem(dato.replaceAll(" ", ""));
    if (objeto[0] == "graph") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightBlueAccent,
              title: Text("Gráfica"),
            ),
            backgroundColor: Colors.black,
            body: formatos.formatGraph(objeto),
          );
        }),
      );
    }
    String imprime = formatos.Soluciona(objeto);
    setState(() {
      dato_pantalla.add(Container(
        child: Text(
          imprime,
          textAlign: TextAlign.justify,
          style: TextStyle(color: Colors.white),
        ),
      ));
    });
  }

  void addHint(){
    String entry = dropdownValue;
    if(entry == "Función"){
      _controller.text = "<funct> f ";
    }
    else if (entry == "Tabula"){
      _controller.text = "<tab, rango=[a:b], paso=i> f ";
    }
    else if (entry == "Gráfica"){
      _controller.text = "<graph, rango=[a:b], paso=i> f ";
    }
    else if (entry == "Evalúa"){
      _controller.text = "<eval, x0=a> f ";
    }
    else if (entry == "Divide"){
      _controller.text = "<divide> p(x)/a ";
    }
    else if (entry == "Raiz"){
      _controller.text = "<raiz, aprox=x0> f ";
    }
  }

}
