import 'package:flutter/material.dart';
import '../models/products.dart';

class ProdWidget extends StatelessWidget{
  final Item item;
  const ProdWidget({Key? key, required this.item}) : assert(item!=null), super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: ()=>debugPrint(item.name),
          leading: Image.network(item.image),
          title: Text(item.name),
          subtitle: Text(item.desc),
          trailing: Text(item.price),
        ),
      ),
    );
  }
  
}