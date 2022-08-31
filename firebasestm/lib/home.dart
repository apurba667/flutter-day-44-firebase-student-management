import 'package:firebasestm/addNewCourse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  addCourse() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => AddNewCourse());
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
    );
  }
}
