import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_otp_module/screens/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import '../services/function.dart';
import 'mylist.dart';
// Define BuyPopup widget
class BuyPopup extends StatefulWidget {
  final String selectedStock;
  final double sharePrice;
  final String action;

  BuyPopup(
      {required this.selectedStock,
        required this.sharePrice,
        required this.action});

  @override
  _BuyPopupState createState() => _BuyPopupState();
}

class _BuyPopupState extends State<BuyPopup> {
  TextEditingController quantityController = TextEditingController();
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    quantityController.addListener(calculateTotalAmount);
  }

  @override
  void dispose() {
    quantityController.removeListener(calculateTotalAmount);
    quantityController.dispose();
    super.dispose();
  }

  void calculateTotalAmount() {
    setState(() {
      int quantity = int.tryParse(quantityController.text) ?? 0;
      totalAmount = widget.sharePrice * quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.action} Shares'),
      backgroundColor:
      Colors.white, // Set the background color of the AlertDialog
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Stock: ${widget.selectedStock}'),
          SizedBox(height: 10),
          Text('Share Price: \₹${widget.sharePrice.toStringAsFixed(2)}'),
          SizedBox(height: 10),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.grey[200], // Set background color
              // Add an icon
              hintText: 'Enter quantity', // Placeholder text
              hintStyle: TextStyle(
                  color: Color.fromARGB(
                      255, 75, 74, 74)), // Color of placeholder text
            ),
            style: TextStyle(color: Colors.black), // Text color
          ),
          SizedBox(height: 10),
          Text('Total Amount: \₹${totalAmount.toStringAsFixed(2)}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            String quantity = quantityController.text;
            print('Quantity: $quantity, Total Amount: $totalAmount');
            buyStock("lala",40,600,ethClient!);
          },
          child: Text(
            '${widget.action}',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          style: ButtonStyle(
            backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.green),
          ),
        ),
      ],
    );
  }
}
class WatchlistScreen extends StatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}
Web3Client? ethClient;
class _WatchlistScreenState extends State<WatchlistScreen> {
  List<String> stocks = ['RELIANCE.BSE', 'TATAMOTORS.BSE', 'YESBANK.BSE', 'TATAPOWER.BSE', 'AZAD.BSE', 'HGINFRA.BSE','IRCON.BSE','IIFL.BSE','MAZDOCK.BSE','JKPAPER.BSE','LIKHITHA.BSE','GEPIL.BSE'];
  Map<String, double> prices = {}; // Map to store prices for each stock
  Map<String, double> changes = {}; // Map to store changes for each stock
  Client? httpClient;
  int selectedIndex = -1;
  bool isContainerVisible = false;
  String selectedStock = '';

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    for (String stock in stocks) {
      String apiUrl =
          'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$stock&apikey=NYI9LCVLHOLYA8R5';
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
        centerTitle: false,
        title: Text(
          'MY Watchlist',
          style: GoogleFonts.lato(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(),
              child: Center(
                child: Text(
                  'TRACCIA',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WatchlistScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.remove_red_eye_outlined),
              title: Text('My Watchlist'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WatchListScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () async {
                await logout(context);
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
                // SizedBox(height: 16),
                // Text(
                //   'Text as Watchlist',
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
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
                                  '${prices[stocks[index]]?.toStringAsFixed(2) ?? '0.00'}',
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
              color: Colors.white,
              borderRadius: isContainerVisible
                  ? BorderRadius.vertical(top: Radius.circular(20))
                  : BorderRadius.zero,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0), // Adjusted padding
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedStock,
                            style: TextStyle(
                              fontFamily: 'RobotoMono',
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        if (stocks.contains(selectedStock) && stocks.indexOf(selectedStock) < prices.length)
                          Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text(
                              '${prices[stocks.indexOf(selectedStock)]?.toStringAsFixed(2) ?? 'N/A'}',
                              style: TextStyle(
                                fontFamily: 'RobotoMono',
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                                color: (prices[stocks.indexOf(selectedStock)] ?? 0) < 0 ? Colors.red : Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      "VALUE",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 10), // Add some space below the selected stock
                  Divider(color: Colors.grey), // Horizontal line
                  SizedBox(height: 10), // Add some space
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.0),
                          height: 45,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors
                                .blue, // Set background color for the first container
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Center(
                            child: Text(
                              'BUY',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BuyPopup(
                                selectedStock: selectedStock,
                                sharePrice: prices[selectedStock] ?? 0.0,
                                action: 'Buy',
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(width: 16), // Add some space between buttons
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.0),
                          height: 45,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors
                                .red, // Set background color for the second container
                            borderRadius: BorderRadius.circular(1),
                          ),
                          child: Center(
                            child: Text(
                              'SELL',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'RobotoMono',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BuyPopup(
                                selectedStock: selectedStock,
                                sharePrice: prices[selectedStock] ?? 0.0,
                                action: 'Sell',
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();

    // Clear user session
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Clear additional data (replace 'savedSymbols' with your actual key)
    await prefs.remove('savedSymbols');

    Navigator.pushReplacementNamed(context, '/login');
  } catch (e) {
    print('Error during logout: $e');
  }
}
void main() {
  runApp(MaterialApp(
    home: WatchlistScreen(),
  ));
}