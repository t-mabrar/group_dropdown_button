import 'package:flutter/material.dart';
import 'package:group_dropdown_button/group_dropdown_button.dart';
import 'package:group_dropdown_button/src/entity/dropdown_return_item.dart';
import 'package:group_dropdown_button/src/utils/extensions.dart';
import 'package:group_dropdown_button/src/widgets/text_field.dart';
import 'package:group_dropdown_button/src/widgets/no_options.dart';

/// A dropdown button widget that supports grouping of items,
/// search functionality, and extensive customization.
///
/// This widget allows users to select an item from a list, which can be
/// organized into hierarchical groups. It provides a text field for display
/// and interaction, which can be styled and configured.
class GroupDropdownButton extends StatefulWidget {
  /// The list of [DropdownButtonItem] to display in the dropdown.
  /// Each item can have sub-items, creating a grouped structure.
  final List<DropdownButtonItem> items;

  /// Callback function that is called when an item is selected.
  /// It receives a [DropdownReturnItem] which includes the selected item's
  /// key, title, and its parent hierarchy, or `null` if the selection is cleared.
  final ValueChanged<DropdownReturnItem?> onSelect;

  /// The width of the dropdown button. Defaults to `300.0`.
  final double buttonWidth;

  /// An optional widget to display as a prefix for each item in the dropdown list.
  final Widget? itemPrefix;

  /// Whether the dropdown field is required. If `true`, a validator will
  /// enforce that a selection is made. Defaults to `false`.
  final bool isRequired;

  /// Custom error text to display when [isRequired] is `true` and no item is selected.
  /// If `null`, a default error message is used.
  final String? errorText;

  /// The initially selected item. If provided, its title will be displayed
  /// in the text field when the widget is first built.
  final DropdownButtonItem? initialValue;

  /// Hint text to display in the text field when no item is selected.
  final String? hintText;

  /// Label text to display above the text field.
  final String? labelText;

  /// An optional widget to display as a prefix inside the text field.
  final Widget? prefix;

  /// An optional widget to display as a suffix inside the text field.
  /// Defaults to an animated dropdown arrow.
  final Widget? suffix;

  /// If `true`, radio button-like indicators are shown for items,
  /// visually representing the selection. Defaults to `false`.
  /// Cannot be used simultaneously with [showCheckForSelected].
  final bool enabledRadioForItems;

  /// If `true`, a divider is shown between groups in the dropdown list.
  /// Defaults to `false`.
  final bool showDividerBtwGroups;

  /// If `true`, each group in the dropdown list behaves as an expansion tile,
  /// allowing it to be collapsed or expanded. Defaults to `false`.
  final bool eachGroupIsExpansion;

  /// If `true`, a check mark (or [checkWidgetForSelectedItem]) is shown
  /// next to the selected item in the dropdown list. Defaults to `false`.
  /// Cannot be used simultaneously with [enabledRadioForItems].
  final bool showCheckForSelected;

  /// A custom widget to use as the check mark when [showCheckForSelected] is `true`.
  /// If `null`, a default check icon is used.
  final Widget? checkWidgetForSelectedItem;

  /// Custom padding for the content inside the text field.
  final EdgeInsets? contentPadding;

  /// The border radius for the text field. Defaults to `5.0`.
  final double borderRadius;

  /// The type of border for the text field (outline or underline).
  /// Defaults to [TextFieldInputBorder.outLine].
  final TextFieldInputBorder borderType;

  /// The color of the text field's border.
  final Color? borderColor;

  /// The color of the text field's border when it is enabled.
  final Color? enabledBorderColor;

  /// The color of the text field's border when it is focused.
  final Color? focusedBorderColor;

  /// The color of the text field's border when it has an error.
  final Color? errorBorderColor;

  /// The color of the text field's border when it is focused and has an error.
  final Color? focusedErrorBorderColor;

  /// Helper method to recursively find an item by its key within a list of [DropdownButtonItem]s.
  /// Returns the [DropdownButtonItem] if found, otherwise `null`.
  static DropdownButtonItem? _findItemByKeyRecursively(
    List<DropdownButtonItem> items,
    dynamic targetKey,
  ) {
    for (final item in items) {
      if (item.key == targetKey) {
        return item;
      }
      if (item.subItems != null && item.subItems!.isNotEmpty) {
        final foundInSub = _findItemByKeyRecursively(item.subItems!, targetKey);
        if (foundInSub != null) {
          return foundInSub;
        }
      }
    }
    return null;
  }

  GroupDropdownButton({
    super.key,
    required this.items,
    required this.onSelect,
    this.initialValue,
    this.itemPrefix,
    this.eachGroupIsExpansion = false,
    this.showDividerBtwGroups = false,
    this.hintText,
    this.labelText,
    this.prefix,
    this.suffix,
    this.buttonWidth = 300.0,
    this.isRequired = false,
    this.enabledRadioForItems = false,
    this.contentPadding,
    this.errorText,
    this.showCheckForSelected = false,
    this.checkWidgetForSelectedItem,
    this.borderRadius = 5.0,
    this.borderType = TextFieldInputBorder.outLine,
    this.borderColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.focusedErrorBorderColor,
  }) : assert(
         items.isNotEmpty && items.length >= 2,
         "items can't be empty, at least 2 or more items are required",
       ),
       assert(
         !(enabledRadioForItems && showCheckForSelected),
         "Cannot use both radio and check selection UI simultaneously",
       ),
       assert(
         initialValue == null ||
             _findItemByKeyRecursively(items, initialValue.key) != null,
         "Initial value with key '${initialValue.key}' must exist in the items list. Please ensure the key matches an existing item.",
       ),
       assert(
         initialValue == null ||
             (_findItemByKeyRecursively(
                   items,
                   initialValue.key,
                 )?.subItems?.isEmpty ??
                 true),
         "Initial value with key '${initialValue?.key}' cannot be a group (i.e., it must not have subItems). It must be a selectable leaf item.",
       );

  @override
  State<GroupDropdownButton> createState() => _GroupDropdownButtonState();
}

/// State class for [GroupDropdownButton].
class _GroupDropdownButtonState extends State<GroupDropdownButton> {
  /// Overlay entry for the dropdown list.
  OverlayEntry? dropdownOverlayEntry;

  /// LayerLink to connect the dropdown overlay with the text field.
  final dropdownLayerLink = LayerLink();

  /// Controller for the text field.
  final textFieldController = TextEditingController();

  /// GlobalKey for the CompositedTransformTarget widget, used to get the position and size of the text field.
  final selectorKey = GlobalKey();

  /// The list of items currently displayed in the dropdown, which can be filtered.
  late List<DropdownButtonItem> dropdownGroupedItems;

  @override
  void dispose() {
    textFieldController.dispose();
    dropdownOverlayEntry = null;
    dropdownOverlayEntry?.remove();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // After the first frame is rendered, set the initial value if provided.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue != null) {
        textFieldController.text = widget.initialValue!.title;
      }
    });

    // Initialize the displayed items with the full list from the widget.
    dropdownGroupedItems = List.from(widget.items);
  }

  @override
  void didUpdateWidget(covariant GroupDropdownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the items list has changed, update the internal list.
    // This also handles the case where the search might be active,
    // so we reset to the new full list.
    if (widget.items != oldWidget.items) {
      dropdownGroupedItems = List.from(widget.items);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This method is called when dependencies of this State object change.
    // For example, if you were using an InheritedWidget and its value changed.
    // In this specific widget, there aren't obvious direct dependencies that
    // would typically be handled here, but it's good practice to include the override
    // if you anticipate needing it or for completeness.
    // Example:
    // final locale = Localizations.localeOf(context);
    // if (_cachedLocale != locale) {
    //   _cachedLocale = locale;
    //   // Do something based on locale change
    // }
  }

  /// Constructs a [DropdownReturnItem] with its complete parent hierarchy.
  ///
  /// [currentItem] is the item for which to build the return structure.
  /// [roots] are the top-level items to search within.
  /// [parentChain] is the recursively built parent item.
  DropdownReturnItem _buildReturnItemWithParents(
    DropdownButtonItem currentItem,
    List<DropdownButtonItem> roots, {
    DropdownReturnItem? parentChain,
  }) {
    for (final root in roots) {
      if (root.key == currentItem.key) {
        // Found the item at the root level.
        return DropdownReturnItem(
          key: root.key,
          title: root.title,
          parent: parentChain,
        );
      }

      // Recursive helper to traverse sub-items.
      DropdownReturnItem? traverse(
        DropdownButtonItem item,
        DropdownReturnItem? currentParent,
      ) {
        if (item.key == currentItem.key) {
          // Found the item.
          return DropdownReturnItem(
            key: item.key,
            title: item.title,
            parent: currentParent,
          );
        }
        // Check in sub-items.
        for (final child in item.subItems ?? []) {
          final parentForChild = DropdownReturnItem(
            key: item.key,
            title: item.title,
            parent: currentParent,
          );
          final match = traverse(child, parentForChild);
          if (match != null) return match;
        }

        return null;
      }

      // Start traversal from the current root.
      final match = traverse(root, null);
      if (match != null) return match;
    }

    // Fallback if item not found in the provided roots (should ideally not happen if currentItem is from widget.items).
    return DropdownReturnItem(
      key: currentItem.key,
      title: currentItem.title,
      parent: parentChain,
    );
  }

  /// Estimates the vertical height of the dropdown content.
  /// This is used to help position the overlay more accurately, especially when content is small.
  double _estimateDropdownContentHeight() {
    if (dropdownGroupedItems.isEmpty) {
      // Approximate height for the 'No options available' message.
      return 60.0;
    }

    double totalHeight = 0;
    // Approximate heights for list items and group headers.
    // These could be further refined or made configurable if needed.
    const double estimatedItemRowHeight =
        42.0; // For a typical ListTile-like item.
    const double estimatedExpansionTileHeader =
        48.0; // Standard ExpansionTile header.
    const double dividerHeight = 1.0;

    // Recursive helper to estimate height of sub-items.
    double calculateSubItemsHeight(List<DropdownButtonItem> subItems) {
      double height = 0;
      for (final item in subItems) {
        // Check if the sub-item is itself a group (has further sub-items).
        if (item.subItems?.isNotEmpty ?? false) {
          height += estimatedExpansionTileHeader;
          height += calculateSubItemsHeight(item.subItems!);
          // Assuming divider is shown for nested groups if configured.
          if (widget.showDividerBtwGroups && widget.eachGroupIsExpansion) {
            height += dividerHeight;
          }
        } else {
          height += estimatedItemRowHeight;
        }
      }
      return height;
    }

    for (int i = 0; i < dropdownGroupedItems.length; i++) {
      final group = dropdownGroupedItems[i];
      if (group.subItems?.isNotEmpty ?? false) {
        totalHeight += estimatedExpansionTileHeader;
        totalHeight += calculateSubItemsHeight(group.subItems!);
        if (widget.showDividerBtwGroups &&
            i < dropdownGroupedItems.length - 1) {
          totalHeight += dividerHeight;
        }
      } else {
        totalHeight += estimatedItemRowHeight; // Direct item or group title.
      }
    }
    return totalHeight > 0
        ? totalHeight
        : estimatedItemRowHeight; // Ensure a minimum if not empty.
  }

  /// Builds the title widget for a group.
  Widget groupTitle(DropdownButtonItem eachGroup) => Text(
    eachGroup.title,
    style: context.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  );

  /// Builds the list of item widgets for a group, handling nested groups via [ExpansionTile].
  List<Widget> groupItems(DropdownButtonItem eachGroup) => [
    if ((eachGroup.subItems ?? []).isEmpty)
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        child: Text("---No Results Found---"),
      )
    else
      ...(eachGroup.subItems ?? []).map((eachItem) {
        // Check if the current sub-item itself has sub-items (is a nested group).
        bool containsLevel2 = false;
        if (eachItem.subItems != null) {
          containsLevel2 = eachItem.subItems!.isNotEmpty;
        }
        return containsLevel2
            // If it's a nested group, render it as an ExpansionTile.
            ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ExpansionTile(
                trailing: widget.eachGroupIsExpansion ? null : SizedBox(),
                enabled: widget.eachGroupIsExpansion,
                dense: true,
                maintainState: true,
                tilePadding: EdgeInsets.zero,
                shape:
                    widget.showDividerBtwGroups
                        ? Border(bottom: BorderSide(color: Colors.black))
                        : InputBorder.none,
                initiallyExpanded: true,
                title: groupTitle(eachItem),
                children: groupItems(eachItem),
              ),
            )
            // Otherwise, render it as a regular item.
            : groupItem(eachItem: eachItem);
      }),
  ];

  /// Builds a single item widget for the dropdown list.
  Widget groupItem({
    required DropdownButtonItem eachItem,
    bool isTitle = false,
  }) {
    // Determine if the current item is the selected one.
    final isSelected = eachItem.title.toString() == textFieldController.text;
    return Container(
      width: double.infinity,
      color: isSelected ? Colors.grey.withAlpha(50) : Colors.transparent,
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTitle ? 5.0 : 15.0,
            vertical: 7.0,
          ),
          child: Row(
            children: [
              // Radio button UI if enabled.
              if (widget.enabledRadioForItems) ...[
                Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    shape: BoxShape.circle,
                  ),
                  child:
                      isSelected
                          ? Padding(
                            padding: EdgeInsets.all(2.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                          : null,
                ),
              ],
              if (widget.enabledRadioForItems) SizedBox(width: 5.0),
              // Item prefix if provided.
              if (widget.itemPrefix != null) ...[
                widget.itemPrefix!,
                SizedBox(width: 5.0),
              ],
              // Item title.
              Expanded(
                child: Text(
                  eachItem.title,
                  style: (isTitle
                          ? context.textTheme.bodyLarge
                          : context.textTheme.titleSmall)!
                      .copyWith(
                        fontWeight:
                            isTitle ? FontWeight.bold : FontWeight.normal,
                        color: isTitle ? Colors.grey : Colors.black,
                      ),
                ),
              ),
              // Check mark UI if enabled and item is selected.
              if (isSelected && widget.showCheckForSelected) ...[
                widget.checkWidgetForSelectedItem ??
                    Icon(Icons.check_circle, color: Colors.green),
              ],
            ],
          ),
        ),
        onTap: () {
          // Build the return item with parent hierarchy.
          final returnItem = _buildReturnItemWithParents(
            eachItem,
            widget.items,
          );

          widget.onSelect(returnItem);
          textFieldController.text = eachItem.title;
          // Close the dropdown.
          dropdownOverlayEntry?.remove();
          dropdownOverlayEntry = null;
          setState(() {});
        },
      ),
    );
  }

  /// Creates and returns the [OverlayEntry] for the dropdown list.
  OverlayEntry optionsOverlayEntry() {
    // Ensure the context for selectorKey is available.
    if (selectorKey.currentContext == null) {
      // Return an empty overlay or handle error, though this should ideally not happen
      // if the button is visible and this method is called.
      return OverlayEntry(builder: (context) => const SizedBox.shrink());
    }

    // Get the render box of the text field to determine its size and position.
    final renderBox =
        selectorKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double textFieldLeftX = offset.dx;
    final double textFieldTopY = offset.dy;
    final double textFieldHeight = size.height;
    final double textFieldWidth = size.width; // This is widget.buttonWidth
    final double textFieldBottomY = textFieldTopY + textFieldHeight;
    final double spaceBelow = screenHeight - textFieldBottomY;
    final double spaceAbove = textFieldTopY;

    // Max height the overlay content area can take.
    final double maxDropdownHeight = 250.0;
    // Estimate the actual height the content would occupy.
    final double estimatedContentHeight = _estimateDropdownContentHeight();
    // The height to consider for positioning: actual content height, but capped by maxDropdownHeight.
    final double heightToPositionWith = estimatedContentHeight.clamp(
      0.0,
      maxDropdownHeight,
    );

    final double gap = 3.0; // Gap between text field and dropdown
    double followerOffsetDy; // Vertical offset for CompositedTransformFollower

    bool canFitBelow = spaceBelow >= heightToPositionWith + gap;
    bool canFitAbove = spaceAbove >= heightToPositionWith + gap;

    if (canFitBelow) {
      // Enough space below for the content (up to maxDropdownHeight).
      followerOffsetDy = textFieldHeight + gap;
    } else if (canFitAbove) {
      // Enough space above for the content (up to maxDropdownHeight).
      // Position the overlay so its bottom is 'gap' units above the text field's top.
      followerOffsetDy = -(heightToPositionWith + gap);
    } else {
      // Content (even capped at maxDropdownHeight) doesn't fit neatly above or below.
      // Fallback: prioritize the side with more raw screen space.
      // The overlay will be clipped by screen edges if necessary.
      // Its internal height is still constrained by maxDropdownHeight via ConstrainedBox.
      if (spaceBelow >= spaceAbove && spaceBelow > gap) {
        followerOffsetDy = textFieldHeight + gap;
      } else if (spaceAbove > gap) {
        // Position above to fill available space. Overlay's top aligns with screen top.
        followerOffsetDy = -textFieldTopY;
      } else {
        // Very little space, default to below and let it clip.
        followerOffsetDy = textFieldHeight + gap;
      }
    }
    double followerOffsetDx =
        0.0; // Horizontal offset for CompositedTransformFollower
    // Adjust dx to keep dropdown on screen horizontally
    if (textFieldLeftX + textFieldWidth + followerOffsetDx > screenWidth) {
      // Off-screen to the right
      followerOffsetDx = screenWidth - (textFieldLeftX + textFieldWidth);
    }
    if (textFieldLeftX + followerOffsetDx < 0) {
      // Off-screen to the left
      followerOffsetDx = -textFieldLeftX;
    }

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Full screen GestureDetector to close the dropdown when tapping outside.
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  dropdownOverlayEntry?.remove();
                  dropdownOverlayEntry = null;
                  setState(() {});
                },
              ),
            ),
            // The dropdown list itself, positioned relative to the text field.
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: dropdownLayerLink,
                showWhenUnlinked: false,
                offset: Offset(followerOffsetDx, followerOffsetDy),
                child: StatefulBuilder(
                  builder: (context, setOverlayState) {
                    // TextFieldTapRegion ensures that tapping inside the dropdown doesn't unfocus the text field.
                    return TextFieldTapRegion(
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        child:
                            dropdownGroupedItems.isEmpty
                                ? const AppNoOptions()
                                // ConstrainedBox limits the maximum height of the dropdown.
                                : ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 250.0),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            dropdownGroupedItems.map((
                                              eachGroup,
                                              // Iterate through each group to display.
                                            ) {
                                              bool containsItems = true;
                                              if (eachGroup.subItems != null) {
                                                containsItems =
                                                    eachGroup
                                                        .subItems!
                                                        .isNotEmpty;
                                              } else {
                                                containsItems =
                                                    eachGroup.subItems != null;
                                              }
                                              if (containsItems) {
                                                // If the group has items, display as an ExpansionTile.
                                                return ExpansionTile(
                                                  trailing:
                                                      widget.eachGroupIsExpansion
                                                          ? null
                                                          : SizedBox(),
                                                  enabled:
                                                      widget
                                                          .eachGroupIsExpansion,
                                                  dense: true,
                                                  maintainState: true,
                                                  tilePadding: EdgeInsets.zero,
                                                  shape:
                                                      widget.showDividerBtwGroups
                                                          ? Border(
                                                            bottom: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          )
                                                          : InputBorder.none,
                                                  initiallyExpanded: true,
                                                  title: groupTitle(eachGroup),
                                                  children: groupItems(
                                                    eachGroup,
                                                  ),
                                                );
                                              }
                                              // If the group has no sub-items, display it as a single selectable item (title).
                                              return groupItem(
                                                eachItem: eachGroup,
                                                isTitle: true,
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Recursively filters a [DropdownButtonItem] and its sub-items based on a query.
  /// Returns a new [DropdownButtonItem] if the item or any of its sub-items match the query,
  /// otherwise returns `null`.
  DropdownButtonItem? _filterRecursive(DropdownButtonItem item, String query) {
    final queryLower = query.toLowerCase();

    // Check if the current item's title matches the query.
    final titleMatches = item.title.toLowerCase().contains(queryLower);

    // Recursively filter sub-items.
    final filteredSubItems =
        (item.subItems ?? [])
            .map((subItem) => _filterRecursive(subItem, query))
            .whereType<DropdownButtonItem>()
            .toList();
    // If the title matches or there are matching sub-items, return a new item.
    if (titleMatches || filteredSubItems.isNotEmpty) {
      return DropdownButtonItem(
        key: item.key,
        title: item.title,
        extraInfo: item.extraInfo,
        subItems: titleMatches ? item.subItems : filteredSubItems,
      );
    }

    return null;
  }

  /// Finds an exact match for the query within a [DropdownButtonItem] and its sub-items.
  /// Returns a [DropdownReturnItem] with its parent hierarchy if an exact match is found.
  DropdownReturnItem? _findExactMatch(
    DropdownButtonItem item,
    String query, [
    DropdownReturnItem? parent,
  ]) {
    // Check for an exact, case-insensitive match of the title.
    if (item.title.toLowerCase() == query.toLowerCase()) {
      return DropdownReturnItem(
        key: item.key,
        title: item.title,
        parent: parent,
      );
    }

    // Recursively search in sub-items.
    for (final sub in item.subItems ?? []) {
      final match = _findExactMatch(
        sub,
        query,
        DropdownReturnItem(key: item.key, title: item.title, parent: parent),
      );
      if (match != null) return match;
    }

    return null;
  }

  /// Filters the `dropdownGroupedItems` based on the query string.
  /// Also attempts to find an exact match to pre-select if the user types a full item name.
  void _filterData(String query) {
    // Clear previous selection when filtering starts.
    widget.onSelect(null);

    if (query.isEmpty) {
      // If query is empty, reset to the full list of items.
      setState(() {
        dropdownGroupedItems = List.from(widget.items);
      });
      return;
    }

    final List<DropdownButtonItem> filtered =
        // Filter the original items list recursively.
        widget.items
            .map((item) => _filterRecursive(item, query))
            .whereType<DropdownButtonItem>()
            .toList();

    // Attempt to find an exact match in the filtered results.
    DropdownReturnItem? selectedMatch;
    for (final item in filtered) {
      selectedMatch = _findExactMatch(item, query);
      if (selectedMatch != null) break;
    }

    // If an exact match is found, notify the parent widget.
    if (selectedMatch != null) {
      widget.onSelect(selectedMatch);
    }

    setState(() {
      // Update the displayed items with the filtered list.
      dropdownGroupedItems = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.buttonWidth,
      child: CompositedTransformTarget(
        key: selectorKey,
        link: dropdownLayerLink,
        child: LayoutBuilder(
          // LayoutBuilder is used here to potentially get constraints if needed, though not directly used in this snippet.
          builder: (context, constraints) {
            return DropdownTextField(
              borderRadius: widget.borderRadius,
              borderType: widget.borderType,
              borderColor: widget.borderColor,
              enabledBorderColor: widget.enabledBorderColor,
              focusedBorderColor: widget.focusedBorderColor,
              errorBorderColor: widget.errorBorderColor,
              focusedErrorBorderColor: widget.focusedErrorBorderColor,
              contentPadding: widget.contentPadding,
              controller: textFieldController,
              hintText: widget.hintText,
              labelText: widget.labelText,
              prefix: widget.prefix,
              suffix:
                  // Default suffix is an animated dropdown arrow.
                  widget.suffix ??
                  SizedBox(
                    width: 30.0,
                    child: AnimatedRotation(
                      turns: dropdownOverlayEntry == null ? 0.0 : 0.5,
                      duration: Duration(milliseconds: 300),
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ),
              validator:
                  // Validator for the required field.
                  widget.isRequired
                      ? (value) =>
                          value == null || value.isEmpty
                              ? widget.errorText ?? "This field is required"
                              : null
                      : null,
              onChanged: (value) {
                // Filter data as user types.
                _filterData(value);
                // Re-open or update the dropdown overlay with filtered items.
                dropdownOverlayEntry?.remove();
                dropdownOverlayEntry = optionsOverlayEntry();
                Overlay.of(context).insert(dropdownOverlayEntry!);
              },
              onTap: () {
                // When the text field is tapped, open the dropdown overlay.
                // Reset to full list of items before showing.
                dropdownOverlayEntry?.remove();
                dropdownOverlayEntry = optionsOverlayEntry();
                Overlay.of(context).insert(dropdownOverlayEntry!);
                setState(() {
                  dropdownGroupedItems = List.from(widget.items);
                });
              },
            );
          },
        ),
      ),
    );
  }
}
