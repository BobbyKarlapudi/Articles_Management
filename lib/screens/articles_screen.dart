import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:article_management/bloc/article_bloc.dart';
import 'package:article_management/bloc/article_event.dart';
import 'package:article_management/bloc/article_state.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'CreateArticleScreen.dart';
import 'article_detail_screen.dart';

class ArticlesListScreen extends StatefulWidget {
  @override
  _ArticlesListScreenState createState() => _ArticlesListScreenState();
}

class _ArticlesListScreenState extends State<ArticlesListScreen> {
  int page = 1;
  final int size = 30;
  bool isLoadingMore = false;
  List<dynamic> allArticles = [];
  List<dynamic> filteredArticles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void fetchArticles({bool loadMore = false}) {
    if (loadMore) {
      if (isLoadingMore) return;
      setState(() {
        isLoadingMore = true;
      });
      page++;
    } else {
      page = 1;
      allArticles.clear();
    }
    context.read<ArticleBloc>().add(FetchArticles(page: page, size: size));
  }

  void filterArticles(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredArticles = allArticles;
      } else {
        filteredArticles = allArticles.where((article) =>
        article.title.toLowerCase().contains(query.toLowerCase()) ||
            article.category.toLowerCase().contains(query.toLowerCase()) ||
            article.description.toLowerCase().contains(query.toLowerCase()) ||
            article.author.toLowerCase().contains(query.toLowerCase()) ||
            article.readTime.toString().contains(query)).toList();
      }
    });
  }

  Widget buildShimmerEffect() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20, width: 80.w, color: Colors.white),
                  SizedBox(height: 1.h),
                  Container(height: 14, width: 60.w, color: Colors.white),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Articles Management', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w700)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => CreateArticleScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 800),
                    ),
                  ).then((_) {
                    fetchArticles();
                  });
                },
                child: Text(
                  'Create Article',
                  style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              onChanged: filterArticles,
              decoration: InputDecoration(
                hintText: 'Search by Title, Category, Description, Author, Read Time',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: BlocListener<ArticleBloc, ArticleState>(
              listener: (context, state) {
                if (state is ArticlesLoaded) {
                  setState(() {
                    if (page == 1) {
                      allArticles = state.articles;
                    } else {
                      allArticles.addAll(state.articles.where((newArticle) =>
                      !allArticles.any((existing) => existing.id == newArticle.id)));
                    }
                    filteredArticles = allArticles;
                    isLoadingMore = false;
                  });
                }
              },
              child: BlocBuilder<ArticleBloc, ArticleState>(
                builder: (context, state) {
                  if (state is ArticlesLoading && allArticles.isEmpty) {
                    return buildShimmerEffect();
                  } else if (state is ArticlesLoaded) {
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: filteredArticles.length,
                      itemBuilder: (context, index) {
                        final article = filteredArticles[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>  ArticleDetailScreen(articleId: article.id),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 800),
                          ),
                        ).then((_) {
                          fetchArticles();
                        });
                            // Navigator.push(context, MaterialPageRoute(
                            //   builder: (context) => ArticleDetailScreen(articleId: article.id),
                            // )).then((_) => fetchArticles());
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(article.title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 1.h),
                                      Text("🖊 Author: ${article.author}", style: TextStyle(color: Colors.grey[700])),
                                      SizedBox(height: 1.h),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,size: 16,)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ArticleError) {
                    return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
