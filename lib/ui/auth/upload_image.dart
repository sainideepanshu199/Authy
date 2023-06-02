import 'package:authentication_app/utils/utils.dart';
import 'package:authentication_app/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Uplaod Image')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
                loading: loading,
                title: 'Upload Image',
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref =
                      firebase_storage.FirebaseStorage.instance.ref('/images/' +
                          DateTime.now().microsecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);

                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    String id =
                        DateTime.now().microsecondsSinceEpoch.toString();
                    databaseRef.child('1').set(
                        {'id': id, 'title': newUrl.toString()}).then((value) {
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                    Utils().toastMessage('Image Uploaded');
                  });
                }),
          ],
        ),
      ),
    );
  }
}
