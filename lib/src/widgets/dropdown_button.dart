import 'package:flutter/material.dart';
import 'package:group_dropdown_button/group_dropdown_button.dart';
import 'package:group_dropdown_button/src/utils/extensions.dart';
import 'package:group_dropdown_button/src/widgets/text_field.dart';
import 'package:group_dropdown_button/src/widgets/no_options.dart';

class GroupDropdownButton extends StatefulWidget {
  final List<GroupedDropdownOption> items;
  final ValueChanged<GroupedDropdownOption?> onSelect;

  final double buttonWidth;
  final Widget? itemPrefix;

  final bool isRequired;
  final String? errorText;
  final GroupedDropdownOption? initialValue;
  final String? hintText;
  final String? labelText;
  final Widget? prefix;
  final Widget? suffix;

  final bool enabledRadioForItems;
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
         items.isNotEmpty || items.length >= 2,
         "items can't be empty, atleast 2 or more items are required",
       ),
       assert(
         !enabledRadioForItems || !showCheckForSelected,
         "enabledRadioForItems = true & showCheckForSelected = true -> Both, radio button and selected widget can't be used",
       );

  @override
  State<GroupDropdownButton> createState() => _GroupDropdownButtonState();
}

class _GroupDropdownButtonState extends State<GroupDropdownButton> {
  OverlayEntry? dropdownOverlayEntry;
  final dropdownLayerLink = LayerLink();
  final textFieldController = TextEditingController();
  final selectorKey = GlobalKey();

  late List<GroupedDropdownOption> dropdownOptions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue != null) {
        textFieldController.text = widget.initialValue!.title;
      }
    });
    dropdownOptions = List.from(widget.items);
  }

  Widget groupTitle(GroupedDropdownOption eachGroup) => Text(
    eachGroup.title,
    style: context.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  );

  List<Widget> groupItems(GroupedDropdownOption eachGroup) => [
    if ((eachGroup.subItems ?? []).isEmpty) ...[
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        child: Text("---No Results Found---"),
      ),
    ] else ...[
      ...(eachGroup.subItems ?? []).map((eachSubOption) {
        final status =
            eachSubOption.title.toString() == textFieldController.text;
        return Container(
          width: double.infinity,
          color: status ? Colors.grey.withAlpha(50) : Colors.transparent,
          child: InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 7.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.enabledRadioForItems) ...[
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        shape: BoxShape.circle,
                      ),
                      child:
                          status
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
                    SizedBox(width: 5.0),
                  ],
                  if (widget.itemPrefix != null) ...[
                    widget.itemPrefix!,
                    SizedBox(width: 5.0),
                  ],
                  Expanded(
                    child: Text(
                      eachSubOption.title.toString(),
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                  if (status && widget.showCheckForSelected) ...[
                    widget.checkWidgetForSelectedItem ??
                        Icon(Icons.check_circle, color: Colors.green),
                  ],
                ],
              ),
            ),
            onTap: () {
              widget.onSelect(
                GroupedDropdownOption(
                  extraInfo: eachSubOption.extraInfo,
                  key: eachSubOption.key,
                  title: eachSubOption.title,
                  parentKey: eachGroup.key,
                  parentTitle: eachGroup.title,
                ),
              );
              textFieldController.text = eachSubOption.title;
              dropdownOverlayEntry?.remove();
              dropdownOverlayEntry = null;
            },
          ),
        );
      }),
    ],
  ];

  OverlayEntry optionsOverlayEntry() {
    final RenderBox renderBox =
        // ignore: cast_nullable_to_non_nullable
        selectorKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    int length = 0;
    length += dropdownOptions.length;
    for (final eachOption in dropdownOptions) {
      length +=
          eachOption.subItems == null || eachOption.subItems!.isEmpty
              ? 1
              : eachOption.subItems!.length;
    }
    final positionHeight =
        context.height - offset.dy > 250
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
                  builder: (context, snapState) {
                    return TextFieldTapRegion(
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        child:
                            dropdownOptions.isEmpty
                                ? const AppNoOptions()
                                : ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 250.0),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...dropdownOptions.map((eachGroup) {
                                            return ExpansionTile(
                                              trailing:
                                                  widget.eachGroupIsExpansion
                                                      ? null
                                                      : SizedBox(),
                                              enabled:
                                                  widget.eachGroupIsExpansion,
                                              dense: true,
                                              shape: InputBorder.none,
                                              maintainState: true,
                                              childrenPadding: EdgeInsets.zero,
                                              tilePadding: EdgeInsets.zero,
                                              initiallyExpanded: true,
                                              title: groupTitle(eachGroup),
                                              children: groupItems(eachGroup),
                                            );
                                          }),
                                        ],
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

  void _filterData(String query) {
    widget.onSelect(null);
    if (query.isEmpty) {
      setState(() {
        dropdownOptions = List.from(widget.items);
      });
      return;
    }

    List<GroupedDropdownOption> tempFilteredData = [];
    final List<GroupedDropdownOption> allData = List.from(widget.items);
    for (var type in allData) {
      bool typeMatches = type.title.toLowerCase().contains(query.toLowerCase());
      List<GroupedDropdownOption> matchingProperties = [];
      if (!typeMatches) {
        if (type.subItems != null) {
          matchingProperties =
              type.subItems!.where((property) {
                return property.title.toLowerCase().contains(
                  query.toLowerCase(),
                );
              }).toList();
        }
      }
      if (typeMatches || matchingProperties.isNotEmpty) {
        tempFilteredData.add(
          GroupedDropdownOption(
            key: type.key,
            title: type.title,
            extraInfo: type.extraInfo,
            subItems: typeMatches ? type.subItems : matchingProperties,
          ),
        );
      }
    }
    if (tempFilteredData.length == 1) {
      if (tempFilteredData.first.subItems != null) {
        if (tempFilteredData.first.subItems!.length == 1) {
          final singleItem = tempFilteredData.first;
          if (query.toLowerCase() ==
              singleItem.subItems!.first.title.toLowerCase()) {
            widget.onSelect(
              GroupedDropdownOption(
                extraInfo: singleItem.subItems!.first.extraInfo,
                key: singleItem.subItems!.first.key,
                title: singleItem.subItems!.first.title,
                parentKey: singleItem.key,
                parentTitle: singleItem.title,
              ),
            );
          }
        }
      }
    }
    setState(() {
      dropdownOptions = List.from(tempFilteredData);
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
              onChanged: (value) {
                _filterData(value);
                dropdownOverlayEntry?.remove();
                dropdownOverlayEntry = null;
                dropdownOverlayEntry = optionsOverlayEntry();
                Overlay.of(context).insert(dropdownOverlayEntry!);
                setState(() {});
              },
              controller: textFieldController,
              onTap: () {
                dropdownOverlayEntry?.remove();
                dropdownOverlayEntry = null;
                dropdownOverlayEntry = optionsOverlayEntry();
                Overlay.of(context).insert(dropdownOverlayEntry!);
                setState(() {});
              },
              hintText: widget.hintText,
              suffix:
                  widget.suffix ??
                  SizedBox(
                    width: 30.0,
                    child: AnimatedRotation(
                      turns: dropdownOverlayEntry == null ? 0.0 : 0.5,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ),
              prefix: widget.prefix,
              validator:
                  widget.isRequired
                      ? (value) {
                        if (value == null || value.isEmpty) {
                          return widget.errorText ?? "This field is required";
                        }
                        return null;
                      }
                      : null,
              labelText: widget.labelText,
            );
          },
        ),
      ),
    );
  }
}
