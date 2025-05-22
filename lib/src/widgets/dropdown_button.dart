import 'package:flutter/material.dart';
import 'package:group_dropdown_button/group_dropdown_button.dart';
import 'package:group_dropdown_button/src/entity/dropdown_return_item.dart';
import 'package:group_dropdown_button/src/utils/extensions.dart';
import 'package:group_dropdown_button/src/widgets/text_field.dart';
import 'package:group_dropdown_button/src/widgets/no_options.dart';

class GroupDropdownButton extends StatefulWidget {
  final List<DropdownButtonItem> items;

  final ValueChanged<DropdownReturnItem?> onSelect;

  final double buttonWidth;

  final Widget? itemPrefix;

  final bool isRequired;

  final String? errorText;

  final DropdownButtonItem? initialValue;

  final String? hintText;

  final String? labelText;

  final Widget? prefix;

  final Widget? suffix;

  final bool enabledRadioForItems;

  final bool showDividerBtwGroups;

  final bool eachGroupIsExpansion;

  final bool showCheckForSelected;

  final Widget? checkWidgetForSelectedItem;

  final EdgeInsets? contentPadding;

  final double borderRadius;

  final TextFieldInputBorder borderType;

  final Color? borderColor;

  final Color? enabledBorderColor;

  final Color? focusedBorderColor;

  final Color? errorBorderColor;

  final Color? focusedErrorBorderColor;

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
       );

  @override
  State<GroupDropdownButton> createState() => _GroupDropdownButtonState();
}

class _GroupDropdownButtonState extends State<GroupDropdownButton> {
  OverlayEntry? dropdownOverlayEntry;
  final dropdownLayerLink = LayerLink();
  final textFieldController = TextEditingController();
  final selectorKey = GlobalKey();

  late List<DropdownButtonItem> dropdownGroupedItems;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue != null) {
        textFieldController.text = widget.initialValue!.title;
      }
    });

    dropdownGroupedItems = List.from(widget.items);
  }

  DropdownReturnItem _buildReturnItemWithParents(
    DropdownButtonItem currentItem,
    List<DropdownButtonItem> roots, {
    DropdownReturnItem? parentChain,
  }) {
    for (final root in roots) {
      if (root.key == currentItem.key) {
        return DropdownReturnItem(
          key: root.key,
          title: root.title,
          parent: parentChain,
        );
      }

      DropdownReturnItem? traverse(
        DropdownButtonItem item,
        DropdownReturnItem? currentParent,
      ) {
        if (item.key == currentItem.key) {
          return DropdownReturnItem(
            key: item.key,
            title: item.title,
            parent: currentParent,
          );
        }

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

      final match = traverse(root, null);
      if (match != null) return match;
    }

    return DropdownReturnItem(
      key: currentItem.key,
      title: currentItem.title,
      parent: parentChain,
    );
  }

  Widget groupTitle(DropdownButtonItem eachGroup) => Text(
    eachGroup.title,
    style: context.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  );

  List<Widget> groupItems(DropdownButtonItem eachGroup) => [
    if ((eachGroup.subItems ?? []).isEmpty)
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        child: Text("---No Results Found---"),
      )
    else
      ...(eachGroup.subItems ?? []).map((eachItem) {
        bool containsLevel2 = false;
        if (eachItem.subItems != null) {
          containsLevel2 = eachItem.subItems!.isNotEmpty;
        }
        return containsLevel2
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
            : groupItem(eachItem: eachItem);
      }),
  ];

  Widget groupItem({
    required DropdownButtonItem eachItem,
    bool isTitle = false,
  }) {
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
              if (widget.itemPrefix != null) ...[
                widget.itemPrefix!,
                SizedBox(width: 5.0),
              ],
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
              if (isSelected && widget.showCheckForSelected) ...[
                widget.checkWidgetForSelectedItem ??
                    Icon(Icons.check_circle, color: Colors.green),
              ],
            ],
          ),
        ),
        onTap: () {
          final returnItem = _buildReturnItemWithParents(
            eachItem,
            widget.items,
          );

          widget.onSelect(returnItem);
          textFieldController.text = eachItem.title;
          dropdownOverlayEntry?.remove();
          dropdownOverlayEntry = null;
        },
      ),
    );
  }

  OverlayEntry optionsOverlayEntry() {
    final renderBox =
        selectorKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    int length = dropdownGroupedItems.fold(
      0,
      (total, group) => total + 1 + (group.subItems?.length ?? 0),
    );

    final heightFromTop = context.height - offset.dy;
    final positionHeight =
        heightFromTop > 250
            ? size.height + 3.0
            : length * 25.0 < 240.0
            ? -(length * 25.0 + size.height)
            : -255.0;

    final positionWidth =
        context.width - offset.dx < 250.0
            ? -(250 - (context.width - offset.dx))
            : 0.0;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  dropdownOverlayEntry?.remove();
                  dropdownOverlayEntry = null;
                  setState(() {});
                },
              ),
            ),

            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: dropdownLayerLink,
                showWhenUnlinked: false,
                offset: Offset(positionWidth, positionHeight),
                child: StatefulBuilder(
                  builder: (context, setOverlayState) {
                    return TextFieldTapRegion(
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        child:
                            dropdownGroupedItems.isEmpty
                                ? const AppNoOptions()
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
                                              debugPrint(
                                                containsItems.toString(),
                                              );
                                              if (containsItems) {
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

  DropdownButtonItem? _filterRecursive(DropdownButtonItem item, String query) {
    final queryLower = query.toLowerCase();

    final titleMatches = item.title.toLowerCase().contains(queryLower);

    final filteredSubItems =
        (item.subItems ?? [])
            .map((subItem) => _filterRecursive(subItem, query))
            .whereType<DropdownButtonItem>()
            .toList();

    if (titleMatches || filteredSubItems.isNotEmpty) {
      return DropdownButtonItem(
        key: item.key,
        title: item.title,
        extraInfo: item.extraInfo,
        parentKey: item.parentKey,
        parentTitle: item.parentTitle,
        subItems: titleMatches ? item.subItems : filteredSubItems,
      );
    }

    return null;
  }

  DropdownReturnItem? _findExactMatch(
    DropdownButtonItem item,
    String query, [
    DropdownReturnItem? parent,
  ]) {
    if (item.title.toLowerCase() == query.toLowerCase()) {
      return DropdownReturnItem(
        key: item.key,
        title: item.title,
        parent: parent,
      );
    }

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

  void _filterData(String query) {
    widget.onSelect(null);

    if (query.isEmpty) {
      setState(() {
        dropdownGroupedItems = List.from(widget.items);
      });
      return;
    }

    final List<DropdownButtonItem> filtered =
        widget.items
            .map((item) => _filterRecursive(item, query))
            .whereType<DropdownButtonItem>()
            .toList();

    DropdownReturnItem? selectedMatch;
    for (final item in filtered) {
      selectedMatch = _findExactMatch(item, query);
      if (selectedMatch != null) break;
    }

    if (selectedMatch != null) {
      widget.onSelect(selectedMatch);
    }

    setState(() {
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
                  widget.isRequired
                      ? (value) =>
                          value == null || value.isEmpty
                              ? widget.errorText ?? "This field is required"
                              : null
                      : null,
              onChanged: (value) {
                _filterData(value);
                dropdownOverlayEntry?.remove();
                dropdownOverlayEntry = optionsOverlayEntry();
                Overlay.of(context).insert(dropdownOverlayEntry!);
              },
              onTap: () {
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
