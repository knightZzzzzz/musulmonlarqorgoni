import 'package:musulmonlarqorgoni/common/global.dart';
import 'package:musulmonlarqorgoni/menu.dart';
import 'package:musulmonlarqorgoni/models/category.dart';
import 'package:musulmonlarqorgoni/models/detail.dart';
import 'package:musulmonlarqorgoni/models/view.dart';
import 'package:musulmonlarqorgoni/screens/detail.dart';
import 'package:musulmonlarqorgoni/screens/view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  int index = 0;
  HomeScreen({this.index});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  TabController _tabController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Category> categories = [];
  List<Follow> follows = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < categoryList.length; i++) {
      categories.add(Category.fromJson(categoryList[i]));
    }
    _controller = AnimationController(vsync: this);
    _tabController = new TabController(length: 2, vsync: this);
    if (widget.index == 1) {
      _tabController.index = 1;
    }
    _tabController.addListener(() {
      setChange(_tabController.index);
    });
    setLast();
    getFollow();
  }

  getFollow() async {
    follows = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < dataList.length; i++) {
      //categories.add(Category.fromJson(categoryList[i]));
      Detail detail = Detail.fromJson(dataList[i]);
      bool isFollow = prefs.getBool(
              'flw_' + detail.catId.toString() + '_' + detail.id.toString()) ??
          false;
      if (isFollow) {
        final category =
            categoryList.where((item) => item['id'] == detail.catId).toList();
        follows.add(
            Follow.fromJson({'active': detail.id, 'category': category[0]}));
        //print(follows.length);
      }
    }
    setState(() {});
  }

  Future refreshData(dynamic value) async {
    await getFollow();
    setState(() {});
  }

  setLast() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastview', 0);
    prefs.setInt('lastdetail', 0);
    prefs.setInt('lastactive', 0);
    prefs.setInt('lastsearch', 0);
    prefs.setInt('lastcategory', 0);
    prefs.setInt('lastfollow', widget.index);
  }

  setChange(val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastfollow', val);
    await getFollow();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                brightness: Brightness.dark,
                leading: IconButton(
                    icon: Image.asset("assets/images/menu.png",
                        width: 24, height: 24),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    }),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: Text('Мавзулар'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.search, color: Colors.yellow),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/search');
                      })
                ],
                bottom: TabBar(
                    labelColor: Colors.yellow,
                    controller: _tabController,
                    unselectedLabelColor: Colors.white,
                    labelStyle: TextStyle(fontWeight: FontWeight.w500),
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.normal),
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 2, color: Colors.yellow)),
                    tabs: [
                      Tab(text: 'Барча Дуолар'),
                      Tab(text: 'Танланганлар')
                    ])),
            body: TabBarView(controller: _tabController, children: [
              Container(
                  color: Colors.transparent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => ViewScreen(
                                      item: View.fromJson(viewList[0]))));
                        },
                        child: getCard(
                            "",
                            Category(
                                name: "Ношир муқадиммаси",
                                id: null,
                                menuId: null,
                                menuName: ''))),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => ViewScreen(
                                      item: View.fromJson(viewList[1]))));
                        },
                        child: getCard(
                            "",
                            Category(
                                name: "Муқаддима",
                                id: null,
                                menuId: null,
                                menuName: ''))),
                    for (var i = 0; i < categories.length; i++)
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailScreen(
                                          category: categories[i],
                                        )));
                          },
                          child: getCard(i + 1, categories[i]))
                  ]))),
              Container(
                  color: Colors.transparent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    for (var i = 0; i < follows.length; i++)
                      GestureDetector(
                          onTap: () {
                            //Navigator.push(context,
                            //  MaterialPageRoute(
                            //    builder: (BuildContext context) => DetailScreen(active: follows[i].active, category: follows[i].category),
                            //  )
                            //).then((value) => null);
                            Route route = MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                    active: follows[i].active,
                                    category: follows[i].category));
                            Navigator.push(context, route).then(refreshData);
                          },
                          child: getCardFollow(
                              follows[i].active, follows[i].category))
                  ])))
            ]),
            drawer: Drawer(child: MenuBar())));
  }

  Widget getCard(index, item) {
    return Container(
        height: 64.0,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/margin.png", width: 32.0),
              SizedBox(width: 4.0),
              Expanded(child: Text(item.name, maxLines: 2)),
              SizedBox(width: 4.0),
              Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/stars.png'),
                          fit: BoxFit.cover)),
                  child: Center(
                      child: Text(index.toString(),
                          style: TextStyle(fontSize: 12))))
            ]));
  }

  Widget getCardFollow(index, item) {
    return Container(
        height: 64.0,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/margin.png", width: 32.0),
              SizedBox(width: 4.0),
              Expanded(child: Text(item.name, maxLines: 2)),
              SizedBox(width: 4.0),
              Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/stars.png'),
                          fit: BoxFit.cover)),
                  child: Center(
                      child: Text(index.toString(),
                          style: TextStyle(fontSize: 12))))
            ]));
  }
}
