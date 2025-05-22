/// Represents a single item that can be displayed in the [GroupDropdownButton].
///
/// This class defines the structure for an item, including its unique [key],
/// display [title], optional [extraInfo], and a list of [subItems] for creating
/// hierarchical or grouped dropdowns. It also supports parent-child relationships
/// through [parentKey] and [parentTitle].
class DropdownButtonItem {
  /// A unique identifier for the dropdown item. Can be of any dynamic type.
  /// This is asserted to be non-null.
  final dynamic key;

  /// The text to be displayed for this item in the dropdown list and
  /// in the text field when selected.
  final String title;

  /// Optional additional information associated with the item.
  /// This can be any custom data.
  final Map<String, dynamic>? extraInfo;

  /// A list of [DropdownButtonItem]s that are children of this item,
  /// allowing for nested or grouped structures.
  final List<DropdownButtonItem>? subItems;

  /// The key of the parent item, if this item is a sub-item.
  final dynamic parentKey;

  /// The title of the parent item, if this item is a sub-item.
  final String? parentTitle;

  /// Creates an instance of [DropdownButtonItem].
  DropdownButtonItem({
    required this.key,
    required this.title,
    this.extraInfo,
    this.subItems,
    this.parentKey,
    this.parentTitle,
  }) : assert(key != null, "Key should not be null");

  /// Creates a [DropdownButtonItem] from a JSON map.
  ///
  /// This is useful for deserializing item data.
  /// - `json['key']` maps to [key].
  /// - `json['title']` maps to [title].
  /// - `json['sub_items']` maps to [subItems], defaulting to an empty list if null.
  /// - `json['extra_info']` maps to [extraInfo], defaulting to an empty map if null.
  /// - `json['parent_key']` maps to [parentKey].
  /// - `json['parent_title']` maps to [parentTitle], defaulting to an empty string if null.
  factory DropdownButtonItem.fromJSON(Map<String, dynamic> json) {
    return DropdownButtonItem(
      key: json['key'],
      title: json['title'],
      subItems: json['sub_items'] ?? [],
      extraInfo: json['extra_info'] ?? {},
      parentKey: json['parent_key'],
      parentTitle: json['parent_title'] ?? "",
    );
  }

  /// Converts this [DropdownButtonItem] to a JSON map.
  ///
  /// This is useful for serializing item data.
  Map<String, dynamic> toJSON() {
    // Convert sub-items to a list of JSON maps.
    List<Map<String, dynamic>> tempSubItems =
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
      'sub_items': tempSubItems,
      'parent_key': parentKey,
      'parent_title': parentTitle,
    };
  }
}
