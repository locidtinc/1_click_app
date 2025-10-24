import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';

enum TabCode { home, storeOnline, another }

class BuildBottomBar extends StatelessWidget {
  const BuildBottomBar({
    Key? key,
    required this.pageCode,
  }) : super(key: key);

  final TabCode pageCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      width: widthDevice(context),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 40), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomPaint(
              size: Size(widthDevice(context), 80),
              painter: BNBCustomPainter(context: context),
            ),
          ),
          Center(
            heightFactor: 1,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp32),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFF6D66),
                    Color(0xFFD64740),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: FloatingActionButton(
                elevation: 0,
                // onPressed: () => context.router.push(OrderCreateRoute(
                //     typeOrder: TypeOrder.cHTH, fromBottomBar: true)),
                onPressed: () {
                  context.router.push(const QrBottomRoute());
                },
                backgroundColor: mainColor.withOpacity(0),
                child: SvgPicture.asset(
                  '${AssetsPath.icon}/bottom_bar/ic_scan.svg',
                  width: sp32,
                ),
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 24),
            width: widthDevice(context),
            height: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    context.router.popUntilRoot();
                  },
                  icon: SvgPicture.asset(
                    '${AssetsPath.icon}/bottom_bar/${pageCode == TabCode.home ? "ic_home_active" : "ic_home"}.svg',
                    width: 21,
                  ),
                ),
                const SizedBox(),
                IconButton(
                  onPressed: () {
                    context.router.push(const MykiotStoreRoute());
                  },
                  icon: SvgPicture.asset(
                    '${AssetsPath.icon}/bottom_bar/${pageCode == TabCode.storeOnline ? "ic_online_shop_active" : "ic_online_shop"}.svg',
                    width: 21,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  final dynamic context;

  BNBCustomPainter({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = whiteColor
      ..style = PaintingStyle.fill;
    final Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(0, 0, 16, 0);
    path.lineTo(size.width * 0.357, 0);
    path.quadraticBezierTo(size.width * 0.385, 0, size.width * 0.405, 13.5);
    // path.arcToPoint(Offset(size.width*0.6, 20), radius: Radius.circular(8), clockwise: false);
    path.quadraticBezierTo(size.width * 0.445, 36, size.width * 0.5, 36);
    path.quadraticBezierTo(size.width * 0.555, 36, size.width * 0.595, 13.5);
    path.quadraticBezierTo(size.width * 0.615, 0, size.width * 0.643, 0);
    path.lineTo(size.width - 16, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    path.lineTo(size.width, 80);
    path.lineTo(0, 80);
    path.close();

    canvas.drawPath(path, paint);
    // canvas.drawShadow(path, Colors.black45, 1, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
