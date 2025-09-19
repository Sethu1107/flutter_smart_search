import 'package:flutter/material.dart';
import 'package:flutter_smart_search/flutter_smart_search.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final List<String> fruits =["Apple", "Banana", "Mango", "Orange","Kiwi"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Smart Search Example")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SmartSearchField<String>(
            hintText: "Search fruits",
            fetchSuggestions: (query) async {
              return fruits;
            },
            displayStringForOption: (item) => item,
            onSelect: (item) {
              debugPrint("Selected: $item");
            },
           isSort:false,isFilter:false,
            itemBuilder:(e,index)=>Padding(
              padding: EdgeInsets.only(left:8.0),
              child: Text(e),
            ),
          ),
        ),
      ),
    );
  }
}
