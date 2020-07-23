import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Client {
  // int id;
  String name;
  String email;
  // Uint8List signature;
  String signature;
  Client({
    //   this.id,
    this.name,
    this.email,
    this.signature,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
        //    id: json["id"],
        name: json["name"],
        email: json["email"],
        signature: json["signature"],
      );

  Map<String, dynamic> toMap() => {
        //    "id": id,
        "name": name,
        "email": email,
        "signature": signature,
      };
}
