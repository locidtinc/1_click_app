// import 'dart:convert';

// import 'package:auto_route/auto_route.dart';
// import 'package:base_mykiot/base_lhe.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:one_click/presentation/base/app_bar.dart';
// import 'package:rich_editor/rich_editor.dart';

// @RoutePage()
// class RichTextEditorPage extends StatelessWidget {
//   RichTextEditorPage({super.key});

//   // final _controller = quill.QuillController.basic();
//   GlobalKey<RichEditorState> keyEditor = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const BaseAppBar(title: 'Chỉnh sửa thông tin'),
//       body: SingleChildScrollView(
//         physics: NeverScrollableScrollPhysics(),
//         child: Column(
//           children: [
//             // quill.QuillToolbar.basic(controller: _controller),
//             // Expanded(
//             //   child: Container(
//             //     padding: const EdgeInsets.all(sp16),
//             //     child: quill.QuillEditor.basic(
//             //       controller: _controller,
//             //       readOnly: false,
//             //     ),
//             //   ),
//             // )
//             SizedBox(
//               width: widthDevice(context),
//               height: heightDevice(context) - 80,
//               child: RichEditor(
//                 key: keyEditor,
//                 value: '',
//                 editorOptions: RichEditorOptions(
//                   placeholder: 'Bắt đầu chỉnh sửa thông tin',
//                   backgroundColor: bg_4, // Editor's bg color
//                   // baseTextColor: Colors.white,
//                   // editor padding
//                   padding: const EdgeInsets.all(sp16),
//                   // font name
//                   baseFontFamily: 'sans-serif',
//                   // Position of the editing bar (BarPosition.TOP or BarPosition.BOTTOM)
//                   barPosition: BarPosition.TOP,
//                 ),
//                 // You can return a Link (maybe you need to upload the image to your
//                 // storage before displaying in the editor or you can also use base64
//                 getImageUrl: (image) {
//                   String link =
//                       'https://avatars.githubusercontent.com/u/24323581?v=4';
//                   String base64 = base64Encode(image.readAsBytesSync());
//                   String base64String = 'data:image/png;base64, $base64';
//                   return base64String;
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(sp16),
//         child: Row(
//           children: [
//             Expanded(
//               child: Extrabutton(
//                 title: 'Huỷ',
//                 event: () => context.router.pop(),
//                 largeButton: true,
//                 borderColor: borderColor_2,
//                 icon: null,
//               ),
//             ),
//             const SizedBox(width: sp16),
//             Expanded(
//               child: MainButton(
//                 title: 'Xác nhận',
//                 event: () => context.router.pop(),
//                 largeButton: true,
//                 icon: null,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
