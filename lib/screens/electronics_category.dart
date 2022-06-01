import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ElectronicsCategory extends StatefulWidget {
  const ElectronicsCategory({Key? key}) : super(key: key);

  @override
  _ElectronicsCategoryState createState() => _ElectronicsCategoryState();
}

class _ElectronicsCategoryState extends State<ElectronicsCategory> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference electronics =
      FirebaseFirestore.instance.collection('electronics');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electronics Items'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: electronics.orderBy('price', descending: true).snapshots(),
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
                          // leading: Checkbox(
                          //     value: snapshot.data!.docs[index]['stock'],
                          //     onChanged: (value) {
                          //       firestore
                          //           .collection('electronics')
                          //           .doc(snapshot.data!.docs[index].id)
                          //           .update({'stock': value});
                          //     }),
                          // trailing:
                          //     snapshot.data!.docs[index]['stock'] == true
                          //         ? Icon(Icons.check)
                          //         : Icon(Icons.close),
                          title: Text(snapshot.data!.docs[index]['name'] ?? ''),
                          subtitle: Text(
                              snapshot.data!.docs[index]['price'].toString()),
                        ),
                      ],
                    ));
              });
        },
      ),
    );
  }
}
