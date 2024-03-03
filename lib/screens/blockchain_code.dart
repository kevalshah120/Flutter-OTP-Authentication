import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_otp_module/services/function.dart';
import 'package:flutter_otp_module/screens/constant.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
Web3Client? ethClient;
class _HomeState extends State<Home> {
  Client? httpClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Election'),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  filled: true, hintText: 'Enter election name'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {

                },
                child: Text('Start Election'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
