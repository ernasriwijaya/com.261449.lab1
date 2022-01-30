import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



void main() => runApp(const MyApp(title: 'CurrencyConverter',));

class MyApp extends StatelessWidget{
  const MyApp({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("",
          style: TextStyle (fontSize: 30, color: Colors.blue[600], fontWeight: FontWeight.bold)),
        ),
        body: const Center (child: HomePage()),
      ));
  }
}

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);
 
  @override
  _HomePageState createState() => _HomePageState();

} 

class _HomePageState extends State<HomePage> {
  var rate = 0.0;
  TextEditingController textEditingController = TextEditingController();
  String selectLoc1 = "MYR";
  String selectLoc2 = "JPY";
   List<String> loclist = [
     "MYR",
     "JPY",
     "KRW",
     "HKD",
     "USD"
   ];
  String _value = "";
  double num = 0.0, result = 0.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.5),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Image.asset('assets/images/CURRENCYCONVERTER.png', 
          height: 200, 
          width: 500,),
          const SizedBox(height: 10),
          TextField(controller: textEditingController, decoration: InputDecoration(
            hintText: 'Enter Value',
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.5)),),
            keyboardType: const TextInputType.numberWithOptions(),),
          const SizedBox(height: 18),
          Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:[
          DropdownButton(
              itemHeight: 60,
              value: selectLoc1,
              onChanged: (newValue){
                setState((){
                  selectLoc1 = newValue.toString();
                });
              },
              items: loclist.map((selectLoc1){
                return DropdownMenuItem(
                  child : Text(
                    selectLoc1,
                  ),
                value: selectLoc1,
                );
              }).toList(),
          ),
          FloatingActionButton(
            onPressed: (){
              String temp = selectLoc1;
              setState (() {
                selectLoc1 = selectLoc2;
                selectLoc2 = temp;
              });
            },
            child: const Icon(Icons.swap_horiz),
            elevation: 0.0, 
            backgroundColor: Colors.blue,
            ),
          DropdownButton(
              itemHeight: 60,
              value: selectLoc2,
              onChanged: (newValue){
                setState((){
                  selectLoc2 = newValue.toString();
                });
              },
              items: loclist.map((selectLoc2){
                return DropdownMenuItem(
                  child : Text(
                    selectLoc2,
                  ),
                value: selectLoc2,
                );
              }).toList(),
          ),
          ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(onPressed: _result, child: const Text("Convert")),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(5),
            width: 300.0,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              const Text("Result",
                style: TextStyle (fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_value, 
                style: const TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold)),     
          ],),
          color: Colors.white,
        ),
        ]
    ),
  )
  );
}
Future <void> _result() async {
  var apiid ="6a7bb8a0-3e4a-11ec-b3c7-a3378bee28d4";
  var url = Uri.parse(
    'https://freecurrencyapi.net/api/v2/latest?apikey=$apiid&base_currency=$selectLoc1');
  var response = await http.get(url);
    var rescode = response.statusCode;
    if(rescode == 200){
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      rate = parsedJson['data'][selectLoc2];
      num = double.parse(textEditingController.text);
      result = num * rate;

      setState((){
        switch (selectLoc2) {
          case "MYR":
            _value = "RM " + result.toStringAsFixed(2);
            break;
          case "JPY":
            _value = "¥ " + result.toStringAsFixed(2);
            break;
          case "KRW":
            _value = "₩ " + result.toStringAsFixed(2);
            break;
          case "HKD":
            _value = "HK\$ " + result.toStringAsFixed(2);
            break;
          case "USD":
            _value = "US\$ " + result.toStringAsFixed(2);
            
          }
      });
    }
  }
}