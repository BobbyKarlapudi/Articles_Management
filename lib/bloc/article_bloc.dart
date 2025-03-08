import 'package:article_management/repositories/article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'article_event.dart';
import 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ApiService apiService;

  ArticleBloc(this.apiService) : super(ArticleInitial()) {

    on<FetchArticles>((event, emit) async {
      emit(ArticlesLoading());
      try {
        final articles = await apiService.fetchArticles(page: event.page, size: event.size);
        emit(ArticlesLoaded(articles));
      } catch (e) {
        emit(ArticleError(e.toString()));
      }
    });

    on<FetchArticleById>((event, emit) async {
      emit(ArticlesLoading());
      try {
        final article = await apiService.fetchArticleById(event.id);
        emit(ArticleLoaded(article));
      } catch (e) {
        emit(ArticleError(e.toString()));
      }
    });

    on<CreateArticle>((event, emit) async {
      try {
        await apiService.createArticle(event.articleData);
        emit(CreateArticleSuccess());
      } catch (e) {
        emit(ArticleError(e.toString()));
      }
    });

    on<UpdateArticle>((event, emit) async {
      try {
        await apiService.updateArticle(event.id, event.updates);
        emit(UpdateArticleSuccess());
      } catch (e) {
        emit(ArticleError(e.toString()));
      }
    });

  }
}
