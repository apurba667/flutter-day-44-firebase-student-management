import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class UpdateCourse extends StatefulWidget {
  String? documentId;
  String? courseName;
  String? courseFee;
  String? courseImg;
  UpdateCourse(
      this.documentId, this.courseName, this.courseFee, this.courseImg);

  @override
  State<UpdateCourse> createState() => _UpdateCourseState();
}

class _UpdateCourseState extends State<UpdateCourse> {
  TextEditingController _couseNameController = TextEditingController();
  TextEditingController _couseFeeController = TextEditingController();
  XFile? _courseImage;
  String? imageUrl;
  chooseImageFromGC() async {
    ImagePicker _picker = ImagePicker();
    _courseImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  writeUpdateData() async {
    if (_courseImage == null) {
      CollectionReference _courseData =
          FirebaseFirestore.instance.collection("course");

      _courseData.doc(widget.documentId).update({
        "course_name": _couseNameController.text,
        "course_fee": _couseFeeController.text,
        "img": widget.courseImg
      });
    } else {
      File imageFile = File(_courseImage!.path);

      FirebaseStorage _storage = FirebaseStorage.instance;
      UploadTask _uploadTask =
          _storage.ref("courses").child(_courseImage!.name).putFile(imageFile);

      TaskSnapshot snapshot = await _uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();

      CollectionReference _courseData =
          FirebaseFirestore.instance.collection("course");

      _courseData.doc(widget.documentId).update({
        "course_name": _couseNameController.text,
        "course_fee": _couseFeeController.text,
        "img": imageUrl
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _couseNameController.text = widget.courseName!;
    _couseFeeController.text = widget.courseFee!;
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
                        ? Stack(
                            children: [
                              Image.network("${widget.courseImg}"),
                              CircleAvatar(
                                child: IconButton(
                                    onPressed: () {
                                      chooseImageFromGC();
                                    },
                                    icon: Icon(Icons.photo)),
                              )
                            ],
                          )
                        : Image.file(File(_courseImage!.path)))),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  writeUpdateData();
                },
                child: Text("Update"))
          ],
        ),
      ),
    );
  }
}
