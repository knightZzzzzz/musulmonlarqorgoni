class Category {
  int id;
  int menuId;
  String menuName;
  String name;

  Category({this.id, this.menuId, this.menuName, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuId = json['menuId'];
    menuName = json['menuName'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['menuId'] = this.menuId;
    data['menuName'] = this.menuName;
    data['name'] = this.name;
    return data;
  }
}

class Follow {
  int active;
  Category category;

  Follow({this.active, this.category});

  Follow.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    category = Category.fromJson(json['category']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}
