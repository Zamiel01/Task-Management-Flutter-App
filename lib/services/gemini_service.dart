import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class GeminiService {
  
  final FlutterTts _tts = FlutterTts();
  late stt.SpeechToText _speech;
  bool isListening = false;

  GeminiService() {
    _speech = stt.SpeechToText();
  }

  /// Initialize speech and Gemini API
  Future<void> init() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print("Speech status: $status"),
      onError: (error) => print("Speech error: $error"),
    );

    if (!available) {
      print("Speech recognition not available.");
    }

    Gemini.init(
      apiKey: "AIzaSyAgNw5R8cFSqOuna1fzcQtN--7f5cxSsr0", // Replace with actual key
    );
  }

  /// Speak text using TTS
  Future<void> speak(String text) async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.speak(text);
  }

  /// Listen to voice input and handle it
  Future<void> listenAndSend(BuildContext context) async {
    final taskProvider = context.read<TaskProvider>();

    bool available = await _speech.initialize();
    if (!available) {
      print("Speech recognition not available.");
      return;
    }

    isListening = true;
    _speech.listen(
      onResult: (val) async {
        if (val.finalResult) {
          isListening = false;
          String text = val.recognizedWords;
          print("Voice Input: $text");
          await sendToGemini(context, text, taskProvider);
          _speech.stop();
        }
      },
    );
  }

  /// Handles sending text to Gemini or creating tasks locally
  Future<void> sendToGemini(BuildContext context, String text, TaskProvider taskProvider) async {
    try {
      if (text.toLowerCase().contains("create a task")) {
        final parts = text.toLowerCase().split("create a task");
        if (parts.length < 2 || parts[1].trim().isEmpty) {
          await speak("Please provide the task content.");
          return;
        }

        String taskText = parts[1].trim();

        // Check if task exists before adding
        bool exists = await taskProvider.isTaskExist(taskText);
        if (exists) {
          await speak("Task already exists.");
          return;
        }

        await taskProvider.addTask(Task(task: taskText));
        print("Task stored: $taskText");
        await speak("Sir, your task has been created.");
        return;
      }

      // Otherwise, send to Gemini AI
      final gemini = Gemini.instance;
      final response = await gemini.prompt(parts: [Part.text(text)]);
      final String geminiReply = response?.output ?? "I couldn't understand that.";
      print("Gemini says: $geminiReply");
      await speak(geminiReply);

    } catch (e) {
      print("Error sending to Gemini: $e");
    }
  }
}
