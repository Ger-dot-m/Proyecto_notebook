class Separa {
  List<int> etiqueta(String entrada, String llave0, String llave1) {
    for (int i = 0; i < entrada.length; i++) {
      if (entrada[i] == llave0) {
        for (int j = i; i < entrada.length; j++) {
          if (entrada[j] == llave1) {
            return [i + 1, j];
          }
        }
      }
    }
    return [-1];
  }

  List<String> getItem(String entrada, {String llave0 = "<", String llave1 = ">"}) {
    int len = entrada.length;
    String aux;
    List<String> salida;
    List<int> obtiene = etiqueta(entrada, llave0, llave1);
    try{
      int i = obtiene[0], j = obtiene[1];
      aux = entrada.substring(i, j);
      salida = aux.split(",");
      salida.add(entrada.substring(j + 1, len));
      return salida;
    }catch(e){ return ["otro", entrada];}
  }
  List<String> getStatments(String entrada){
    List<String> objetos = entrada.split("<");
    for(int i = 0; i < objetos.length; i++){
      objetos[i] = "<"+objetos[i];
    }
    return objetos.sublist(1);
  }

}

