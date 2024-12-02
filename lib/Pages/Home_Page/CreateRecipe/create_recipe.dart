import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/auth__service.dart';
import 'package:recipe_app/Backend/db_helper.dart';
import 'package:recipe_app/ThemeExtension/custom_widget_description.dart';

class CreateRecipe extends StatefulWidget {
  final AuthService authService;

  const CreateRecipe({super.key, required this.authService});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Recipe"),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('Assets/RecipeBackground.jpeg'),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: CustomDescription.primaryBorderRadius,
                  color: Theme.of(context).colorScheme.tertiary.withOpacity(.8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        hintText: "Category",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Title",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Description",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: ingredientsController,
                      decoration: const InputDecoration(
                        hintText: "Ingredients",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: instructionsController,
                      decoration: const InputDecoration(
                        hintText: "Instructions",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final user = await widget.authService.getCurrentUser();
                        if (user != null) {
                          await DatabaseHelper.instance.addRecipe(
                            user['id'],
                            categoryController.text,
                            titleController.text,
                            descriptionController.text,
                            ingredientsController.text,
                            instructionsController.text,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Recipe added')),
                            );

                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text("Create Recipe"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
