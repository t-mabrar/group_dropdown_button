/// Represents the item returned when a selection is made in the [GroupDropdownButton].
///
/// This class encapsulates the selected item's [key] and [title], and importantly,
/// it includes a reference to its [parent] item in the hierarchy, if any.
/// This allows for easy reconstruction of the selected item's path within a grouped structure.
class DropdownReturnItem {
  /// The unique identifier of the selected item.
  final dynamic key;

  /// The display title of the selected item.
  final String title;

  /// The parent [DropdownReturnItem] in the hierarchy, or `null` if this is a top-level item.
  /// This creates a linked list structure representing the path to the selected item.
  final DropdownReturnItem? parent;

  /// Creates an instance of [DropdownReturnItem].
  ///
  /// [key] and [title] are required. [parent] is optional.
  DropdownReturnItem({required this.key, required this.title, this.parent});

  /// Creates a [DropdownReturnItem] from a JSON map.
  /// This is useful for deserializing item data, especially when dealing with nested parent structures.
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

  /// Converts this [DropdownReturnItem] to a JSON map.
  /// This is useful for serializing item data, including its parent hierarchy.
  Map<String, dynamic> toJson() {
    // Recursively call toJson on the parent if it exists.
    return {'key': key, 'title': title, 'parent': parent?.toJson()};
  }
}
