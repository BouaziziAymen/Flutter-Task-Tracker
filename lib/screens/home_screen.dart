import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/models/task_model.dart';
import 'package:task_tracker/screens/create_task_screen.dart';
import 'package:task_tracker/screens/edit_task_screen.dart';

import '../utils/local_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String name = LocalStorage.readString('name') ?? 'User';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task tracker'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Text('Hello $name'),
            trailing: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 20,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await LocalStorage.saveString(
                                              'name', _nameController.text)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  child: const Text('Save'))
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          StreamBuilder(
            stream: fireStore.collection('tasks').snapshots(),
            builder: (_, event) {
              if (event.hasData) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: event.data!.docs.length,
                      itemBuilder: (_, index) {
                        var doc = event.data!.docs[index];
                        var task = TaskModel.fromDoc(doc.data());
                        task.id = doc.id;
                        return Card(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              Text(task.task!),
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                IconButton(
                                  icon: const Icon(
                                    color: Colors.red,
                                    Icons.delete,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(task.id)
                                        .delete()
                                        .then((_) {})
                                        .onError((error, stack) {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditTaskScreen(
                                                    taskData: task)));
                                  },
                                ),
                                Checkbox(
                                  value: task.status,
                                  onChanged: (bool? value) {
                                    fireStore
                                        .collection('tasks')
                                        .doc(task.id)
                                        .update({
                                          'task': task.task,
                                          'status': value
                                        })
                                        .then((_) {})
                                        .catchError((error) {});
                                  },
                                ),
                              ])
                            ]));
                      }),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
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
