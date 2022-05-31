import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_ex/screens/display_product_scree.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DisplayProductScree(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? idData;
  //DocumentSnapshot id = '';

  void _create() async {
    try {
      await firestore
          .collection('products')
          .doc('testProduct1')
          .set({'name': 'Cloth', 'price': 299});

      // await firestore.collection('products').add({'name': 'Shoe', 'price': 99});   //For auto increment id use add

    } catch (e) {
      // print(e);
    }
  }

  void _update() async {
    try {
      // firestore.collection('products').doc('testProduct').update({
      //   'name': 'Redmi',
      // });
      DocumentSnapshot documentSnapshot;
      documentSnapshot =
          await firestore.collection('products').doc('testProduct').get();
      print(documentSnapshot.data());
    } catch (e) {
      print(e);
    }
  }

  void _read() async {
    QuerySnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore.collection('products').get();
      print(documentSnapshot.docs.map((e) => e.data()));
      //print(documentSnapshot.id);
    } catch (e) {
      print(e);
    }
  }

  void _delete() async {
    try {
      firestore.collection('products').doc('testProduct').delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase'),
      ),
      body: Center(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _create();
              },
              child: const Text('create'),
            ),
            ElevatedButton(
              onPressed: () {
                _update();
              },
              child: const Text('update'),
            ),
            ElevatedButton(
              onPressed: () {
                _read();
              },
              child: const Text('read'),
            ),
            ElevatedButton(
              onPressed: () {
                _delete();
              },
              child: const Text('delete'),
            ),
          ],
        ),
      ),
    );
  }
}
