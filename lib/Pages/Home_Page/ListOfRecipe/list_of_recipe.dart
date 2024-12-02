import 'package:flutter/material.dart';
import 'package:recipe_app/Pages/Home_Page/ViewRecipe/view_recipe.dart';

class ListOfRecipe extends StatelessWidget {
  final dynamic recipes;
  final Function(Map<String, Object?>) onRecipeTap;

  const ListOfRecipe(
      {super.key, required this.recipes, required this.onRecipeTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return ListTile(
          title: Text(recipe['title']),
          subtitle: Text(recipe['description'] ?? ''),
          onTap: () {
            onRecipeTap(recipe);
          },
        );
      },
    );
  }
}
