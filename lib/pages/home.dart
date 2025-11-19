import 'package:flutter/material.dart';
import 'package:todo/providers/task_provider.dart';
//importing auth class
import '../models/task.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../services/task_dialogs.dart'; // <-- new file
import '../services/gemini_service.dart';
import '../widgets/buttons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  String tasklocal = "";
  final GlobalKey<FormState> _key = GlobalKey();
  List<Task> taskList = [];
  int _selectedIndex = -1; // Stores the index of the selected tile
  bool _isListening = false;
  late GeminiService _geminiService; // Gemini/TTS/Voice handler

  @override
  void initState() {
    super.initState();

    // Initialize Gemini service
    _geminiService = GeminiService();
    _geminiService.init();

    // Load tasks after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = context.read<TaskProvider>();
      taskProvider.loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final taskList = taskProvider.tasks;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(31, 8, 106, 225),
      body: SafeArea(
        child: Stack(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.list, color: Colors.white),
                  SizedBox(width: 19),
                  Icon(Icons.settings, color: Colors.white),
                ],
              ),
            ),

            // Tasks text
            const Positioned(
              top: 70,
              left: 8,
              child: Text(
                'Tasks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 37,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
         
            // Task list or empty state
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0,110.0,0.0,0.0),
              child: Center(
                child: taskList.isEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Color.fromARGB(255, 188, 148, 30),
                            size: 70,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'None',
                            style: TextStyle(
                              color: Color.fromARGB(255, 113, 111, 111),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 480,
                        child: ListView.builder(
                          itemCount: taskList.length,
                          itemBuilder: (context, index) {
                            final task = taskList[index];
                            final isSelected = taskProvider.selectedTask == task;
              
                            return Dismissible(
                              key: ValueKey(task.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) async {
                                await taskProvider.deleteTask(task.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Task deleted'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                height: 90,
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 6,
                                  shadowColor: Colors.teal.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: Colors.amber,
                                      width: 1,
                                    ),
                                  ),
                                  color: Colors.black,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    leading: const Icon(Icons.circle),
                                    title: Text(
                                      task.task,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.amber
                                            : Colors.white,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    tileColor: isSelected ? Colors.amber : null,
                                    selected: isSelected,
                                    onTap: () {
                                      taskProvider.selectTask(task);
                                      showUpdateTaskDialog(context, task);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),

            // Floating add button
            // Floating add button
            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingAddButton(
                onPressed: () => showAddTaskDialog(context),
              ),
            ),

            // Mic button
            Positioned(
              bottom: 30,
              left: 30,
              child: MicButton(
                isListening: _isListening,
                onTap: () {
                  setState(() => _isListening = !_isListening);
                  _geminiService.listenAndSend(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
