class DropdownReturnItem {
  final dynamic key;
  final String title;
  final DropdownReturnItem? parent;

  DropdownReturnItem({required this.key, required this.title, this.parent});

  factory DropdownReturnItem.fromJson(Map<String, dynamic> json) {
    return DropdownReturnItem(
      key: json['key'],
      title: json['title'],
      parent:
          json['parent'] != null
              ? DropdownReturnItem.fromJson(json['parent'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'title': title, 'parent': parent?.toJson()};
  }
}
