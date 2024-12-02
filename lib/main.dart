import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/auth__service.dart';
import 'package:recipe_app/Pages/Authenticate/authenticate.dart';
import 'package:recipe_app/Pages/Home_Page/CreateRecipe/create_recipe.dart';
import 'package:recipe_app/Pages/Home_Page/home_page.dart';
import 'package:recipe_app/Pages/Login_Page/login_page.dart';
import 'package:recipe_app/Pages/Register_Page/register_page.dart';
import 'package:recipe_app/Pages/Home_Page/ViewRecipe/view_recipe.dart';
import 'package:recipe_app/ThemeExtension/custom_theme_extension.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(
              authService: authService,
            ),
        '/login': (context) => LoginPage(
              authService: authService,
            ),
        '/register': (context) => RegisterPage(
              authService: authService,
            ),
        '/home': (context) => HomePage(
              authService: authService,
            ),
        '/create_recipe': (context) => CreateRecipe(
              authService: authService,
            ),
      },
      debugShowCheckedModeBanner: false,
      title: 'Recipe Haven',
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[
          CustomThemeExtension(
            boxShadow: BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ),
        ],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.pink,
            secondary: Colors.pinkAccent,
            tertiary: Colors.white),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.pink,
        ),
        // Navigation Bar
        navigationBarTheme: NavigationBarThemeData(),
        // Bottom App Bar
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.pink,
          elevation: 0,
        ),
        // Bottom Navigation Bar
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Colors.pink),
        // Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          backgroundColor: WidgetStatePropertyAll(Colors.pink),
          // backgroundColor: WidgetStatePropertyAll(Color(0xFFf9b9f2))
        )),
        // Text Button
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.pink),
        )),
        // Scaffold Background Color
        scaffoldBackgroundColor: const Color.fromARGB(255, 249, 251, 255),
        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Attentions: This specific instance of AuthService should be passed
  // to all the pages because it is the only instance that will be used
  // and currently used by StreamBuilder within authenticate.dart to check
  // wether the user is logged in or not. If you use AuthService() instead
  // of this instance, the StreamBuilder will not detect the changes.
  final AuthService authService;

  const MyHomePage({required this.authService, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Authenticate(
      authService: widget.authService,
    );
  }
}
