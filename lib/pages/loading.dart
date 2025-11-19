import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
          backgroundImage: AssetImage('assets/bird.png'), // Path to your image in assets
          radius: 50.0, // Optional: adjust size
        ),
        SizedBox(height: 40,),
            Text('Welcome to To-do', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 60.0,),
            SpinKitFadingCube(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.blue : Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
