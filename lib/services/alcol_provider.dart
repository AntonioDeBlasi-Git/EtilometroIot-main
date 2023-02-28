import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/utils/alcol_item.dart';
import 'package:http/http.dart' as http;

class AlcolProvider with ChangeNotifier {
  List<AlcolItem> _items = [];
  final url = 'https://alcol.carminezacc.com/alcol';

  List<AlcolItem> get items {
    return [..._items];
  }

  //The method receives the name of the item to be created and uses this value to construct the request payload for adding a new AlcolItem to the server
  Future<void> addItem(String value, String createdAt, double? latitude,
      double? longitude) async {
    if (value.isEmpty) {
      return;
    }

    Map<String, dynamic> request = {
      "data": value,
      "createdAt": createdAt,
      "latitude": latitude,
      "longitude": longitude
    };
    final headers = {'Content-Type': 'application/json'};
    //The json.encode operation formats the request map to a JSON body so that it is compatible with the format and structure that the server expects
    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(request));
    Map<String, dynamic> responsePayload = json.decode(response.body);
    final alcol = AlcolItem(
        id: responsePayload["id"],
        itemName: responsePayload["data"],
        createdAt: DateTime.parse(responsePayload["createdAt"]),
        latitude: responsePayload["latitude"],
        longitude: responsePayload["longitude"]);
    _items.add(alcol);

    //The server automatically creates an ID for the newly created AlcolItem and returns it as part of the response body. The values of the JSON body
    //are unmarshalled into the Flutter AlcolItem object and added to the _items list. The notifyListeners() method from the ChangeNotifierclass
    //notifies all the listeners of the state of the application about the new AlcolItem addition.
  }

  //method for fetching all the AlcolItem enteties from the backend
  //asynchronously sends a GET request to the backend server to fetch all the created AlcolItem entities as a JSON list.
  //Then it iterates through the response body to unmarshal the values into AlcolItem objects.
  Future<void> get getAllItems async {
    var response;
    try {
      response = await http.get(Uri.parse(url));
      List<dynamic> body = json.decode(response.body);
      _items = body
          .map((e) => AlcolItem(
              id: e['id'],
              itemName: e['data'],
              createdAt: AlcolItem.StringToDate(e['createdAt']),
              latitude: e['latitude'],
              longitude: e['longitude']))
          .toList();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  //The deleteTodo method is responsible for deleting the TodoItem entity in the
  // database and in the Flutter app. It performs this operation by making an HTTP DELETE
  //request to the backend API in the expected format.
  Future<void> deleteItem(int ItemId) async {
    var response;
    try {
      response = await http.delete(Uri.parse("$url/$ItemId"));
      final body = json.decode(response.body);
      _items.removeWhere((element) => element.id == body["id"]);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
