class Matrices{
  String Invierte(String dato) {
    String salida = "";
    for (var item in intercambio(toMatrix(dato))) {
      salida += item.toString() + "\n";
    }
    return salida;
  }

  List<dynamic> toMatrix(String data) {
    var matx = data.split(";");
    var matrix = [];
    for (var item in matx) {
      var temp = item.split(",");
      var aux = [];
      for (var item in temp) {
        aux.add(num.parse(item));
      }
      matrix.add(aux);
    }
    return matrix;
  }

  int pivote(List<dynamic> fila) {
    var k = [];
    for (var item in fila) {
      k.add(item.abs());
    }
    return k.indexOf(max(k));
  }

  num max(List<dynamic> data) {
    num largestData = data[0];
    for (var i = 0; i < data.length; i++) {
      if (data[i] > largestData) {
        largestData = data[i];
      }
    }
    return largestData;
  }

  List<dynamic> intercambio(A) {
    // Invierte la matriz
    int dimension = A.length;
    List<int> dim = [for (var i = 0; i < dimension; i++) i];
    List<int> usados = [for (var i = 0; i < dimension; i++) i];
    List<int> iterable = [for (var i = 0; i < dimension; i++) i];
    List<int> orden = [], pivotes = [];
    int j = 0;
    for (var i in dim) {
      j = pivote(A[i]);
      if (usados.contains(j)) {
        usados.remove(j);
      } else {
        j = usados.last;
        if (A[i][j] == 0) {
          j = usados[dimension - 2];
        }
        usados.remove(j);
      }
      orden.add(j);
      pivotes.add(i);
      // Paso uno
      for (var x in dim) {
        if (x != j) {
          A[i][x] /= -A[i][j];
        }
      }

      // Paso dos
      for (var x in dim) {
        for (var y in dim) {
          if (x != i && y != j) {
            A[x][y] += A[i][y] * A[x][j];
          }
        }
      }
      // Paso tres
      for (var x in dim) {
        if (x != i) {
          A[x][j] /= A[i][j];
        }
      }
      // Paso cuatro
      A[i][j] = 1 / A[i][j];
    }
    // Ordenamiento de la matriz
    List<int> bypass = [];
    for (var x in orden) {
      bypass.add(x);
    }
    for (var xLast in [for (var i = orden.length - 1; i < 0; i--) i]) {
      for (var i in [for (var i = 0; i < xLast; i++) i]) {
        if (orden[i] > orden[i + 1]) {
          int temp = orden[i];
          orden[i + 1] = temp;
          int temp2 = pivotes[i];
          pivotes[i] = pivotes[i + 1];
          pivotes[i + 1] = temp2;
        }
      }
    }
    var pre = [];
    for (var vector in A) {
      var temp = [];
      for (var i in iterable) {
        temp.add(num.parse(vector[bypass[i]].toStringAsFixed(6)));
      }
      pre.add(temp);
    }

    var MI = [];
    for (var i in iterable) {
      MI.add(pre[pivotes[i]]);
    }

    return MI;
  }
}

/*
 String formatInvierte(String entrada){
  try{
    var matrix = toMatrix(entrada);
    if(matrix[0].length != matrix.length) return "La matriz no es cuadrada";
    String salida = "Inversa de $matrix: \n";
    return salida + Invierte(entrada);
  }
  catch(e){
    return "Formato correcto:<invierte>a,b,...;c,d,...;...\n$e";
  }
}
*/