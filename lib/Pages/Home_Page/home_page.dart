import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/auth__service.dart';
import 'package:recipe_app/Backend/db_helper.dart';
import 'package:recipe_app/Pages/Home_Page/ListOfRecipe/list_of_recipe.dart';
import 'package:recipe_app/Pages/Home_Page/ViewRecipe/view_recipe.dart';

class HomePage extends StatefulWidget {
  final AuthService authService;
  const HomePage({super.key, required this.authService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _recipesFuture;
  late Future<List<Map<String, dynamic>>> _categoriesFuture;

  bool waiting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final userId = widget.authService.getCurrentUserId();
    if (userId != null) {
      _recipesFuture = DatabaseHelper.instance.getRecipes(userId);
      _categoriesFuture = DatabaseHelper.instance.getCategories(userId);
    } else {
      _recipesFuture = Future.value([]);
      _categoriesFuture = Future.value([]);
    }
  }

  void _loadRecipesByCategory(int categoryId) {
    final userId = widget.authService.getCurrentUserId();
    if (userId != null) {
      setState(() {
        _recipesFuture =
            DatabaseHelper.instance.getRecipesByCategory(userId, categoryId);
      });
    }
  }

  void _loadAllRecipes() {
    final userId = widget.authService.getCurrentUserId();
    if (userId != null) {
      setState(() {
        _recipesFuture = DatabaseHelper.instance.getRecipes(userId);
      });
    }
  }

  void _refreshData() {
    if (waiting) return;
    setState(() {
      waiting = true;
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              widget.authService.logout();
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              _refreshData();
              setState(() {
                waiting = false;
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/create_recipe');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/MainBackground.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            onPressed: () {
                              _loadAllRecipes();
                            },
                            child: Text("All"))),
                    Expanded(
                      flex: 3,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _categoriesFuture,
                        builder: (context, snapshot) {
                          print("Categories Snapshot: $snapshot");
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error loading categories'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No categories found'));
                          } else {
                            final categories = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return GestureDetector(
                                  onTap: () {
                                    _loadRecipesByCategory(category['id']);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Chip(
                                      color: WidgetStatePropertyAll(Theme.of(
                                              context)
                                          .colorScheme
                                          .primary), // Change the color of the chip
                                      label: Text(category['name']),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _recipesFuture,
                  builder: (context, snapshot) {
                    print("Snapshot: $snapshot");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading recipes'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No recipes found'));
                    } else {
                      final recipes = snapshot.data!;
                      return ListOfRecipe(
                        recipes: recipes,
                        onRecipeTap: (recipe) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewRecipe(recipe: recipe),
                            ),
                          );
                          if (result == true) {
                            _refreshData();
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
