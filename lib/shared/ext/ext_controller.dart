part of 'index.dart';

extension ExtScroll on ScrollController {
  onMore(Function() call) {
    addListener(
      () {
        if (position.pixels == position.maxScrollExtent) {
          call();
        }
      },
    );
  }
}
