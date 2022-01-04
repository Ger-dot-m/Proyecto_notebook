import 'package:math_expressions/math_expressions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'Procesa.dart';

List<dynamic> memoria = [];

class Funciones {
  Parser p = Parser();
  Variable x = Variable('x');
  ContextModel cm1 = ContextModel();
  ContextModel cm2 = ContextModel();

  String aritmetica(entrada){
    Expression f = p.parse(entrada);
    cm1.bindVariable(x, Number(0));
    num out = f.evaluate(EvaluationType.REAL, cm1);
    return "$entrada = $out";
  }

  String Raiz(Expression dato, {num x0 = 0}) {
    num raiz = secante(dato, x0, x0 + 1);
    return "$raiz";
  }

  String Division(String dato) {
    List<String> sub_dato = dato.split("/");
    List<String> _coef = sub_dato[0].split(",");
    List<num> coef = [];
    num y = num.parse(sub_dato[1]);
    int size = _coef.length;
    for (int i = 0; i < size; i++) {
      coef.add(num.parse(_coef[i]));
    }
    for (int i = 1; i < size; i++) {
      coef[i] += coef[i - 1] * y;
    }
    for (int i = 0; i < size; i++) {
      _coef[i] = coef[i].toString();
    }
    return "$_coef";
  }

  num secante(Expression f, num x0, num x1) {
    num E = 0.00001, error = 1, xn = 0;
    while (error > E) {
      cm1.bindVariable(x, Number(x0));
      cm2.bindVariable(x, Number(x1));
      try {
        xn = x1 -
            f.evaluate(EvaluationType.REAL, cm2) *
                (x1 - x0) /
                (f.evaluate(EvaluationType.REAL, cm2) -
                    f.evaluate(EvaluationType.REAL, cm1));
      } catch (e) {
        break;
      }
      try {
        error = ((xn - x1) / xn).abs();
      } catch (e) {
        break;
      }
      x0 = x1;
      x1 = xn;
    }
    return xn;
  }

  String eval(Expression f, num x0,{int fixed=6}) {
    cm1.bindVariable(x, Number(x0));
    num out = f.evaluate(EvaluationType.REAL, cm1);
    return  out.toStringAsFixed(fixed);
  }

  List<Funcion> pre_graph(Expression f, {double x0 = -1, double x1 = 1, double paso = 0.5}){
    int decimales = 4;
    ContextModel cm1 = ContextModel();
    Variable x = Variable('x');
    List<Funcion> data = [];

    var imagen;
    for(double i = x0; i <= x1; i+=paso){
      cm1.bindVariable(x, Number(i));
      imagen = f.evaluate(EvaluationType.REAL, cm1);
      String _imagen = imagen.toString();
      if(_imagen == "Infinity" || _imagen == "NaN"){
        data.add(Funcion( null, null));
      }
      else{
        imagen = num.parse(imagen.toStringAsFixed(decimales));
        data.add(Funcion(i, imagen));
      }
    }
    return data;
  }

  SfCartesianChart graph(Expression f, {double x0 = -1, double x1 = 1, double paso = 0.5}){
    List<Funcion> data = pre_graph(f, x0:-1,  x1:1, paso:0.5);

    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(
            text: 'y =' + f.toString(),
            textStyle: TextStyle(color: Colors.white)
        ),
        series: <ChartSeries<Funcion, num>>[
          SplineSeries<Funcion, num>(
            emptyPointSettings: EmptyPointSettings(
                mode: EmptyPointMode.gap
            ),
            dataSource: data,
            xValueMapper: (Funcion sales, _) => sales.x,
            yValueMapper: (Funcion sales, _) => sales.y,
          )
        ]
    );
  }
}

class Formato extends Funciones{
  List<String> methods = ["raiz", "divide", "funct", "var", "eval", "tab", "graph"];
  void toMemory(String entrada) {
    var s = entrada.replaceAll(" ", "").split("=");
    memoria.add([s[0], p.parse(s[1])]);
  }

  int findInMemory(String id){
    for (int i = 0; i < memoria.length; i++) {
      if (memoria[i][0] == id) {
        return i;
      }
    }
    return -1;
  }
  List<double> getRange(String item){
    final separa = Separa();
    List<String> aux = separa.getItem(item,llave0: "[",llave1: "]")[0].split(":");
    return [double.parse(aux[0]), double.parse(aux[1])];
  }

  String formatRaiz(List<String> objeto){
    String entrada = objeto.last, salida;
    try{
      int pos = findInMemory(entrada.split(",")[0]);
      var funcion = memoria[pos][1];
      if(objeto[0].contains("aprox=")){
        num x0 = num.parse(objeto[0].replaceAll("aprox=", ""));
        salida = Raiz(funcion, x0:x0);
      } else salida = Raiz(funcion);
      return "Raiz de " + entrada + ": " + salida;

    }catch(e){
      return "Formato correcto: <raiz,aprox=x0>función\n$e";
    }
  }

  String formatDivide(String entrada){
    try{
      return "Division de $entrada: " + Division(entrada);
    }
    catch(e){
      return "Formato correcto: <divide>a,b,...,n / valor\n$e";
    }
  }

  String formatFunct(String entrada){
    try {
      toMemory(entrada);
      return "Función $entrada declarada.";
    } catch (e) {
      return "$e";
    }
  }

  Widget formatGraph(List<String> objeto){
    String entrada = objeto.last;
    double x0 = -1, x1 = 1, i = 0.5;
    objeto = objeto.sublist(1,objeto.length-1);
    for(var item in objeto){
      if(item.contains("rango=")){
        item.replaceAll("rango=", "");
        x0 = getRange(item)[0];
        x1 = getRange(item)[1];
      }
      else if (item.contains("paso=")){
        i = double.parse(item.replaceAll("paso=", ""));
      }
    }
    int pos = findInMemory(entrada);
    var funcion = memoria[pos][1];
    return graph(funcion, x0: x0, x1: x1, paso:i);
  }

  String formatEval(List<String> objeto){
    String entrada = objeto.last, salida; num x0;
    try{
      int pos = findInMemory(entrada.split(",")[0]);
      var funcion = memoria[pos][1];
      if(objeto[0].contains("x0=")){
        x0 = num.parse(objeto[0].replaceAll("x0=", ""));
        salida = eval(funcion, x0);
      } else return "Formato correcto: <eval,x0=a>funcion";
      return entrada + "($x0) = " + salida;
    }catch(e){
      return "Formato correcto: <eval,x0=a>funcion\n$e";
    }

  }

  String formatTab (List<String> objeto){
    try{
      String entrada = objeto.last, salida = "x0${" "*6}|   f(x0)\n", value;
      int pos = findInMemory(entrada), whitespaces;
      var funcion = memoria[pos][1];
      double x0 = -1, x1 = 1, i = 0.5;
      objeto = objeto.sublist(0,objeto.length-1);
      print(objeto);
      for(var item in objeto){

        if(item.contains("rango=")){
          item.replaceAll("rango=", "");
          x0 = getRange(item)[0];
          x1 = getRange(item)[1];
        }
        else if (item.contains("paso=")){
          i = double.parse(item.replaceAll("paso=", ""));
        }
      }
      for(x0; x0<=x1; x0+=i){
        whitespaces = x0.toString().length;
        value = eval(funcion, x0);
        salida += x0.toStringAsFixed(6)+"${" "*(8-whitespaces)}|   $value"+"\n";
      }
      return salida;
    }
    catch(e){
      return "Formato correcto: <tab,rango=[a:b],paso=i>funcion\n$e";
    }

  }

  String Soluciona(List<String> objeto){
    final formato = Formato();
    String tipo = objeto[0], entrada = objeto.last;
    objeto = objeto.sublist(1);

    if (tipo == "raiz")          return formatRaiz(objeto);
    else if (tipo == "divide")   return formatDivide(entrada);
    else if (tipo == "funct")    return formatFunct(entrada);
    else if (tipo == "eval")     return formatEval(objeto);
    else if (tipo == "tab")      return formatTab(objeto);
    else if (tipo == "graph")    return "Gráfica de $entrada";
    else {
      try {
        return formato.aritmetica(entrada);
      } catch (e) {
        return "$e for the label: $tipo.\n$entrada";
      }
    }}
}

class Funcion{
  Funcion(this.x, this.y);
  final num? x;
  final num? y;
}
