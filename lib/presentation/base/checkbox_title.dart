import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/config/bloc/bool_bloc.dart';
import 'package:one_click/presentation/shared_view/widget/fa_icon.dart';
import 'package:one_click/shared/constants/fa_code.dart';
import 'package:one_click/shared/ext/index.dart';

class CheckBoxTitle extends StatefulWidget {
  final bool value;
  final String title;
  final Function(bool value) onChange;
  final EdgeInsets padding;
  const CheckBoxTitle({
    super.key,
    this.value = false,
    required this.title,
    required this.onChange,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<CheckBoxTitle> createState() => _CheckBoxTitleState();
}

class _CheckBoxTitleState extends State<CheckBoxTitle> {
  final bloc = BoolBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.toggle(value: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoolBloc, bool>(
      bloc: bloc,
      listener: (context, state) => widget.onChange(state),
      builder: (context, state) {
        return InkWell(
          onTap: () {
            bloc.toggle();
          },
          child: Padding(
            padding: widget.padding,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: 4.radius,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: state
                        ? FaIcon(
                            code: FaCode.check,
                            color: AppColors.red60,
                          )
                        : null,
                  ),
                ),
                12.width,
                Text(
                  widget.title,
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.grey79,
                  ),
                ).expanded(),
              ],
            ),
          ),
        );
      },
    );
  }
}
