import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResults = []; // Change type to dynamic

  final String apiKey = 'Your_API_Key';

  Future<void> searchStocks(String keywords) async {
    String apiUrl =
        'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$keywords&apikey=$apiKey';

    try {
      http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = jsonDecode(response.body);
          if (data.containsKey('bestMatches')) {
            searchResults = data['bestMatches']; // Assign dynamic list
          } else {
            searchResults = [];
          }
        });
      } else {
        print('Failed to search stocks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching stocks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            searchStocks(value);
          },
          decoration: InputDecoration(
            hintText: 'Search Stocks',
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: TextField(
          //     onChanged: (value) {
          //       searchStocks(value);
          //     },
          //     decoration: InputDecoration(
          //       hintText: 'Search Stocks',
          //       suffixIcon: Icon(Icons.search),
          //     ),
          //   ),
          // ),

          //if length is 0 then opens most searched
          searchResults.length > 0
              ? Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: InkWell(
                    child: Icon(CupertinoIcons.add_circled),
                    onTap: () {
                      saveToSharedPreferences(
                          searchResults[index]['1. symbol']);
                    },
                  ),
                  title: Text(searchResults[index]
                  ['1. symbol']), // Access symbol key
                );
              },
            ),
          )
              : Container()
        ],
      ),
    );
  }
}
Future<void> saveToSharedPreferences(String symbol) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve existing data or create an empty list
  List<String> savedSymbols = prefs.getStringList('savedSymbols') ?? [];

  // Add the new symbol to the list
  savedSymbols.add(symbol);

  // Save the updated list back to SharedPreferences
  await prefs.setStringList('savedSymbols', savedSymbols);
}
