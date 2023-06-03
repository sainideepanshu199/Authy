import 'package:authentication_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:authentication_app/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('user');
  // ignore: deprecated_member_use
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: 'What\'s in your mind?',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            RoundButton(
                loading: loading,
                title: 'Add',
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title': postController.text.toString(),
                    'id': id
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('post added');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = true;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
