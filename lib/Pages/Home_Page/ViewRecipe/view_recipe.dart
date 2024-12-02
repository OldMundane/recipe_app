import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/db_helper.dart';
import 'package:recipe_app/ThemeExtension/custom_widget_description.dart';

class ViewRecipe extends StatefulWidget {
  final Map<String, dynamic> recipe;
  const ViewRecipe({super.key, required this.recipe});

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  late Map<String, dynamic> recipe;

  @override
  void initState() {
    super.initState();
    recipe = Map<String, dynamic>.from(widget.recipe); // Create a mutable copy
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'] ?? ''),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'Assets/RecipeBackground.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(
                    0.5), // Optional: Add a semi-transparent overlay
              ),
              child: Container(
                padding: CustomDescription.primaryEdgeInsets,
                decoration: BoxDecoration(
                    // color: Colors.black.withOpacity(0.5),
                    borderRadius: CustomDescription.primaryBorderRadius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Description:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showEditDialog(
                                      context,
                                      "Description",
                                      recipe['description'] ?? '',
                                      (value) async {
                                        setState(() {
                                          recipe['description'] = value;
                                        });
                                        await DatabaseHelper.instance
                                            .updateRecipeDescription(
                                                recipe['id'], value);
                                        if (!context.mounted) return;
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: Text(
                                recipe['description'] ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ingredients:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showEditDialog(
                                      context,
                                      "Ingredients",
                                      recipe['ingredients'] ?? '',
                                      (value) async {
                                        setState(() {
                                          recipe['ingredients'] = value;
                                        });
                                        await DatabaseHelper.instance
                                            .updateRecipeIngredients(
                                                recipe['id'], value);
                                        if (!context.mounted) return;
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: Text(
                                recipe['ingredients'] ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Instructions:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showEditDialog(
                                      context,
                                      "Instructions",
                                      recipe['instructions'] ?? '',
                                      (value) async {
                                        setState(() {
                                          recipe['instructions'] = value;
                                        });
                                        await DatabaseHelper.instance
                                            .updateRecipeInstructions(
                                                recipe['id'], value);
                                        if (!context.mounted) return;
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: Text(
                                recipe['instructions'] ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String title, String initialValue,
      Function(String) onSave) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextFormField(
            controller: controller,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Enter $title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
