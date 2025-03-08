import 'package:article_management/models/article_model.dart';
import 'package:equatable/equatable.dart';

abstract class ArticleState extends Equatable {
  @override
  List<Object> get props => [];
}

class ArticleInitial extends ArticleState {}

class ArticlesLoading extends ArticleState {}

class ArticlesLoaded extends ArticleState {
  final List<Article> articles;
  ArticlesLoaded(this.articles);
}

class ArticleLoaded extends ArticleState {
  final Article article;
  ArticleLoaded(this.article);
}

class ArticleError extends ArticleState {
  final String message;
  ArticleError(this.message);
}

class CreateArticleSuccess extends ArticleState {}

class UpdateArticleSuccess extends ArticleState {}