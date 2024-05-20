import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/models/task_model.dart';

class EditTaskScreen extends StatefulWidget {

  final TaskModel taskData;
  const EditTaskScreen({super.key, required this.taskData});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    textEditingController.text = widget.taskData.task!;
    final id =  widget.taskData.id;
    return
      Scaffold(appBar: AppBar(title: const Text('Edit Task'),),
          body:Center(child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                TextFormField(controller: textEditingController,validator: (value){
                  if(value==null||value.isEmpty){
                    return 'Cannot be empty.';
                  }
                  return null;
                },),
                ElevatedButton(onPressed: () async {
                  if(formKey.currentState!.validate()){
                    FirebaseFirestore.instance.collection('tasks').doc(id).update({
                    'task':textEditingController.text}).then((_){Navigator.of(context).pop();});
                  }
                }, child: const Text('Save')),
              ],),
            ),
          ),));
  }
}
