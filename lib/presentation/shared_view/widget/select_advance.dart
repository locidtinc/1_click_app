import 'dart:async';

import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/brand.dart';

typedef ItemWidgetBuilder<ItemType> = Widget Function(
  BuildContext context,
  ItemType item,
  int index,
);

class SelectAdvanced<ItemType> extends StatefulWidget {
  const SelectAdvanced({
    super.key,
    required this.label,
    this.hintSelect = '',
    this.eventSelect,
    required this.itemBuilder,
    required this.listItem,
    this.onAddNew,
    this.hintText,
    this.onSelect,
    this.onClearValue,
    this.value,
  });

  final String? label;
  final String hintSelect;
  final Function? eventSelect;
  final ItemWidgetBuilder<ItemType> itemBuilder;
  final List<ItemType> listItem;
  final Future<void> Function(String value)? onAddNew;
  final Function(ItemType)? onSelect;
  final Function()? onClearValue;
  final String? hintText;
  final String? value;

  @override
  State<SelectAdvanced<ItemType>> createState() => _SelectAdvancedState<ItemType>();
}

class _SelectAdvancedState<ItemType> extends State<SelectAdvanced<ItemType>> with TickerProviderStateMixin {
  StatusSelect _statusSelect = StatusSelect.UNFOCUS;

  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  late TextEditingController _editTextController;
  late OverlayEntry? _overlayEntry;

  late AnimationController _controllerDropdownAnimation;
  late Animation<double> _animationDropDown;

  SelectModel? selectItem;

  Timer? timer;

  var isLoadingAddMore = false;

  void _onTap() {
    // if (_statusSelect != StatusSelect.FOCUS_SEARCH) {
    //   _statusSelect = StatusSelect.FOCUS_SEARCH;
    //   FocusScope.of(context).requestFocus(_focusNode);
    // }
    // _statusSelect = StatusSelect.FOCUS_SEARCH;
    // FocusScope.of(context).requestFocus(_focusNode);
    if (_statusSelect != StatusSelect.FOCUS_SEARCH) {
      _statusSelect = StatusSelect.FOCUS_SEARCH;
      FocusScope.of(context).requestFocus(_focusNode);
      setState(() {});
    }
  }

  // void _handleSearch(String search) {
  //   if (timer != null) timer!.cancel();
  //   timer = Timer(const Duration(milliseconds: 500), () {});

  //   timer!;
  // }

  @override
  void initState() {
    super.initState();

    _controllerDropdownAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animationDropDown = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(_controllerDropdownAnimation);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
        _controllerDropdownAnimation.forward();
      } else {
        _controllerDropdownAnimation.reverse();
        Timer(const Duration(milliseconds: 300), () {
          _overlayEntry?.remove();
        });
        _statusSelect = StatusSelect.UNFOCUS;
        // _editTextController.text = '';
        // key = '';
      }
      setState(() {});
    });

    _editTextController = TextEditingController(text: widget.value)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _editTextController.dispose();
    // _controllerLoadingAnimation.dispose();
    _controllerDropdownAnimation.dispose();

    super.dispose();
  }

  var key = '';

  @override
  Widget build(BuildContext context) {
    if (widget.value?.isNotEmpty ?? false) {
      _editTextController.text = widget.value ?? '';
    }
    return CompositedTransformTarget(
      link: _layerLink,
      child: AppInput(
        fn: _focusNode,
        controller: _editTextController,
        label: widget.label,
        hintText: widget.hintText ?? 'Nhóm sản phẩm',
        validate: (value) {},
        onTap: () => _onTap(),
        onChanged: (value) {
          setState(() {
            key = value;
          });
          _setStateOverlay();
        },
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: _editTextController.text.isNotEmpty,
              child: GestureDetector(
                onTap: () {
                  widget.onClearValue?.call();
                  setState(() {
                    _editTextController.text = '';
                    _setStateOverlay();
                  });
                },
                child: const CircleAvatar(
                  backgroundColor: greyColor,
                  radius: sp8,
                  child: Icon(
                    Icons.close_rounded,
                    size: sp12,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: sp16),
            AnimatedRotation(
              turns: _focusNode.hasFocus ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.arrow_drop_down_rounded,
                size: sp20,
                color: blackColor,
              ),
            ),
            const SizedBox(width: sp16),
          ],
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + sp4),
          child: Material(
            borderRadius: BorderRadius.circular(sp8),
            elevation: 4.0,
            child: AnimatedBuilder(
              animation: _controllerDropdownAnimation,
              builder: (context, child) => SizedBox(
                height: _animationDropDown.value,
                width: widthDevice(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: _animationDropDown.value == 300,
                      child: SizedBox(
                        height: _animationDropDown.value - 50,
                        width: widthDevice(context) - 64,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = widget.listItem
                                .where(
                                  (e) => (e is BrandEntity
                                      ? e.title.toLowerCase().contains(
                                            _editTextController.text.toLowerCase(),
                                          )
                                      : true),
                                )
                                .toList()[index];
                            return InkWell(
                              onTap: () => setState(() {
                                widget.onSelect?.call(item);
                                if (item is BrandEntity) {
                                  _editTextController.text = item.title;
                                  _overlayEntry?.remove();
                                  _statusSelect = StatusSelect.UNFOCUS;
                                  _focusNode.unfocus();
                                }
                              }),
                              child: (widget.itemBuilder)(
                                context,
                                item,
                                index,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: sp16),
                          itemCount: widget.listItem
                              .where(
                                (e) => (e is BrandEntity
                                    ? e.title.toLowerCase().contains(
                                          _editTextController.text.toLowerCase(),
                                        )
                                    : true),
                              )
                              .toList()
                              .length,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _animationDropDown.value == 300 && key.isNotEmpty,
                      child: GestureDetector(
                        onTap: () => handleAddNew(),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(sp8),
                            ),
                          ),
                          padding: const EdgeInsets.all(sp16),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_circle_rounded,
                                size: sp16,
                                color: whiteColor,
                              ),
                              const SizedBox(width: sp12),
                              Text(
                                'Thêm mới "$key"',
                                style: p5.copyWith(color: whiteColor),
                              ),
                              const SizedBox(width: sp16),
                              Visibility(
                                visible: isLoadingAddMore,
                                child: const BaseLoading(
                                  color: whiteColor,
                                  size: sp12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleAddNew() async {
    setState(() {
      isLoadingAddMore = true;
      _setStateOverlay();
    });
    await widget.onAddNew?.call(key);
    setState(() {
      isLoadingAddMore = false;
      _overlayEntry?.remove();
      _statusSelect = StatusSelect.UNFOCUS;
      _focusNode.unfocus();
    });
  }

  void _setStateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _controllerDropdownAnimation.forward();
    }
  }
}
