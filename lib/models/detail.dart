class Detail {
  int id;
  int catId;
  String audio;
  String audio1;
  String audio2;
  String catName;
  String name;
  String arab;
  String arab1;
  String arab2;
  String text;
  String text1;
  String text2;

  Detail(
      {this.id,
      this.catId,
      this.audio,
      this.audio1,
      this.audio2,
      this.catName,
      this.name,
      this.arab,
      this.arab1,
      this.arab2,
      this.text,
      this.text1,
      this.text2});

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catId = json['catId'];
    audio = json['audio'];
    audio1 = json['audio1'] ?? "";
    audio2 = json['audio2'] ?? "";
    catName = json['catName'];
    name = json['name'];
    arab = json['arab'];
    arab1 = json['arab1'] ?? "";
    arab2 = json['arab2'] ?? "";
    text = json['text'];
    text1 = json['text1'] ?? "";
    text2 = json['text2'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['catId'] = this.catId;
    data['audio'] = this.audio;
    data['audio1'] = this.audio1;
    data['audio2'] = this.audio2;
    data['catName'] = this.catName;
    data['name'] = this.name;
    data['arab'] = this.arab;
    data['arab1'] = this.arab1;
    data['arab2'] = this.arab2;
    data['text'] = this.text;
    data['text1'] = this.text1;
    data['text2'] = this.text2;
    return data;
  }
}
