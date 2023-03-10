import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/views/register_view.dart';

import './firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              final emailVerified = user?.emailVerified ?? false;
              if (emailVerified) {
                print("You have verified email");
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const VerificationEmailView(),
                ));
              }
              return const Text('Done');
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}

class VerificationEmailView extends StatefulWidget {
  const VerificationEmailView({super.key});

  @override
  State<VerificationEmailView> createState() => _VerificationEmailViewState();
}

class _VerificationEmailViewState extends State<VerificationEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Please verify your email!'),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text('Send Verification Link'),
            )
          ],
        ),
      ),
    );
  }
}
