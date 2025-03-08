import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:article_management/bloc/article_bloc.dart';
import 'package:article_management/bloc/article_event.dart';
import 'package:article_management/bloc/article_state.dart';
import 'package:article_management/models/article_model.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'UpdateArticleScreen.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String articleId;

  const ArticleDetailScreen({Key? key, required this.articleId}) : super(key: key);

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ArticleBloc>().add(FetchArticleById(widget.articleId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        title: Text(
          "Article Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateArticleScreen(articleId: widget.articleId),
                ),
              ).then((_) {
                context.read<ArticleBloc>().add(FetchArticleById(widget.articleId));
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticlesLoading) {
            return _buildShimmerEffect();
          } else if (state is ArticleLoaded) {
            Article article = state.article;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem("Title", article.title),
                        _buildDivider(),
                        _buildDetailItem("Author", article.author),
                        _buildDivider(),
                        _buildDetailItem("Read Time", "${article.readTime} mins"),
                        _buildDivider(),
                        _buildDetailItem("Category", article.category),
                        _buildDivider(),
                        SizedBox(height: 1.h),
                        Text(
                          "Description",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          article.description,
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is ArticleError) {
            return Center(
              child: Text(
                "⚠️ ${state.message}",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Row(
      children: [
        Text(
          "$title: ",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(height: 3.h, thickness: 1, color: Colors.grey[300]);
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 20.sp,
              width: 80.w,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2.h),
          _shimmerBox(width: 60.w, height: 16.sp),
          Divider(height: 5.h, thickness: 1),
          _shimmerBox(width: 30.w, height: 16.sp),
          SizedBox(height: 1.h),
          _shimmerBox(width: 90.w, height: 12.sp),
          SizedBox(height: 1.h),
          _shimmerBox(width: 85.w, height: 12.sp),
          SizedBox(height: 1.h),
          _shimmerBox(width: 75.w, height: 12.sp),
        ],
      ),
    );
  }

  Widget _shimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }
}
