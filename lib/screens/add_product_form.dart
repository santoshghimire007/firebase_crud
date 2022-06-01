import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firestore_ex/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:firebase_core/firebase_core.dart';

class AddProductsForm extends StatefulWidget {
  const AddProductsForm({Key? key}) : super(key: key);

  @override
  State<AddProductsForm> createState() => _AddProductsFormState();
}

class _AddProductsFormState extends State<AddProductsForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool stock = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  File? _image;
  bool _loading = false;

  final _picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _uploadImage() {
    //create a unique file name for image
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Image").child(imageFileName);
    final UploadTask uploadTask = storageReference.putFile(_image!);

    uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((imageUrl) {
        //save the info to firestore
        _saveData(imageUrl);
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }

  void _saveData(String imageUrl) {
    FirebaseFirestore.instance.collection("electronics").add({
      "imageUrl": imageUrl,
      "name": nameController.text,
      "price": priceController.text,
      // "stock": stock,
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'Post added successfully',
            style: TextStyle(color: Colors.green),
          )));
      _goHomeScreen();
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }

  void _goHomeScreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _image == null
              ? Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey,
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          _openImagePicker();
                        },
                        child: const Text('Add Image')),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    _openImagePicker();
                  },
                  child: Container(
                    child: Image.file(
                      _image!,
                      fit: BoxFit.contain,
                    ),
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
                ),
                labelText: 'Name',
                hintText: "Enter Product's Name"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
              ),
              labelText: 'Price',
              hintText: "Enter Price",
            ),
            controller: priceController,
            keyboardType: TextInputType.number,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     const Text('Stock'),
          //     Switch(
          //         value: stock,
          //         onChanged: (bool value) {
          //           setState(() {
          //             stock = value;
          //           });
          //         }),
          //   ],
          // ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _uploadImage();
                // products
                //     .add(ProductModel(
                //             stock: stock,
                //             name: nameController.text,
                //             price: int.parse(priceController.text))
                //         .toJson())
                //     .then((value) => Navigator.pop(context));
              },
              child: const Text('Submit'),
            ),
          ),
          //icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
