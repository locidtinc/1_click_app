import 'dart:async';

import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../domain/entity/customer.dart';

typedef ItemWidgetBuilder = Widget Function(
  BuildContext context,
  CustomerEntity item,
  int index,
);

class SelectCustomer extends StatefulWidget {
  const SelectCustomer({
    super.key,
    required this.label,
    this.hintSelect = '',
    this.eventSelect,
    required this.itemBuilder,
    required this.listItem,
    // this.onAddNew,
    this.hintText,
    this.onSelect,
    this.selectedCustomer,
    this.isLoadingInit = true,
    this.controller,
  });

  final String? label;
  final String hintSelect;
  final Function? eventSelect;
  final ItemWidgetBuilder itemBuilder;
  final List<CustomerEntity> listItem;
  // final Future<void> Function(String value)? onAddNew;
  final Function(CustomerEntity)? onSelect;
  final String? hintText;
  final CustomerEntity? selectedCustomer;
  final bool isLoadingInit;
  final TextEditingController? controller; // 👈 thêm dòng này

  @override
  State<SelectCustomer> createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> with TickerProviderStateMixin {
  StatusSelect _statusSelect = StatusSelect.UNFOCUS;

  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  late TextEditingController _editTextController;
  late OverlayEntry? _overlayEntry;

  late AnimationController _controllerDropdownAnimation;
  late Animation<double> _animationDropDown;

  SelectModel? selectItem;

  Timer? timer;
  bool isSyncingSelectedCustomer = false;

  var isLoadingAddMore = false;

  void _onTap() {
    if (_statusSelect != StatusSelect.FOCUS_SEARCH) {
      _statusSelect = StatusSelect.FOCUS_SEARCH;
      FocusScope.of(context).requestFocus(_focusNode);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _controllerDropdownAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
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
        Timer(const Duration(milliseconds: 150), () {
          if (mounted && _overlayEntry?.mounted == true) {
            _overlayEntry?.remove();
          }
          _overlayEntry = null;
        });

        _statusSelect = StatusSelect.UNFOCUS;
      }
      setState(() {});
    });

    _editTextController = widget.controller ??
        TextEditingController(
          text: widget.selectedCustomer?.fullName ?? '',
        )
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant SelectCustomer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedCustomer?.id != oldWidget.selectedCustomer?.id) {
      final newName = widget.selectedCustomer?.fullName ?? '';

      isSyncingSelectedCustomer = true;

      _editTextController
        ..text = newName
        ..selection = TextSelection.collapsed(offset: newName.length);

      // Tắt loading sau 1 frame (đợi đồng bộ UI)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            isSyncingSelectedCustomer = false;
          });
        }
      });
    }
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
    return Stack(
      children: [
        CompositedTransformTarget(
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
                if (widget.isLoadingInit)
                  const SizedBox(
                    width: sp16,
                    height: sp16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                else if (_editTextController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _editTextController.clear();
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
        ),
      ],
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
                child: Visibility(
                  visible: _animationDropDown.value == 300,
                  child: SizedBox(
                    height: _animationDropDown.value,
                    width: widthDevice(context) - 64,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = widget.listItem
                            .where(
                              (e) => ((e.fullName?.contains(
                                        _editTextController.text,
                                      ) ??
                                      true) ||
                                  (e.phone?.contains(
                                        _editTextController.text,
                                      ) ??
                                      true)),
                            )
                            .toList()[index];
                        return InkWell(
                          onTap: () => setState(() {
                            widget.onSelect?.call(item);
                            _editTextController.text = item.fullName ?? '';
                            _overlayEntry?.remove();
                            _statusSelect = StatusSelect.UNFOCUS;
                            _focusNode.unfocus();
                          }),
                          child: (widget.itemBuilder)(
                            context,
                            item,
                            index,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 0),
                      itemCount: widget.listItem
                          .where(
                            (e) => ((e.fullName?.contains(
                                      _editTextController.text,
                                    ) ??
                                    true) ||
                                (e.phone?.contains(
                                      _editTextController.text,
                                    ) ??
                                    true)),
                          )
                          .toList()
                          .length,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> handleAddNew() async {
  //   setState(() {
  //     isLoadingAddMore = true;
  //     _setStateOverlay();
  //   });
  //   await widget.onAddNew?.call(key);
  //   setState(() {
  //     isLoadingAddMore = false;
  //     _overlayEntry?.remove();
  //     _statusSelect = StatusSelect.UNFOCUS;
  //     _focusNode.unfocus();
  //   });
  // }

  void _setStateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _controllerDropdownAnimation.forward();
    }
  }
}
