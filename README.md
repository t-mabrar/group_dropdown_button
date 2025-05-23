# 🧩 GroupDropdownButton

A powerful, customizable Flutter widget for rendering **grouped, searchable, recursive dropdowns** with support for radio buttons, check indicators, and dynamic overlays.

> Ideal for apps that require deeply nested, categorized selections with a sleek Material look.

---

## 📚 Table of Contents

- [🚀 Features](#-features)
- [📸 Screenshots](#-screenshots)
- [🛠️ Installation](#-installation)
- [📖 Usage](#-usage)
- [🎨 Customization Options](#-customization-options)
- [🧱 GroupedDropdownOption Data Structure](#-groupeddropdownoption-data-structure)
- [📁 Package Folder Structure (for reference)](#-package-folder-structure-for-reference)
- [🤝 Contributing](#-contributing)
- [📜 License](#-license)

---

## 🚀 Features
[⬆Table of Contents](#-table-of-contents)

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
[⬆Table of Contents](#-table-of-contents)

## `GroupDropdownButton`

<img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/basic_demo.gif" alt="GroupDropdownButton" width="400" height="400">

#### Selected item response from `onSelect`

<img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/child_item_selected.png" alt="Child item selected" width="550" height="400">


#### `showCheckForSelected` -  takes boolean value and displays check icon on selected item, true to enable & false to disable, default `false`

| Check Icon enabled | Check Icon disabled |
| ------------------ | ----------------- |
| <img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/check_widget_enabled.png" alt="Check icon enabled" width="400" height="400"> | <img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/check_widget_disabled.png" alt="Check icon disabled" width="400" height="400">|


#### `checkWidgetForSelectedItem` -  takes Widget can replace check icon widget with custom widget, `checkWidgetForSelectedItem: Icon(Icons.abc)`, deafult `null`

<img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/custom_check_widget.png" alt="custom check widget" width="400" height="400">

#### `itemPrefix` -  takes Widget, adds widget as prefix to every item not for group title, default `null`

| `itemPrefix: Icon(Icons.arrow_forward)` | `itemPrefix: Icon(Icons.adb_sharp)` |
| ------------------ | ----------------- |
| <img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/custom_prefix_widget_item_1.png" alt="Custom prefix widget 1" width="400" height="400"> | <img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/custom_prefix_widget_item_2.png" alt="Custom prefix widget 2" width="400" height="400">|

#### `showDividerBtwGroups` - takes boolean value and displays divider between groups, true to show & false to hide, default `false`

<img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/divider_hide_show.png" alt="Show divider" width="400" height="400">

#### If any options have not items to select that is considered as item not as group

<img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/option_without_items_can_selected.png" alt="option_without_items_can_selected" width="400" height="400">

#### `enabledRadioForItems` - takes boolean value and displays radio button as prefix to every item not for group title, true to show & false to hide, default `false`

<img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/radio_button_as_prefix_item.png" alt="radio_button_as_prefix_item" width="400" height="400">

#### `eachGroupIsExpansion` - takes boolean value and renders nested groups with `ExpansionTile`, true to enable & false to disable, default `false`

<img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/support_expand_collapse_on_groups.gif" alt="support_expand_collapse_on_groups" width="400" height="400">

#### `borderType` -  takes enum `TextFieldInputBorder`, to show outline border or underline border to the textfield, default `TextFieldInputBorder.outLine`

| `borderType: TextFieldInputBorder.outLine` | `borderType: TextFieldInputBorder.underLine` |
| ------------------ | ----------------- |
| <img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/out_line_text_field.png" alt="out_line_text_field" width="400" height="400"> | <img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/under_line_text_field.png" alt="under_line_text_field" width="400" height="400">|

#### `isRequired` - takes boolean value and manages to enable or disable validator to the textfield, default `false`
#### `errorText` - tabkes string value and overides the default error message to custom error message, default `This field is required`, works only if `isRequired` is `true`

| `isRequired: true` | `isRequired: true, errorText: "Oops! Please pick an item."` |
| ------------------ | ----------------- |
| <img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/validator_with_default_error.png" alt="validator_with_default_error" width="400" height="400"> | <img src="https://raw.githubusercontent.com/t-mabrar/group_dropdown_button/refs/heads/main/screenshots/validator_with_custom_error.png" alt="validator_with_custom_error" width="400" height="400">|


## 🛠️ Installation
[⬆Table of Contents](#-table-of-contents)

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
[⬆Table of Contents](#-table-of-contents)

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
[⬆Table of Contents](#-table-of-contents)

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

The widget smartly adapts to your app's `ThemeData` (text styles, primary color, error color, icon colors via `AppContext` extension). You can always override these by providing specific color properties directly from your theme.

## 🧱 `GroupedDropdownOption` Data Structure
[⬆Table of Contents](#-table-of-contents)

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
---

## 📁 Package Folder Structure (for reference)
[⬆Table of Contents](#-table-of-contents)

```
lib/
├── group_dropdown_button.dart
├── src/
│   ├── entity/
│   │   └── dropdown_return_item.dart
│   ├── utils/
│   │   └── extensions.dart
│   └── widgets/
│       ├── text_field.dart
│       └── no_options.dart
```
---

## 🤝 Contributing
[⬆Table of Contents](#-table-of-contents)

Contributions make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**!

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📜 License
[⬆Table of Contents](#-table-of-contents)

Distributed under the MIT License. See `LICENSE` file for more information.
<!-- Create a LICENSE file if you don't have one, e.g., with the MIT license text -->
