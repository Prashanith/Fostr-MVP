import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fostr/core/settings.dart';

Future<String> getToken(String channelName) async {
  print("inside");
  final response = await http.get(
    Uri.parse(baseUrl + channelName),
  );

  print("response.statusCode"+ response.statusCode.toString());
  if (response.statusCode == 200) {
    print("response.body");
    print(response.body);
    token = response.body;
    token = jsonDecode(token)['token'];
  } else {
    print('Failed to fetch the token');
  }
  return token;
}