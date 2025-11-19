import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      leading: Padding(
    padding: const EdgeInsets.all(8.0), // Optional: Add padding around the image
    child: Image.asset(
      'assets/bird.png', // Replace with your image path
      fit: BoxFit.contain, // Adjust how the image fits within its bounds
    ),
  ),
      backgroundColor: Colors.blue,
      title: Text('Task'),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 18), // Adjust the 'right' value as needed
        child: IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            // Handle icon press
          },
        ),
      ),
    ],
  ),

  body:  TextField(

              maxLines: null, // Allow unlimited lines
              expands: true, // Make it expand to fill parent
              keyboardType: TextInputType.multiline, // Enable multi-line input
              textAlignVertical: TextAlignVertical.top, // Align text to the top
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Enter Task here...',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
  ),
    );
  }
}