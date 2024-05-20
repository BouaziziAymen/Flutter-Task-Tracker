import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/screens/create_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task tracker'),
      ),
      body: StreamBuilder(
        stream: fireStore.collection('tasks').snapshots(),
        builder: (_, event) {
          if (event.hasData) {
            return ListView.builder(
                itemCount: event.data!.docs.length,
                itemBuilder: (_, index) {
                  var doc = event.data!.docs[index];
                  return Card(
                    child: ListTile(
                      leading: Text(doc['task']),
                      trailing: Checkbox(
                        value: doc['status'],
                        onChanged: (bool? value) {
                          fireStore
                              .collection('tasks')
                              .doc(doc.id)
                              .update({'task': doc['task'], 'status': value})
                              .then((_) {})
                              .catchError((error) {});
                        },
                      ),
                    ),
                  );
                });
          }
          return const CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CreateTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
