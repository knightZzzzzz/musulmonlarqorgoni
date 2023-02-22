class View {
  int id;
  String name;
  String text;

  View({this.id, this.name, this.text});

  View.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['text'] = this.text;
    return data;
  }
}
