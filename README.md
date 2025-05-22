# 🧩 GroupDropdownButton

A powerful, customizable Flutter widget for rendering **grouped, searchable, recursive dropdowns** with support for radio buttons, check indicators, and dynamic overlays.

> Ideal for apps that require deeply nested, categorized selections with a sleek Material look.

---

## 🚀 Features

- ✅ Grouped dropdown items with support for recursive nesting
- 🔍 Live search & filtering
- 🧩 Custom prefix/suffix widgets
- 🎯 Radio button or check icon for selected item
- 🌈 Fully customizable styling and borders
- 📐 Overlay-based dropdown with smart positioning
- 🔃 ExpansionTile-based group rendering
- ⚠️ Inline error display and required field validation
---

## 📸 Screenshots

<!-- 🖼️ Add a GIF or screenshots here showcasing the widget in action! -->
<!-- e.g.,
!Group Dropdown Demo
-->
*A visual demonstration speaks volumes! Consider adding one here.*

## 🛠️ Installation

1.  Add this gem to your package's `pubspec.yaml` file:

    ```yaml
    dependencies:
      group_dropdown_button: ^latest_version # 👈 Replace with the actual version from pub.dev
    ```

2.  Install it by running:

    ```bash
    flutter pub get
    ```

## 📖 Usage

### 1. Import the Package

```dart
import 'package:group_dropdown_button/group_dropdown_button.dart';
```

### 2. Define Your Data

Structure your items using the `GroupedDropdownOption` class. Each group can contain `subItems`.

```dart
final List<GroupedDropdownOption> myCategorizedItems = [
  GroupedDropdownOption(
    key: "fruits",
    title: "🍓 Fruits", // Emojis in titles can be fun!
    subItems: [
      GroupedDropdownOption(key: "apple", title: "Apple"),
      GroupedDropdownOption(key: "banana", title: "Banana"),
      GroupedDropdownOption(key: "orange", title: "Orange"),
    ],
  ),
  GroupedDropdownOption(
    key: "vegetables",
    title: "🥦 Vegetables",
    subItems: [
      GroupedDropdownOption(key: "carrot", title: "Carrot"),
      GroupedDropdownOption(key: "broccoli", title: "Broccoli"),
      GroupedDropdownOption(key: "spinach", title: "Spinach"),
    ],
  ),
  // Add more groups as needed.
  // Remember: You need at least two top-level GroupedDropdownOption items.
];
```

### 3. Use the `GroupDropdownButton` Widget

Here's a practical example:

```dart
 GroupDropdownButton(
    items: myCategorizedItems,
    onSelect: (GroupedDropdownOption? selectedOption) {
      setState(() {
        _selectedItem = selectedOption;
      });
      if (selectedOption != null) {
        print('Selected: ${selectedOption.title} (Key: ${selectedOption.key})');
        print('Parent: ${selectedOption.parentTitle} (Key: ${selectedOption.parentKey})');
        if (selectedOption.extraInfo != null) {
          print('Extra Info: ${selectedOption.extraInfo}');
        }
      }
    },
    // initialValue: myCategorizedItems.first.subItems?.first, // Example initial value
    hintText: "Select an item...",
    labelText: "Choose a Category",
    buttonWidth: double.infinity,
    isRequired: true,
    errorText: "Oops! Please pick an item.",
    // --- 🎨 Explore further customization! ---
    // itemPrefix: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blueGrey),
    // eachGroupIsExpansion: true,
    // showDividerBtwGroups: true,
    // enabledRadioForItems: false, // Cannot be true if showCheckForSelected is true
    // showCheckForSelected: true,
    // checkWidgetForSelectedItem: Icon(Icons.task_alt_rounded, color: Colors.green, size: 20),
    // borderRadius: 12.0,
    // borderType: TextFieldInputBorder.outLine,
    // focusedBorderColor: Colors.deepPurpleAccent,
  )
```

## 🎨 Customization Options

The `GroupDropdownButton` is packed with properties to tailor its look and feel.

### Quick Customization Overview

| Property                                                | Description                                              |
| ------------------------------------------------------- | -------------------------------------------------------- |
| `buttonWidth`                                           | Width of the dropdown trigger button                     |
| `isRequired`                                            | Enables validation if true                               |
| `hintText`, `labelText`                                 | Hint/Label display inside the text field                 |
| `itemPrefix`                                            | Adds a widget before every dropdown item                 |
| `showCheckForSelected`                                  | Displays check icon on selected item                     |
| `enabledRadioForItems`                                  | Displays radio button instead of check icon              |
| `eachGroupIsExpansion`                                  | Renders nested groups with `ExpansionTile`               |
| `borderType`                                            | Customizable input border type (outline, underline, etc) |
| `borderColor`, `focusedBorderColor`, `errorBorderColor` | Fine-tune border states                                  |


### Detailed Properties

#### Core Properties

-   `items`: (Required) `List<GroupedDropdownOption>` - Your categorized data. Must not be empty and needs at least two top-level groups.
-   `onSelect`: (Required) `ValueChanged<GroupedDropdownOption?>` - The heart of the selection! Callback when an item is chosen.
-   `initialValue`: `GroupedDropdownOption?` - Pre-select an item to start.
-   `buttonWidth`: `double` - Set the dropdown button's width (defaults to `300.0`).

#### Input Field Appearance (via internal `DropdownTextField`)

-   `hintText`: `String?` - Placeholder text.
-   `labelText`: `String?` - Label floating above the field.
-   `prefix`: `Widget?` - Icon or widget before the input text.
-   `suffix`: `Widget?` - Icon or widget after the input text (defaults to an animated dropdown arrow).
-   `contentPadding`: `EdgeInsets?` - Inner padding of the field.
-   `borderRadius`: `double` - Corner roundness for outline borders (defaults to `5.0`).
-   `borderType`: `TextFieldInputBorder` - Choose `TextFieldInputBorder.outLine` (default) or `TextFieldInputBorder.underLine`.
-   `borderColor`, `enabledBorderColor`, `focusedBorderColor`, `errorBorderColor`, `focusedErrorBorderColor`: `Color?` - Fine-tune border colors for different states.

#### Item & Group Display

-   `itemPrefix`: `Widget?` - A leading widget for each selectable item in the list.
-   `enabledRadioForItems`: `bool` - Show radio buttons for selection (defaults to `false`). *Note: Cannot be `true` if `showCheckForSelected` is `true`.*
-   `showCheckForSelected`: `bool` - Display a check mark (or custom widget) next to the selected item (defaults to `false`). *Note: Cannot be `true` if `enabledRadioForItems` is `true`.*
-   `checkWidgetForSelectedItem`: `Widget?` - Your custom check mark widget if `showCheckForSelected` is `true`.
-   `showDividerBtwGroups`: `bool` - Add a visual separator line between groups (defaults to `false`).
-   `eachGroupIsExpansion`: `bool` - Make group titles act like `ExpansionTile` headers (collapsible, defaults to `false`).

#### Validation

-   `isRequired`: `bool` - If `true`, selection is mandatory for form validation (defaults to `false`).
-   `errorText`: `String?` - Custom error message for validation failures (defaults to "This field is required").

#### Theming 🌈

The widget smartly adapts to your app's `ThemeData` (text styles, primary color, error color, icon colors via `AppContext` extension). You can always override these by providing specific color properties directly.

## 🧱 `GroupedDropdownOption` Data Structure

This class is the blueprint for your dropdown items (both groups and their sub-items).

```dart
class GroupedDropdownOption {
  final dynamic key; // Unique identifier (String, int, etc.)
  final String title; // Display text for the option
  final Map<String, dynamic>? extraInfo; // Optional bag for extra data
  final List<GroupedDropdownOption>? subItems; // Child items for group options
  final dynamic parentKey; // Auto-populated: Key of the parent group
  final String? parentTitle; // Auto-populated: Title of the parent group

  GroupedDropdownOption({
    required this.key,
    required this.title,
    this.extraInfo,
    this.subItems,
    // parentKey and parentTitle are typically derived, not manually set for subItems.
  });
}
```

## 🤝 Contributing

Contributions make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**!

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📜 License

Distributed under the MIT License. See `LICENSE` file for more information.
<!-- Create a LICENSE file if you don't have one, e.g., with the MIT license text -->
