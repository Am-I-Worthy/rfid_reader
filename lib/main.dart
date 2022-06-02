import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference dataRef =
      FirebaseDatabase.instance.ref('test/card/json/data');
  DatabaseReference isAllowedRef =
      FirebaseDatabase.instance.ref('test/card/json/isAllowed');
  String data = 'Please Scan the RFID card to get the details here...';
  String isAllowed = false.toString();

  UserCredential? userCredential;

  @override
  void initState() {
    signIn();

    super.initState();
  }

  void signIn() async {
    userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "shrinaveen6053@gmail.com", password: "Leena<3naveen");
    dataRef.onValue.listen((event) {
      setState(() {
        print('value UPdates');
        data = event.snapshot.value.toString() == 'null'
            ? 'Please Scan the RFID card to get the details here...'
            : event.snapshot.value.toString();
      });
    });
    isAllowedRef.onValue.listen((event) {
      setState(() {
        isAllowed = event.snapshot.value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                height: 90.0,
                child: Text(
                  'Welcome!',
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                data,
                style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              Text(
                isAllowed == 'true' ? 'Access Granted' : 'Access Denied',
                style: GoogleFonts.quicksand(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
