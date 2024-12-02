import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/auth__service.dart';
import 'package:recipe_app/Pages/Home_Page/home_page.dart';
import 'package:recipe_app/Pages/Login_Page/login_page.dart';

class Authenticate extends StatelessWidget {
  final AuthService authService;

  const Authenticate({required this.authService, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: authService.authState,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('Connection State: ${snapshot.connectionState}');
        print('Snapshot Data: ${snapshot.data}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final isLoggedIn = snapshot.data ?? false;

        return isLoggedIn
            ? HomePage(authService: authService)
            : LoginPage(authService: authService);
      },
    );
  }
}
