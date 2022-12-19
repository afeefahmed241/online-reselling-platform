import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'auth_service.dart';


class DetailsPage extends StatelessWidget {
  final String id;
  final String categoryName;

   DetailsPage({Key? key, required this.id,required this.categoryName}) : super(key: key);

  final TextEditingController commentController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> subjects = FirebaseFirestore.instance.collection('subjects').where(FieldPath.documentId,isEqualTo: id).snapshots();
    final Stream<QuerySnapshot> comments = FirebaseFirestore.instance.collection('subjects').doc(id).collection('comments').orderBy('timestamp',descending: true).snapshots();
    final firebaseuser = context.watch<User?>();
    CollectionReference commentRef = FirebaseFirestore.instance.collection('subjects').doc(id).collection('comments');

    return Scaffold(
      appBar: AppBar(
        //title: Text(categoryName),
        backgroundColor: Colors.blueGrey[900],

      ),
      body:SingleChildScrollView(
        reverse: true,
        child: Container(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 385,
                child: StreamBuilder<QuerySnapshot>(
                  stream: subjects,
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,){
                    if(snapshot.hasError){
                      return const Text("Something Went Wrong");
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Text("Loading");
                    }

                    final data = snapshot.requireData;
                    return Card(
                      child: Container(
                        height: 400,
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            Container(
                              width: 350, height: 200,
                              child: ClipRRect(borderRadius: BorderRadius.circular(20),
                                  child: Image.network(data.docs[0]['pic'],fit: BoxFit.fill,)),
                            ),

                            const SizedBox(height: 10,),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Row(

                                children: [

                                  const Text("Title: ",style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic,color: Colors.grey),),
                                  Text(data.docs[0]['name'],style: TextStyle(fontSize: 19,),),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Row(

                                children: [

                                  const Text("Category: ",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey)),
                                  Text(data.docs[0]['category']),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Row(

                                children: [

                                  const Text("Owner: ",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey)),
                                  Text(data.docs[0]['owner']),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Row(

                                children: [

                                  const Text("Description: ",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey)),

                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Column(

                                children: [


                                  Text(data.docs[0]['description']),
                                ],
                              ),
                            ),



                          ],
                        ),
                      ),
                    );

                  },
                ),


              ),
              Container(
                height: 220,
                child: StreamBuilder<QuerySnapshot>(
                  stream: comments,
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,){
                    if(snapshot.hasError){
                      return const Text("Something Went Wrong");
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Text("Loading");
                    }

                    final commentData = snapshot.requireData;
                    return ListView.builder(
                      itemCount: commentData.size,
                      itemBuilder: (context,index){
                        return Column(
                          children: [

                            if(index==0) Container(
                              margin: const EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Text("Comments: "+commentData.size.toString(),style: const TextStyle(fontSize: 18,),textAlign: TextAlign.left,),
                                  const SizedBox(height: 10,)
                                ],
                              ),
                            ),

                            const SizedBox(height: 15,),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  Text(commentData.docs[index]['name'],style: const TextStyle(fontSize: 11,fontStyle: FontStyle.italic),),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Row(

                                children: [
                                  Text(commentData.docs[index]['comment'],style: const TextStyle(fontSize: 17,)),
                                ],
                              ),
                            ),





                          ],
                        );
                      },);

                  },
                ),


              ),
              Container(

                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(

                      width: 320,
                      child: TextField(
                        controller:commentController,
                        decoration: const InputDecoration(
                            hintText: "Comment",

                        ),

                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        if(commentController.text.isNotEmpty){
                          Timestamp timestamp = Timestamp.fromDate(DateTime.now());
                          commentRef.add({
                            'name': firebaseuser!.email.toString(),
                            'comment':commentController.text.trim(),
                            'timestamp':timestamp
                          });
                          commentController.clear();
                        }

                      },
                      icon: const Icon(Icons.send),
                      color: Colors.blueGrey,
                    )

                  ],
                ),
              )

            ],
          ),
        ),
      )

    );
  }
}
