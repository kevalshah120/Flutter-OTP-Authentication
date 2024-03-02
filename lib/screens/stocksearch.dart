import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        title: Text('Search Stocks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                searchStocks(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Stocks',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]['1. symbol']), // Access symbol key
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
