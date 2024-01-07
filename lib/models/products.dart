class AllProd{
  static List<Item> items = [];
}


class Item{
  final int id;
  final String name;
  final String price;
  final String image;
  final String desc;

  Item({required this.id, required this.name, required this.price, required this.image, required this.desc});
  factory Item.fromMap(Map<String, dynamic> map){
    return Item(
        id:map["id"],
        name:map["name"],
        price:map["price"],
        desc:map["desc"],
        image:map["image"],
    );
  }

  toMap()=>{
    "id":id,
    "name":name,
    "desc":desc,
    "price":price,
    "image":image
  };

}
