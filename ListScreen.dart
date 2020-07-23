import 'package:PDFGenerator/AddSignatureScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Utils/SQLiteModel.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  static Database _database;
  List<Client> userList = [];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAllClients();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Spacer(),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddSignatureScreen()),
                      );
                    },
                    child: Text(
                      "ADD",
                    ),
                  ),
                ],
              ),
              Container(
                height: 400,
                child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new InkWell(
                        child: buildRow(index),
                        onTap: () async {
                          // selectedCard = index;

                          //(index == 0){
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => InvitationDetailScreen(
                          //                   event: _dashboardEventList.eventList[index],
                          //                 )));
                        });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getAllClients() async {
    final db = await database;
    var res = await db.query("Client");
    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    userList = list;

    setState(() {
      // print(list);
    });
    // return list;
  }

  Widget buildRow(
    int index,
  ) {
    return Container(
        height: 100,
        child: Column(
          children: <Widget>[
            Text(userList[index].name),
            Text(userList[index].email)
          ],
        ),
        margin: EdgeInsets.only(bottom: 10, top: 0));
  }
}
