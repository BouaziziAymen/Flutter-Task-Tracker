import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(appBar: AppBar(title: const Text('Create Task'),),
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
              ElevatedButton(onPressed: (){
                if(formKey.currentState!.validate()){
                  FirebaseFirestore.instance.collection('tasks').add({'task':textEditingController.value.text,'status':false,})
                  .then((onValue)=>{},onError:(error){} );
                }
              }, child: const Text('Create')),
            ],),
          ),
        ),));
  }
}
