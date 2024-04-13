import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  double a = 0;
  double b = 0;

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Image.asset('assets/gifs/g2.json'),
              Lottie.asset('assets/gifs/g2.json'),
              //Blocking UI task
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      a = await complexTask1();
                      setState(() {

                      });
                      debugPrint('Result 1: $a');
                    },
                    child: const Text('Using Async', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                  ),
                  Text((a != 0) ? "Data Received" : "Waiting", style: const TextStyle(color: Colors.black, fontSize: 20),) ,
                ],
              ),
              //Isolate
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final receivePort = ReceivePort();
                      await Isolate.spawn(complexTask2, receivePort.sendPort);
                      receivePort.listen((total) {
                        debugPrint('Result 2: $total');
                        b = total;
                        setState(() {

                        });
                      });
                    },
                    child: const Text('Using Isolate', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                  ),
                 Text( (b != 0) ? "Data Received" : "Waiting", style: const TextStyle(color: Colors.black, fontSize: 20),) ,

    ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<double> complexTask1() async {
    var total = 0.0;
    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}
//--End of HomePage--

complexTask2(SendPort sendPort) {
  var total = 0.0;
  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}
