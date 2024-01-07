import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funbook/models/products.dart';
import 'package:funbook/widgets/bottom_widget.dart';
import 'package:funbook/widgets/drawer_widget.dart';
import 'package:funbook/widgets/story.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/product_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async{
    await Future.delayed(Duration(seconds: 1));
   final ProductsJson = await rootBundle.loadString("assets/files/products.json");
   final decodePro = jsonDecode(ProductsJson);
   var allProducts=decodePro["Products"];
   AllProd.items = List.from(allProducts)
       .map<Item>((item) => Item.fromMap(item))
       .toList();
   setState(() {});
  }
  // final dummyList = List.generate(3, (index) => AllProd.items[0]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.camera_alt_outlined,
          size: 34.0,
        ),
        title: Text(
          "Funbook",
          style: TextStyle(
              fontFamily: GoogleFonts.dangrek().fontFamily,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 34.0,
            ),
            onPressed: () => debugPrint("search"),
          ),
          IconButton(
            icon: Icon(
              Icons.message_rounded,
              size: 34.0,
            ),
            onPressed: () => debugPrint("Chats"),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: (AllProd.items!=null && AllProd.items.isNotEmpty)?ListView.builder(
          itemCount: AllProd.items.length,
          itemBuilder: (context,index){
            return ProdWidget(
              item: AllProd.items[index],
            );
          },
        ):Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomNavigationBar: BottomWidget(),
    );
  }
}
