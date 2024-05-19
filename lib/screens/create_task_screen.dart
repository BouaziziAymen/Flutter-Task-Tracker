import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: const Text('Task tracker'),),
      body: Container(),
      floatingActionButton: FloatingActionButton(onPressed: (){
      },child: const Icon(Icons.add),),
    );
  }
}
