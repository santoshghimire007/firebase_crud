import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ex/screens/add_product_form.dart';
import 'package:firestore_ex/screens/electronics_category.dart';
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
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const ListTile(
                title: Text(
                  'Category',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w200),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ElectronicsCategory()));
                },
                title: const Text(
                  'Electronics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
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
                  return Container(
                      padding: const EdgeInsets.all(12),
                      height: 250,
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Image.network(
                              snapshot.data!.docs[index]['imageUrl'] ??
                                  'https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          ListTile(
                            tileColor: Colors.deepOrange,
                            leading: Checkbox(
                                value: snapshot.data!.docs[index]['stock'],
                                onChanged: (value) {
                                  firestore
                                      .collection('products')
                                      .doc(snapshot.data!.docs[index].id)
                                      .update({'stock': value});
                                }),
                            trailing:
                                snapshot.data!.docs[index]['stock'] == true
                                    ? Icon(Icons.check)
                                    : Icon(Icons.close),
                            title:
                                Text(snapshot.data!.docs[index]['name'] ?? ''),
                            subtitle: Text(
                                snapshot.data!.docs[index]['price'].toString()),
                          ),
                        ],
                      ));
                });
          },
        ),
      ),
    );
  }
}
