import 'package:article_management/bloc/article_bloc.dart';
import 'package:article_management/bloc/article_event.dart';
import 'package:article_management/bloc/article_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

class CreateArticleScreen extends StatefulWidget {
  @override
  _CreateArticleScreenState createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends State<CreateArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController readTimeController = TextEditingController();

  bool _isSubmitting = false;

  void _submitArticle() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        final articleData = {
          "title": titleController.text.trim(),
          "author": authorController.text.trim(),
          "category": categoryController.text.trim(),
          "description": descriptionController.text.trim(),
          "read_time": int.tryParse(readTimeController.text.trim()) ?? 0,
        };

        context.read<ArticleBloc>().add(CreateArticle(articleData));
      } catch (e) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid input. Please check your entries."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Article")),
      body: BlocListener<ArticleBloc, ArticleState>(
        listener: (context, state) {
          if (state is CreateArticleSuccess) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Article Created Successfully"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ArticleError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Title"),
                  validator: (value) => value!.isEmpty ? "Title is required" : null,
                ),
                TextFormField(
                  controller: authorController,
                  decoration: InputDecoration(labelText: "Author"),
                  validator: (value) => value!.isEmpty ? "Author is required" : null,
                ),
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: "Category"),
                  validator: (value) => value!.isEmpty ? "Category is required" : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) => value!.isEmpty ? "Description is required" : null,
                ),
                TextFormField(
                  controller: readTimeController,
                  decoration: InputDecoration(labelText: "Read Time"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return "Read Time is required";
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5.h),
                _isSubmitting
                    ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
                    : ElevatedButton(
                  onPressed: _submitArticle,
                  child: Text("Create"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
