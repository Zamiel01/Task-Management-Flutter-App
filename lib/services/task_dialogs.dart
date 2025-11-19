// task_dialogs.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

Future<void> showAddTaskDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();
  final taskProvider = context.read<TaskProvider>();
  bool isLoading = false;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color.fromARGB(255, 39, 41, 51),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "New Task",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add Task',
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 165, 162, 162)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 50, 52, 63),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            String newTask = controller.text.trim();
                            if (newTask.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Task cannot be empty!'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            setModalState(() => isLoading = true);

                            bool exists =
                                await taskProvider.isTaskExist(newTask);
                            if (exists) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Task already exists!'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              setModalState(() => isLoading = false);
                              return;
                            }

                            await taskProvider.addTask(Task(task: newTask));

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task Added Successfully'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                              ),
                            );

                            Navigator.pop(context);
                            setModalState(() => isLoading = false);
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      });
    },
  );
}

Future<void> showUpdateTaskDialog(BuildContext context, Task task) async {
  final TextEditingController controller = TextEditingController(text: task.task);
  final taskProvider = context.read<TaskProvider>();
  bool isLoading = false;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color.fromARGB(255, 39, 41, 51),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Update Task",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Update Task',
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 165, 162, 162)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 50, 52, 63),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            String updatedText = controller.text.trim();
                            if (updatedText.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Task cannot be empty!'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            setModalState(() => isLoading = true);

                            // Check for duplicates
                            bool exists =
                                await taskProvider.isTaskExist(updatedText);
                            if (exists && updatedText != task.task) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Task already exists!'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              setModalState(() => isLoading = false);
                              return;
                            }

                            Task updatedTask = Task(id: task.id, task: updatedText);
                            await taskProvider.updateTask(updatedTask);

                            Navigator.pop(context);
                            setModalState(() => isLoading = false);
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      });
    },
  );
}
