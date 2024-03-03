import 'package:flutter/services.dart';
import 'package:flutter_otp_module/screens/constant.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contact_Address;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String funcname, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}

Future<String> buyStock(String name,int price,int data, Web3Client ethClient) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(owner_private_key);
  DeployedContract contract = await loadContract();
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function('buyStock'),
        parameters: ['Lala',BigInt.from(1100),BigInt.from(100)],
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  print(result);
  return result;
}
Future<String> sellStock(String name,int price,int data, Web3Client ethClient) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(owner_private_key);
  DeployedContract contract = await loadContract();
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function('buyStock'),
        parameters: [name,BigInt.from(price),BigInt.from(data)],
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  print(result);
  return result;
}

