import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/auth__service.dart';
import 'package:recipe_app/ThemeExtension/custom_widget_description.dart';

class RegisterPage extends StatefulWidget {
  final AuthService authService;
  const RegisterPage({super.key, required this.authService});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('Assets/RecipeBackground.jpeg'),
                fit: BoxFit.cover)),
        padding: CustomDescription.primaryEdgeInsets,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: "Username",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Password",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  bool success = await AuthService().register(
                      usernameController.text.trim(), passwordController.text);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(success
                        ? "Registration Successful"
                        : "Registration Failed"),
                  ));
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
