import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class AddNewCourse extends StatefulWidget {
  const AddNewCourse({Key? key}) : super(key: key);

  @override
  State<AddNewCourse> createState() => _AddNewCourseState();
}

class _AddNewCourseState extends State<AddNewCourse> {
  TextEditingController _couseNameController = TextEditingController();
  TextEditingController _couseFeeController = TextEditingController();
  XFile? _courseImage;
  String? imageUrl;
  chooseImageFromGC() async {
    ImagePicker _picker = ImagePicker();
    _courseImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  writeData() async {
    File imageFile = File(_courseImage!.path);

    FirebaseStorage _storage = FirebaseStorage.instance;
    UploadTask _uploadTask =
        _storage.ref("courses").child(_courseImage!.name).putFile(imageFile);

    TaskSnapshot snapshot = await _uploadTask;
    imageUrl = await snapshot.ref.getDownloadURL();

    CollectionReference _courseData =
        FirebaseFirestore.instance.collection("course");

    _courseData.add({
      "course_name": _couseNameController.text,
      "course_fee": _couseFeeController.text,
      "img": imageUrl
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _couseNameController,
              decoration: InputDecoration(
                  hintText: "Enter Course Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _couseFeeController,
              decoration: InputDecoration(
                  hintText: "Enter Course Fee",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
                    child: _courseImage == null
                        ? IconButton(
                            onPressed: () {
                              chooseImageFromGC();
                            },
                            icon: Icon(Icons.photo))
                        : Image.file(File(_courseImage!.path)))),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  writeData();
                },
                child: Text("Add Course"))
          ],
        ),
      ),
    );
  }
}
