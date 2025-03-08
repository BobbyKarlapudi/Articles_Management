import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:article_management/bloc/article_bloc.dart';
import 'package:article_management/bloc/article_event.dart';
import 'package:article_management/bloc/article_state.dart';
import 'package:shimmer/shimmer.dart';
import 'articles_screen.dart';

class UpdateArticleScreen extends StatefulWidget {
  final String articleId;

  const UpdateArticleScreen({Key? key, required this.articleId}) : super(key: key);

  @override
  _UpdateArticleScreenState createState() => _UpdateArticleScreenState();
}

class _UpdateArticleScreenState extends State<UpdateArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController readTimeController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    context.read<ArticleBloc>().add(FetchArticleById(widget.articleId));
  }

  void _updateArticle() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final updates = {
      "title": titleController.text,
      "author": authorController.text,
      "category": categoryController.text,
      "description": descriptionController.text,
      "read_time": int.tryParse(readTimeController.text) ?? 0,
    };

    context.read<ArticleBloc>().add(UpdateArticle(widget.articleId, updates));
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
          5,
              (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Article")),
      body: BlocListener<ArticleBloc, ArticleState>(
        listener: (context, state) {
          if (state is UpdateArticleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Article Updated Successfully"),
              backgroundColor: Colors.green,
            ));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ArticlesListScreen()),
                  (route) => false,
            );
          } else if (state is ArticleError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: BlocBuilder<ArticleBloc, ArticleState>(
          builder: (context, state) {
            if (state is ArticlesLoading || _isSubmitting) {
              return Center(child: _buildShimmerEffect());
            } else if (state is ArticleLoaded) {
              titleController.text = state.article.title;
              authorController.text = state.article.author;
              categoryController.text = state.article.category;
              descriptionController.text = state.article.description;
              readTimeController.text = state.article.readTime.toString();

              return Padding(
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
                        enabled: false,
                        decoration: InputDecoration(labelText: "Read Time (in mins)"),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? "Read time is required" : null,
                      ),
                      SizedBox(height: 20),
                      _isSubmitting
                          ? _buildShimmerEffect()
                          : ElevatedButton(
                        onPressed: _updateArticle,
                        child: Text("Update"),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ArticleError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${state.message}", style: TextStyle(color: Colors.red)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => context.read<ArticleBloc>().add(FetchArticleById(widget.articleId)),
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
