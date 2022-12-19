
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/auth_service.dart';
import 'package:provider/src/provider.dart';

class AddItemPage extends StatefulWidget {




  @override
  State<StatefulWidget> createState() {
    return AddItemPageState();
  }


}

class AddItemPageState extends State<AddItemPage>{
  // TODO: implement createState
  final TextEditingController titleController = TextEditingController();
  final TextEditingController catController = TextEditingController();
  final TextEditingController desController = TextEditingController();



  PlatformFile? pickedFile;
  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }




  final ButtonStyle raisedButtonClickedStyle = ElevatedButton.styleFrom(
      primary: Colors.blueGrey[700],

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)));

  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User?>();


    Future uploadFile() async {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      var uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();


      CollectionReference subRef = FirebaseFirestore.instance.collection(
          'subjects');

      if (titleController.text.isNotEmpty && catController.text.isNotEmpty &&
          desController.text.isNotEmpty) {
        subRef.add({
          'owner': firebaseuser!.email.toString(),
          'name': titleController.text.trim(),
          'category': catController.text.trim(),
          'description': desController.text.trim(),
          'pic': urlDownload,
        });
        Navigator.pop(context);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title:  Text("Create New Post"),
          backgroundColor: Colors.blueGrey[900],
          actions: [

            IconButton(onPressed:uploadFile,
                icon: const Icon(Icons.send_rounded))
          ],

        ),
        body : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(pickedFile != null)
              Expanded(
                  child: Container(
                    child: Image.file(
                      File(pickedFile!.path!),
                      width: double.infinity,
                      fit: BoxFit.cover,

                    ),
                  )
              ),
            const SizedBox(height: 10,),
            Container(
              child: ElevatedButton(
                style: raisedButtonClickedStyle,
                onPressed: selectFile,
                child: const Text("Select Image"),

              ),
            ),

            const SizedBox(height: 10,),
            Container(
              width: 300,

              child: TextField(
                textAlign: TextAlign.start,
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              width: 300,

              child: TextField(
                textAlign: TextAlign.start,
                controller: catController,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              width: 300,

              child: TextField(
                textAlign: TextAlign.start,
                controller: desController,
                decoration: const InputDecoration(
                  hintText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 10, // <-- SEE HERE
                minLines: 4, // <-- SEE HERE
              ),
            ),
            const SizedBox(height: 10,),

            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

            ),

          ],
        )
    );
  }
}