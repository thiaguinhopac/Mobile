import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=cc6d8ca2";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),

  ));


}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dolar;
  double bitcoin;

  double dolarCot;
  double bitcoinCot;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    bitcoinController.text = (real / bitcoin).toStringAsFixed(5);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    bitcoinController.text = (dolar * this.dolar / bitcoin).toStringAsFixed(5);
  }

  void _bitcoinChanged(String text) {
    double bitcoin = double.parse(text);
    dolarController.text = (bitcoin * this.bitcoin / dolar).toStringAsFixed(2);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando Dados",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao Carregar Dados",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  bitcoin =
                      snapshot.data["results"]["currencies"]["BTC"]["buy"];

                  dolarCot = snapshot.data["results"]["currencies"]["USD"]
                      ["variation"];
                  bitcoinCot = snapshot.data["results"]["currencies"]["BTC"]
                      ["variation"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.amber),
                          Row(
                            children: <Widget>[
                              Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    "Moeda",
                                    style: TextStyle(
                                        color: Colors.amber, fontSize: 25.00),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Text(
                                    "USD",
                                    style: TextStyle(
                                        color: Colors.amber, fontSize: 20.00),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Text(
                                    "BTC",
                                    style: TextStyle(
                                        color: Colors.amber, fontSize: 20.00),
                                  ),
                                ),
                              ]),
                              Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        "Variaçao",
                                        style: TextStyle(
                                            color: Colors.amber, fontSize: 25.00),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(13.0),
                                      child: variacolor(dolarCot),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(13.0),
                                      child: variacolor(bitcoinCot),
                                    ),
                                  ]),
                              Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets. all(15.0),
                                      child: Text(
                                        "Preço",
                                        style: TextStyle(
                                            color: Colors.amber, fontSize: 25.00),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(13.0),
                                      child:  Text(
                                        "\$ ${dolar.toString().substring(0, dolar.toString().indexOf(".") + 3)}",
                                        style: TextStyle(
                                            color: Colors.amber, fontSize: 20.00),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(13.0),
                                      child:  Text(
                                        "\$ ${bitcoin.toString().substring(0, bitcoin.toString().indexOf(".") + 3)}",
                                        style: TextStyle(
                                            color: Colors.amber, fontSize: 20.00),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                          Divider(),
                          buildTextField(
                              "Reais", "R\$ ", realController, _realChanged),
                          Divider(),
                          buildTextField(
                              "Dolar", "USD ", dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Bitcoin", "BTC ", bitcoinController,
                              _bitcoinChanged),
                        ]),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController textEditingController, Function function) {
  return TextField(
    controller: textEditingController,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: function,
    keyboardType: TextInputType.number,
  );

}

Text variacolor(double valueCot){
  if(valueCot < 0.0){
    return Text(
      "$valueCot",
      style: TextStyle(
          color: Colors.red, fontSize: 20.00),
    );
  }else if(valueCot > 0.0){
    return Text(
      "$valueCot",
      style: TextStyle(
          color: Colors.green, fontSize: 20.00),
    );
  }else{
    return Text(
      "$valueCot",
      style: TextStyle(
          color: Colors.white, fontSize: 20.00),
    );
  }
}
