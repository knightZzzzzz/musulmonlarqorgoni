import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musulmonlarqorgoni/models/uistate.dart';
import 'package:flutter/material.dart';

import 'package:musulmonlarqorgoni/common/global.dart';
import 'package:musulmonlarqorgoni/models/detail.dart';
import 'package:musulmonlarqorgoni/models/category.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  int active = 0;
  final Category category;
  DetailScreen({this.active, this.category});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  TabController _tabController;
  bool isPlay = false;
  bool isPause = false;
  int bottomIndex = 0;
  bool isFollow = false;
  var ui;
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Detail> list = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < dataList.length; i++) {
      final jsonData = Detail.fromJson(dataList[i]);
      if (widget.category.id == jsonData.catId) list.add(jsonData);
    }
    setLast();
    _controller = AnimationController(vsync: this);
    _tabController = new TabController(length: list.length, vsync: this);
    _tabController.addListener(() {
      getFollow();
      setState(() {
        audioPlayer.stop();
        isPlay = false;
        isPause = true;
      });
    });
    //print(_tabController.index);
    //print(list[_tabController.index].audio);
    //if(list[_tabController.index].audio != "")
    //  setupAudio("assets/audios/11.pm3");
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      audioPlayer.startHeadlessService();
    }
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      if (s == AudioPlayerState.COMPLETED) {
        setState(() {
          isPlay = false;
          isPause = true;
        });
      }
    });
    setActive();
    getFollow();
  }

  setActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idx = prefs.getInt('lastactive') ?? 0;
    prefs.setInt('lastactive', idx);
    //print(idx);
    _tabController.index = idx;
    if (widget.active != 0) {
      //print(widget.active);
      for (var i = 0; i < list.length; i++) {
        if (list[i].id == widget.active) {
          _tabController.index = i;
        }
      }
    }
  }

  setLast() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastview', 0);
    prefs.setInt('lastfollow', 0);
    prefs.setInt('lastsearch', 0);
    prefs.setInt('lastcategory', 0);
    prefs.setInt('lastdetail', widget.category.id);
  }

  @override
  void dispose() async {
    super.dispose();
    _controller.dispose();
    _tabController.dispose();
    if (isPlay) {
      await audioPlayer.stop();
    }
  }

  void play(audioUrl) async {
    if (!isPlay) {
      await audioPlayer.play(audioUrl, isLocal: true);
      setState(() {
        isPlay = true;
      });
    } else {
      await audioPlayer.pause();
      setState(() {
        isPlay = false;
        isPause = true;
      });
    }
  }

  void stop() async {
    await audioPlayer.stop();
    setState(() {
      isPlay = false;
      isPause = true;
    });
  }

  void _changeBottomIndex(filePath) async {
    File audiofile = await audioCache.load(filePath);
    play(audiofile.path);
  }

  @override
  Widget build(BuildContext context) {
    ui = Provider.of<UiState>(context);
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
                    icon: Icon(Icons.arrow_back_ios, color: Colors.yellow),
                    onPressed: () {
                      final bool canPop =
                          ModalRoute.of(context)?.canPop ?? false;
                      if (canPop)
                        Navigator.of(context).pop();
                      else
                        Navigator.of(context).pushNamed('/home');
                    }),
                //centerTitle: true,
                backgroundColor: Colors.transparent,
                title: Text(widget.category.name,
                    maxLines: 2, style: TextStyle(fontSize: 16)),
                actions: <Widget>[
                  IconButton(
                      icon: Image.asset("assets/images/font_size.png",
                          width: 24, height: 24),
                      onPressed: () {
                        showDialogFontSize(context);
                      })
                ],
                bottom: TabBar(
                    isScrollable: list.length > 7,
                    labelPadding: EdgeInsets.symmetric(horizontal: 24.0),
                    labelColor: Colors.yellow,
                    controller: _tabController,
                    unselectedLabelColor: Colors.white,
                    labelStyle: TextStyle(fontWeight: FontWeight.w500),
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.normal),
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 2, color: Colors.yellow)),
                    tabs: [
                      for (var i = 0; i < list.length; i++)
                        Tab(text: (i + 1).toString())
                    ])),
            body: TabBarView(controller: _tabController, children: [
              for (var i = 0; i < list.length; i++) getCard(i + 1, list[i])
            ]),
            bottomNavigationBar: BottomNavigationBar(
                elevation: 0,
                selectedFontSize: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.25),
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      label: "Follow",
                      icon: IconButton(
                          icon: getFollowIcon(),
                          onPressed: () async {
                            int idx = _tabController.index;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            bool follow = prefs.getBool('flw_' +
                                    widget.category.id.toString() +
                                    '_' +
                                    list[idx].id.toString()) ??
                                false;
                            prefs.setBool(
                                'flw_' +
                                    widget.category.id.toString() +
                                    '_' +
                                    list[idx].id.toString(),
                                !follow);
                            getFollow();
                          })),
                  BottomNavigationBarItem(
                      label: "Share",
                      icon: IconButton(
                          icon:
                              Icon(Icons.share, color: Colors.yellow, size: 32),
                          onPressed: () {
                            //let text = this.data[this.sctId].arab + "\n" + this.data[this.sctId].text
                            //this.share.share(text)
                            int idx = _tabController.index;
                            String text =
                                list[idx].arab + "\n" + list[idx].text;
                            text += '\nGoogle Play: ' +
                                'http://bit.ly/musulmonlarqurgoni';
                            text +=
                                '\nApp Store: ' + 'https://apple.co/2tcSzh2';
                            //await this.socialSharing.share(text)
                            Share.share(text);
                          }))
                ])));
  }

  Widget getFollowIcon() {
    return Image.asset(
        isFollow ? "assets/images/heart.png" : "assets/images/hearto.png",
        width: 32,
        height: 32);
  }

  getFollow() async {
    int idx = _tabController.index;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFollow = prefs.getBool('flw_' +
              widget.category.id.toString() +
              '_' +
              list[idx].id.toString()) ??
          false;
    });
    prefs.setInt('lastactive', idx);
  }

  Widget getCard(index, Detail item) {
    return Container(
        color: Colors.transparent,
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 0.0),
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(item.arab,
                  style: TextStyle(color: Colors.white, fontSize: ui.fontSize),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right)),
          if (item.audio != "")
            Container(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: _playingButton(index, item.audio)),
          Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(item.text,
                  style: TextStyle(
                      color: Colors.white, fontSize: ui.fontSizeText))),
          if (item.arab1 != "")
            Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(item.arab1,
                    style:
                        TextStyle(color: Colors.white, fontSize: ui.fontSize),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right)),
          if (item.audio1 != "")
            Container(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: _playingButton(index + 1, item.audio1)),
          if (item.text1 != "")
            Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(item.text1,
                    style: TextStyle(
                        color: Colors.white, fontSize: ui.fontSizeText))),
          if (item.arab2 != "")
            Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(item.arab2,
                    style:
                        TextStyle(color: Colors.white, fontSize: ui.fontSize),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right)),
          if (item.audio2 != "")
            Container(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: _playingButton(index + 2, item.audio2)),
          if (item.text2 != "")
            Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(item.text2,
                    style: TextStyle(
                        color: Colors.white, fontSize: ui.fontSizeText))),
          SizedBox(height: 8.0)
        ])));
  }

  Widget _playingButton(index, item) {
    return IconButton(
        iconSize: 64,
        icon: Image.asset(
            (isPlay && bottomIndex == index)
                ? "assets/images/pause.png"
                : "assets/images/play.png",
            width: 64,
            height: 64),
        onPressed: () async {
          audioPlayer.stop();
          setState(() {
            bottomIndex = index;
          });
          _changeBottomIndex("audios/" + item);
        });
  }

  showDialogFontSize(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                    height: 200,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(children: [
                      Column(children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Arabcha matn o'lchami"),
                                  Text(ui.fontSize.toInt().toString())
                                ])),
                        Slider(
                          min: 0.5,
                          activeColor: Colors.yellow[400],
                          inactiveColor: Colors.yellow[300],
                          value: ui.sliderFontSize,
                          onChanged: (newValue) {
                            setState(() {
                              ui.fontSize = newValue;
                            });
                          },
                        )
                      ]),
                      SizedBox(height: 4.0),
                      Column(children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Matn o'lchami"),
                                  Text(ui.fontSizeText.toInt().toString())
                                ])),
                        Slider(
                            min: 0.5,
                            activeColor: Colors.yellow[400],
                            inactiveColor: Colors.yellow[300],
                            value: ui.sliderFontSizeText,
                            onChanged: (newValue) {
                              setState(() {
                                ui.fontSizeText = newValue;
                              });
                            })
                      ])
                    ])));
          });
        });
  }
}
