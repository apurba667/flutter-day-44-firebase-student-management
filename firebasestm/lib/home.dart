import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasestm/addNewCourse.dart';
import 'package:firebasestm/update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> courseStrem =
      FirebaseFirestore.instance.collection("course").snapshots();

  addCourse() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => AddNewCourse());
  }

  Future<void> deleteCourse(selectDocument) {
    return FirebaseFirestore.instance
        .collection("course")
        .doc(selectDocument)
        .delete()
        .then((value) => print("Data has been deleted!"))
        .catchError((e) => print(e));
  }

  Future<void> editCourse(selectDocument, courseName, courseFee, courseImg) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            UpdateCourse(selectDocument, courseName, courseFee, courseImg));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCourse();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: courseStrem,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print("The programe has problem ");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Stack(
                  children: [
                    Container(
                      height: 200,
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: [
                            Expanded(
                                child: Image.network(
                              data["img"],
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            )),
                            Container(
                              child: Text(
                                data["course_name"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            Container(
                              child: Text(
                                data["course_fee"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        right: 10,
                        child: Container(
                          width: 120,
                          child: Card(
                            color: Colors.amber,
                            elevation: 20,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      editCourse(
                                          document.id,
                                          data["course_name"],
                                          data["course_fee"],
                                          data["img"]);
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      deleteCourse(document.id);
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          ),
                        ))
                  ],
                );
              }).toList(),
            );
          }),
    );
  }
}
