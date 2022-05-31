import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ex/screens/add_product_form.dart';
import 'package:flutter/material.dart';

class DisplayProductScree extends StatefulWidget {
  const DisplayProductScree({Key? key}) : super(key: key);

  @override
  _DisplayProductScreeState createState() => _DisplayProductScreeState();
}

class _DisplayProductScreeState extends State<DisplayProductScree> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 500,
                  child: AddProductsForm(),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Display Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: products.orderBy('price', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error occurs');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  leading: Checkbox(
                      value: snapshot.data!.docs[index]['stock'],
                      onChanged: (value) {
                        firestore
                            .collection('products')
                            .doc(snapshot.data!.docs[index].id)
                            .update({'stock': value});
                      }),
                  trailing: snapshot.data!.docs[index]['stock'] == true
                      ? Icon(Icons.check)
                      : Icon(Icons.close),
                  title: Text(snapshot.data!.docs[index]['name'] ?? ''),
                  subtitle:
                      Text(snapshot.data!.docs[index]['price'].toString()),
                );
              });
        },
      ),
    );
  }
}
