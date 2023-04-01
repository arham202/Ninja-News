import 'package:flutter/material.dart';

import '../components/Category_card.dart';
import '../components/data.dart';
import '../components/news.dart';
import '../components/widgets.dart';
import '../models/Articles.dart';
import '../models/CategoryModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late bool _loading;
  List<Article> newslist = [];
  List<CategoryModel> categories = [];

  Future<void> getNews() async {
    News news = News();
    await news.getNews();

    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading  = true;
    super.initState();
    categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ninja News'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.orangeAccent,Colors.red]),
          ),
        ),
      ),
      body: SafeArea(
        child: _loading ?
        const Center(
          child: CircularProgressIndicator(),
        )
        : SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      imageAssetUrl: categories[index].imageAssetUrl,
                      categoryName: categories[index].categoryName,
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: ListView.builder(
                  itemCount: newslist.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return NewsTile(
                      imgUrl: newslist[index].urlToImage ?? "",
                      title: newslist[index].title ?? "",
                      desc: newslist[index].description ?? "",
                      content: newslist[index].content ?? "",
                      posturl: newslist[index].articleUrl ?? "",
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
