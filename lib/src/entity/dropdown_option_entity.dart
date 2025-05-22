class GroupedDropdownOption {
  final dynamic key;
  final String title;
  final Map<String, dynamic>? extraInfo;
  final List<GroupedDropdownOption>? subItems;
  final dynamic parentKey;
  final String? parentTitle;

  GroupedDropdownOption({
    required this.key,
    required this.title,
    this.extraInfo,
    this.subItems,
    this.parentKey,
    this.parentTitle,
  }) : assert(key != null, "Key should not be null");

  factory GroupedDropdownOption.fromJSON(Map<String, dynamic> json) {
    return GroupedDropdownOption(
      key: json['key'],
      title: json['title'],
      subItems: json['sub_items'] ?? [],
      extraInfo: json['extra_info'] ?? {},
      parentKey: json['parent_key'],
      parentTitle: json['parent_title'] ?? "",
    );
  }

  Map<String, dynamic> toJSON() {
    List<Map<String, dynamic>> _tempSubItems =
        (subItems ?? [])
            .map(
              (eachItem) => {
                'key': eachItem.key,
                'title': eachItem.title,
                'extra_info': eachItem.extraInfo ?? {},
              },
            )
            .toList();
    return {
      'key': key,
      'title': title,
      'extra_info': extraInfo ?? {},
      'sub_items': _tempSubItems,
      'parent_key': parentKey,
      'parent_title': parentTitle,
    };
  }
}
