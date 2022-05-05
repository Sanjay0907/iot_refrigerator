import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iot_refridgerator/view/homepage.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const Refridgerator());
}

class Refridgerator extends StatelessWidget {
  const Refridgerator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Sizer(
            builder: (context, _, __) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: HomePage(),
                theme: ThemeData.dark().copyWith(
                  scaffoldBackgroundColor: Colors.black,
                  appBarTheme: const AppBarTheme(
                    color: Colors.transparent,
                    elevation: 0,
                  ),
                ),
              );
            },
          );
        }
        return const Loading();
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              Text(
                'Something Went Wrong',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 4.h, fontWeight: FontWeight.w600),
              ),
              const CircularProgressIndicator(),
            ],
          ),
        )),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}
