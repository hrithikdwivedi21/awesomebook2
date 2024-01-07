// import 'package:flutter/material.dart';
// import 'package:funbook/screens/add_post.dart';
// import 'package:funbook/screens/image_post.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../widgets/avatars.dart';
// import '../widgets/cards.dart';
//
// class FeedScreen extends StatefulWidget {
//   const FeedScreen({Key? key}) : super(key: key);
//
//   @override
//   State<FeedScreen> createState() => _FeedScreenState();
// }
//
// class _FeedScreenState extends State<FeedScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading:IconButton(
//           icon: Icon(Icons.camera_alt_outlined,size: 34.0,),
//           onPressed: (){
//             // Navigator.push(context, MaterialPageRoute(builder: (context)=>AddImage()));
//             print('Adding..');
//           },
//         ),
//         title: Text(
//           "Awesome Book",
//           style: TextStyle(
//               fontFamily: GoogleFonts.dangrek().fontFamily,
//               fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.search,
//               size: 34.0,
//             ),
//             onPressed: () => debugPrint("search"),
//           ),
//
//         ],
//       ),
//       body: Container(
//         child: ListView(
//           children: [
//             Avatars(),
//             for (var i = 0; i < 9; i++) MyCard(),
//           ],
//         ),
//       ),
//     );
//   }
// }
