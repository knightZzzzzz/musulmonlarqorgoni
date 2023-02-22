import 'package:flutter/material.dart';

class PlaylistManager extends ChangeNotifier {
  List<Song> _playList = [];
  int _playIndex = 0;
  Song _currentPlay;
  int get playIndex => _playIndex;
  int get nextIndex => _getNextIndex();
  int get prevIndex => _getPrevIndex();
  List<Song> get playlist => _playList;
  Song get currentPlay => _currentPlay;
  double get getProgress => _getProgress();

  void setPlaylist(items) {
    print('setPlaylist');
    _playList = items;
    // ignore: unnecessary_null_comparison
    if (_currentPlay == null) {
      _currentPlay = items[0];
    }
    print(items.length);
    print(_currentPlay.url);
    notifyListeners();
  }

  int _getPrevIndex() {
    int _prevIndex = playIndex - 1;
    if (_prevIndex < 0) {
      _prevIndex = _playList.length - 1;
    }
    return _prevIndex;
  }

  int _getNextIndex() {
    int _nextIndex = playIndex + 1;
    if (_playList.length != 0 && _nextIndex >= _playList.length) {
      _nextIndex = 0;
    }
    return _nextIndex;
  }

  double _getProgress() {
    if (_playList != null) return nextIndex / _playList.length;
    return 1.0;
  }

  void setPlayIndex(int index) {
    _playIndex = index;
    notifyListeners();
  }

  void addAll(List<Song> list) {
    _playList.addAll(list);
    notifyListeners();
  }

  void setCurrentPlay(Song currentPlay) {
    print('currentPlay.url');
    print(currentPlay.url);
    _playIndex = _playList.indexOf(currentPlay);
    //print(_playList[1].url);
    print(_playIndex);
    _currentPlay = currentPlay;
    notifyListeners();
  }
}

class Song {
  String url;
  String title;
  String image;
  String album;
  String artist;
  Song({this.url, this.title, this.image, this.album, this.artist});
}
