import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funbook/screens/post_view.dart';
import 'package:funbook/screens/profile_screen.dart';
import 'package:funbook/screens/video_player.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  String? selectedValue='All';
  List items = ['All','Entertainment', 'Gaming', 'Bollywood','Tollywood','Politics','Food'];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isShowUsers = false;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.search),
        title: Form(
          child: TextFormField(
            controller: searchController,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration:
            const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              border: InputBorder.none,
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
              TextStyle(
                  color: Colors.white
              );
            },
          ),
        ),
      ),
      body: isShowUsers
          ?  FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where(
            'username',
            isGreaterThanOrEqualTo: searchController.text,
            ).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else {
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid:   (snapshot.data! as dynamic).docs[index]['uid'])));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        (snapshot.data! as dynamic).docs[index]['photoUrl'],
                      ),
                      radius: 16,
                    ),
                    title: Text(
                      (snapshot.data! as dynamic).docs[index]['username'],
                    ),
                  ),
                );
              },
            );
          }
        },
      ): Container(
        margin: const EdgeInsets.only(top: 10,bottom: 30),
        child: Column(
          children: [

            Padding(
             padding: EdgeInsets.all(1),
              child: Wrap(
                children: [
                  for (int i = 0; i < items.length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          side: BorderSide(width: 1.0,color: Colors.white),
                          backgroundColor: selectedValue==items[i]?Colors.blue:Colors.white,
                        ),
                        child: Text(items[i],style: TextStyle(color: selectedValue==items[i]?Colors.white:Colors.black),),
                        onPressed: () {
                          setState(() {
                            selectedValue=items[i];
                          });
                        },
                      ),
                    ),
                ],
              )
            ),
            SizedBox(height: 10,),
            Expanded(
              child: FutureBuilder(
                future:
                selectedValue=='All'? FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy("datePublished",descending:true)
                    .get()
                    :FirebaseFirestore.instance
                    .collection("posts")
                    .where("category", isEqualTo: selectedValue)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                      (snapshot.data! as dynamic).docs[index];

                      return Container(
                        child: GestureDetector(
                          onTap: (){
                            (snap['postType']=='Image')?
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>PostView(snap: snap,)))
                                :
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>VideoPlayer(snap: snap,)));
                          },
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}