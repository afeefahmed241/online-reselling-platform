import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/auth_service.dart';
import 'package:flutter_project/detailspage.dart';
import 'package:flutter_project/my_postpage.dart';
import 'package:provider/src/provider.dart';

import 'categorypage.dart';
import 'homepage.dart';

class SearchPage extends StatelessWidget {
  final String searchkey;

  SearchPage({Key? key,required this.searchkey}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> subjects = FirebaseFirestore.instance.collection('subjects').where('name',isGreaterThanOrEqualTo: searchkey).where('name',isLessThan:searchkey+'z').snapshots();


    return Scaffold(
      appBar: AppBar(
        title: Text(searchkey),
        backgroundColor: Colors.blueGrey[900],

      ),
      drawer: Drawer(

        child: ListView(

          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  Container(
                    child: Row(
                      children: const [

                        Text("User",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children:  [
                        if(context.watch<User?>() != null)Text(context.watch<User?>()!.email.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Home',style: TextStyle(fontSize: 20,color: Colors.black38)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  HomePage()));

              },
            ),
            ListTile(
              title: const Text('My Posts',style: TextStyle(fontSize: 20,color: Colors.black38)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  MyPostPage(owner: context.watch<User?>()!.email.toString())));

              },
            ),
            ListTile(
              title: const Text('Keyboards',style: TextStyle(fontSize: 20,color: Colors.black38)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  CategoryPage(categoryName: 'keyboard')));
              },
            ),
            ListTile(
              title: const Text('Mouse',style: TextStyle(fontSize: 20,color: Colors.black38)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  CategoryPage(categoryName: 'mouse')));
              },
            ),
            ListTile(
              title: const Text('Accessories',style: TextStyle(fontSize: 20,color: Colors.black38)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  CategoryPage(categoryName: 'accessories')));
              },
            ),
            ListTile(
              title: const Text('Others',style: TextStyle(fontSize: 20,color: Colors.black38)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  CategoryPage(categoryName: 'others')));
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

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

            return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context,index){
                return Column(
                  children: [

                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  DetailsPage(id: data.docs[index].reference.id,categoryName:data.docs[index]['category'] ,)));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Container(
                          height: 325,
                          width: 375,
                          child: Column(
                            children: [
                              const SizedBox(height: 10,),
                              Container(
                                width: 350, height: 200,
                                child: ClipRRect(borderRadius: BorderRadius.circular(20),
                                    child: Image.network(data.docs[index]['pic'],fit: BoxFit.fill,)),
                              ),

                              const SizedBox(height: 25,),
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Row(

                                  children: [

                                    const Text("Title: ",style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic,color: Colors.grey),),
                                    Text(data.docs[index]['name'],style: TextStyle(fontSize: 19,),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Row(

                                  children: [

                                    const Text("Category: ",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey)),
                                    Text(data.docs[index]['category']),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Row(

                                  children: [

                                    const Text("Owner: ",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey)),
                                    Text(data.docs[index]['owner']),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}