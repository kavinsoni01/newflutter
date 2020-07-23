import 'dart:io';

import 'package:PDFGenerator/Utils/SQLiteModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AddSignatureScreen extends StatefulWidget {
  @override
  _AddSignatureScreenState createState() => _AddSignatureScreenState();
}

class _AddSignatureScreenState extends State<AddSignatureScreen> {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'KavinTest.db');

    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, "KavinTest.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "name TEXT,"
          "email TEXT,"
          "signature TEXT"
          ")");
    });
  }

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter your name.'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter your email.'),
            ),
          ),

          //SIGNATURE CANVAS
          Signature(
            controller: _controller,
            height: 300,
            backgroundColor: Colors.white,
          ),
          //OK AND CLEAR BUTTONS
          Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //SHOW EXPORTED IMAGE IN NEW ROUTE
                IconButton(
                  icon: const Icon(Icons.check),
                  color: Colors.blue,
                  onPressed: () async {
                    if (_controller.isNotEmpty) {
                      var data = await _controller.toPngBytes();
                      var newClient1 = Client();
                      newClient1.email = "email"; //"Kavin.soni@gmail.com";
                      newClient1.name = "Kavin";
                      // newClient1.id = 1;
                      newClient1.signature = "image"; //data;
                      newClient(newClient1);
                      // newClient(
                      //     Client({id:1,name:"kavin",email:"kavin",signature:data}));

                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) {
                      //       return Scaffold(
                      //         appBar: AppBar(),
                      //         body: Center(
                      //             child: Container(
                      //                 color: Colors.grey[300],
                      //                 child: Image.memory(data))),
                      //       );
                      //     },
                      //   ),
                      // );
                    }
                  },
                ),
                //CLEAR CANVAS
                // IconButton(
                //   icon: const Icon(Icons.clear),
                //   color: Colors.blue,
                //   onPressed: () {
                //     setState(() => _controller.clear());
                //   },
                // ),
              ],
            ),
          ),
        ],
        // body: Container(
        //   color: Colors.white,
        //   padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        //   height: MediaQuery.of(context).size.height,
        //   child: SingleChildScrollView(
        //     child: Column(
        //       children: <Widget>[
        //         Container(
        //           height: 60,
        //           padding: EdgeInsets.all(10),
        //           child: TextField(
        //             decoration: InputDecoration(
        //                 border: InputBorder.none, hintText: 'Enter your name.'),
        //           ),
        //         ),
        //         SizedBox(
        //           height: 10,
        //         ),
        //         Container(
        //           height: 60,
        //           padding: EdgeInsets.all(10),
        //           child: TextField(
        //             decoration: InputDecoration(
        //                 border: InputBorder.none, hintText: 'Enter your email.'),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
      ),
    );
  }

  newClient(Client newClient) async {
    final db = await database;
    await db.insert(
      'Client',
      newClient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // var res = await db.rawInsert("INSERT Into Client (name,email,signature)"
    //     " VALUES (${newClient.name},${newClient.email},${newClient.signature})");
    // return res;
  }
}
