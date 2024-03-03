import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: FutureBuilder<List<String>>(
        future: getSavedSymbols(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<String> savedSymbols = snapshot.data ?? [];
            return ListView.builder(
              itemCount: savedSymbols.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(savedSymbols[index]),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String>> getSavedSymbols() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('savedSymbols') ?? [];
  }
}