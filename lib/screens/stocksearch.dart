import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
                        trailing: Icon(CupertinoIcons.add_circled),
                        title: Text(searchResults[index]
                            ['1. symbol']), // Access symbol key
                      );
                    },
                  ),
                )
              : Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        "Most searched",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TATA MOTORS",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "RELIENCE",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "ICICIBANK",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "SBIN",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "NIFTY",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "ITC",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "SENSEX",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "TATASTEEL",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "AXISBANK",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
