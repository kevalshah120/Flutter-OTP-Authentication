import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class WatchlistScreen extends StatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<String> stocks = ['Y', 'GOOGL', 'MSFT', 'AMZN'];
  Map<String, double> prices = {}; // Map to store prices for each stock
  Map<String, double> changes = {}; // Map to store changes for each stock

  int selectedIndex = -1;
  bool isContainerVisible = false;
  String selectedStock = '';

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    for (String stock in stocks) {
      String apiUrl =
          '';
      try {
        http.Response response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          if (data.containsKey('Global Quote')) {
            String priceString = data['Global Quote']['05. price'];
            double latestPrice = double.parse(priceString);
            String changePercentString = data['Global Quote']['10. change percent'];
            double priceChangePercentage = double.parse(changePercentString.replaceAll('%', ''));
            setState(() {
              prices[stock] = latestPrice;
              changes[stock] = priceChangePercentage;
            });
          } else {
            print('Global Quote data not found for $stock');
          }
        } else {
          print('Failed to fetch data for $stock: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching data for $stock: $e');
      }
    }
  }

  void toggleContainerVisibility(int index) {
    setState(() {
      if (selectedIndex == index) {
        isContainerVisible = !isContainerVisible;
      } else {
        selectedIndex = index;
        isContainerVisible = true;
        selectedStock = stocks[index]; // Update selected stock
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(231, 231, 231, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(231, 231, 231, 1),
        centerTitle: true,
        title: Text(
          'TRACCIA',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Color.fromARGB(255, 155, 255, 124),
              margin: EdgeInsets.only(top: 30),
              height: 125,
              child: Text("My Watchlist", style: TextStyle(fontSize: 20)),
            ),
            ListTile(
              title: Text('My Watchlist(40)'),
              onTap: () {
                // Navigate to desired page
              },
            ),
            ListTile(
              title: Text('My Position(0)'),
              onTap: () {
                // Navigate to desired page
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Text as Watchlist',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(31, 25, 25, 25),
                        blurRadius: 3.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search & Add Stocks',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                    style: TextStyle(color: const Color.fromARGB(255, 7, 7, 7)),
                    cursorColor: const Color.fromARGB(255, 44, 43, 43),
                    onTap: () {
                      Navigator.pushNamed(context, '/searchScreen');
                    }
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: stocks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    toggleContainerVisibility(index);
                  },
                  child: Container( // Wrap ListTile with Container
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5), // Add a bottom border
                      ),
                    ),
                    child: Card(
                      elevation: 0.5,
                      color: Colors.white,
                      margin: EdgeInsets.all(0),
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                stocks[index],
                                style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${prices[stocks[index]]?.toStringAsFixed(2) ?? '0.00'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (prices[stocks[index]] ?? 0) > 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                                Text(
                                  '${changes[stocks[index]]?.toStringAsFixed(2) ?? '0.00'}%',
                                  style: TextStyle(
                                    color: (changes[stocks[index]] ?? 0) > 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: isContainerVisible ? 200 : 0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 54, 55, 56),
              borderRadius: isContainerVisible
                  ? BorderRadius.vertical(top: Radius.circular(20))
                  : BorderRadius.zero,
            ),
            child: Center(
              child: Text(
                selectedStock,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WatchlistScreen(),
  ));
}