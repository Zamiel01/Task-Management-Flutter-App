// widgets/buttons.dart
import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  const FloatingAddButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 8, 35, 83),
        padding: const EdgeInsets.all(20),
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 20),
    );
  }
}

class MicButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;

  const MicButton({required this.isListening, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isListening ? Colors.redAccent : const Color.fromARGB(255, 8, 35, 83),
          boxShadow: isListening
              ? [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.6),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),
        child: AnimatedScale(
          scale: isListening ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: const Icon(
            Icons.mic_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
