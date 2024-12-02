import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/auth__service.dart';
import 'package:recipe_app/Backend/db_helper.dart';
import 'package:recipe_app/Pages/Register_Page/register_page.dart';
import 'package:recipe_app/ThemeExtension/custom_widget_description.dart';

class LoginPage extends StatefulWidget {
  final AuthService authService;
  const LoginPage({super.key, required this.authService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool hide = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/RecipeBackground.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: CustomDescription.primaryEdgeInsets,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [CustomDescription.primaryShadow],
              borderRadius: CustomDescription.primaryBorderRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 240,
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "your@email.com",
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 240,
                  child: TextFormField(
                    controller: password,
                    obscureText: hide,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hide = !hide;
                          });
                        },
                        icon: hide
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      hintText: "password",
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool success = await widget.authService
                        .login(email.text.trim(), password.text);
                    print(success);
                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login failed')),
                      );
                    }
                  },
                  child: Text("Login"),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RegisterPage(authService: widget.authService),
                          ),
                        );
                      },
                      child: Text("Sign Up"),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await DatabaseHelper.instance.deleteDatabase();
                      },
                      child: Text("Reset Database"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
