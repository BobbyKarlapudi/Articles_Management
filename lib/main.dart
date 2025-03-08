import 'package:article_management/repositories/article_repository.dart';
import 'package:article_management/screens/articles_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'bloc/article_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType){
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ArticleBloc(ApiService()),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Article App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: ArticlesListScreen(),
            ),
          );
        }
    );
  }
}
