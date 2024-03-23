import 'package:app/features/home/controllers/user_controller.dart';
import 'package:app/features/home/home_screen.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Gaps.h64,
              const Text(
                "🌗",
                style: TextStyle(fontSize: 48),
                textAlign: TextAlign.center,
              ),
              Gaps.h12,
              Text(
                'Choose your name, and carve your path through shadows and light alike.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Gaps.h32,
              TextField(
                decoration: const InputDecoration(
                  hintText: "Your Name",
                ),
                onChanged: (value) => setState(() {}),
                controller: textEditingController,
              ),
              const Spacer(),
              DefaultButton(
                  isDisable: textEditingController.text.isEmpty,
                  onPressed: () {
                    if (textEditingController.text.isEmpty) {
                      return;
                    }
                    ref
                        .read(userDataControllerProvider.notifier)
                        .updateName(textEditingController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  text: "Create Account")
            ],
          ),
        ),
      ),
    );
  }
}
