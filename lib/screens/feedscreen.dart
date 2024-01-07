import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funbook/models/user.dart';
import 'package:funbook/screens/chats.dart';
import 'package:funbook/screens/story_page_new.dart';
import 'package:funbook/screens/storyimage.dart';
import 'package:funbook/widgets/cards.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/post_card.dart';


class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updatelength();
    Mystorydata();
  }

  var length2 = 0;
  var allData2;
  var my_user_id=FirebaseAuth.instance.currentUser!.uid;
  var my_length2 = 0;
  var myData;

  void updatelength() {
    // FirebaseFirestore.instance.collection('story').where('posted_by_id' ,isEqualTo: '1').get().then((snapshot) {
    FirebaseFirestore.instance
        .collection('story')
        .orderBy('uid')
        .where('uid' ,isNotEqualTo
        : my_user_id)
        .get()
        .then((snapshot) {
      List<DocumentSnapshot> allDocs = snapshot.docs;
      length2 = allDocs.length;
      allData2 = snapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        // all_news2=all_news2;
        length2 = length2;
        allData2 = allData2;

        print("data is fetched");
        print(length2);
      });
    });
    setState(() {
      length2 = length2;
    });

    setState(() {});
  }



  void Mystorydata() {
    // FirebaseFirestore.instance.collection('story').where('posted_by_id' ,isEqualTo: '1').get().then((snapshot) {
    FirebaseFirestore.instance
        .collection('story')
        .where('uid' ,isEqualTo: my_user_id)
        .get()
        .then((snapshot) {
      List<DocumentSnapshot> allDocs = snapshot.docs;
      my_length2 = allDocs.length;
      myData = snapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        // all_news2=all_news2;
        my_length2 = my_length2;
        myData = myData;

        // print("data is fetched");
        // print(length2);
      });
    });

    setState(() {});
  }
  var prev=-1;

  List<String> ids=[];

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<void> getData() async {
    refreshKey.currentState?.show(atTop: false);
    updatelength();
    Mystorydata();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.camera_alt_outlined,
              size: 34.0,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>StoryImage()));
            },
          ),
          title: Text(
            "Awesome Book",
            style: TextStyle(
                fontFamily: GoogleFonts.dangrek().fontFamily,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Image.asset('assets/chat.png'),
              onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>Chats()));
              },
            ),
          ],
        ),

        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    child: Container(
                      height: 300,
                      // margin: EdgeInsets.all(20),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: length2+1,
                          itemBuilder: (context,
                              index) {

                            if(index==0){
                              return Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {

                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoryImage(my_user_id)));
                                        (my_length2>0)
                                            ?Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoryPageViewNew(my_user_id)))
                                            :Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoryImage()));


                                      },
                                      child: Stack(
                                        children: [
                                          (my_length2>0)
                                              ?Padding(
                                            padding: const EdgeInsets.all(1.2),
                                            child: CachedNetworkImage(
                                              imageUrl: "${myData.elementAt(0)['postUrl']}",
                                              imageBuilder: (context, imageProvider) => Container(
                                                width: 65.0,
                                                height: 65.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider, fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, url) => CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          )
                                              :CircleAvatar(
                                            radius: 30,
                                            // backgroundColor: Colors.black12,
                                            backgroundImage: NetworkImage(user!.photoUrl),
                                          ),
                                          (my_length2==0)?Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: CircleAvatar(
                                              radius: 12,
                                              child: Icon(Icons.add_circle_outline_outlined),
                                            ),
                                          ):SizedBox(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text("Your Story"),
                                  ],
                                ),
                              );
                            }
                            // final body = json.decode(items[index]);
                            final body = allData2.elementAt(index-1);
                            // var curr=body['posted_by_id'] ;

                            var id=body['uid'].toString();
                            if(ids.contains(id)){
                              return Padding(
                                padding: const EdgeInsets.all(0),
                              );
                            }
                            else{
                              ids.add(id.toString());
                              // setState(() {
                              //
                              // });
                            }

                            return Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => StoryPageViewNew(body['uid'].toString())));
                                },
                                child: Column(
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.all(4.0),
                                    //   child: CircleAvatar(
                                    //     radius: 30,
                                    //     backgroundColor: Colors.blue,
                                    //     backgroundImage: NetworkImage(body['image'].toString()),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.2),
                                      child: CachedNetworkImage(
                                        imageUrl: "${body['profImage']}",
                                        imageBuilder: (context, imageProvider) => Container(
                                          width: 65.0,
                                          height: 65.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider, fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text("${body['username'].toString()}"),
                                  ],
                                ),
                              ),
                            );
                            // return CircleAvatar(child: Image.network(body['image'].toString(), fit: BoxFit.fitHeight));
                          }
                      ),
                    ),

                  ),

                ),
                Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished', descending: true).snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      List<String> uids = snapshot.data!.docs.map((doc) => doc['uid'] as String).toList(); // Cast to List<String>

                      Future<List<Map<String, dynamic>>> getUsersData(List<String> uids) async {
                        List<Map<String, dynamic>> usersData = [];
                        for (String uid in uids) {
                          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
                          if (userSnapshot.exists) {
                            usersData.add(userSnapshot.data()! as Map<String, dynamic>); // Cast to Map<String, dynamic>
                          }
                        }
                        return usersData;
                      }

                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: getUsersData(uids),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          // Merge "posts" and "users" data
                          List<Map<String, dynamic>> mergedData = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            Map<String, dynamic> postData = snapshot.data!.docs[i].data();
                            Map<String, dynamic> userData = userSnapshot.data![i];
                            mergedData.add({...postData, ...userData});
                          }


                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: mergedData.length,
                            itemBuilder: (context, index) => PostCard(
                              snap: mergedData[index],
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
        ));
  }
}
