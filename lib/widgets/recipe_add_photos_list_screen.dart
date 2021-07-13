import 'package:flutter/material.dart';

class RecipeAddPhotosListScreen extends StatefulWidget {
  const RecipeAddPhotosListScreen({Key? key}) : super(key: key);

  @override
  _RecipeAddPhotosListState createState() => _RecipeAddPhotosListState();
}

class _RecipeAddPhotosListState extends State<RecipeAddPhotosListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Color(0),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
      ),
    );
  }
}
