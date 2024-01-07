import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
class StoryPageViewNew extends StatefulWidget {
  final uid=1;

  String posted_by_id;
  StoryPageViewNew(this.posted_by_id);
  // const StoryPageView(int i, {Key? key, this.uid}) : super(key: key);

  @override
  State<StoryPageViewNew> createState() => _StoryPageViewNewState(posted_by_id);
}


class _StoryPageViewNewState extends State<StoryPageViewNew> {
  var storyData = {};
  String posted_by_id;
  _StoryPageViewNewState(this.posted_by_id);

  @override
  void initState() {
    super.initState();
    getData();
  }
  var length2 = 0;
  var allData2;

  var controller = StoryController();




  getData() async {
    print("posted by id ${posted_by_id}");
    // storyData = userSnap.data()!;

    FirebaseFirestore.instance
        .collection('story')
        .where('uid' ,isEqualTo: posted_by_id.toString())
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



    setState(() {
      // print("story items lenght is ${storyItems.length}");
    });
  }

  @override
  Widget build(BuildContext context) {

    return Material(
        child: (length2>0)?StoryView(
            storyItems: [
              for(var i=0;i<length2;i++)
                StoryItem.pageImage(url: "${allData2.elementAt(i)['postUrl']}",
                  controller: controller,caption: "",)

            ],
            controller: controller,
            inline: false,
            repeat: false,
            onComplete: () {
              Navigator.pop(context);
            },
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context);
              }
            })
            :Container(color:Colors.black,child: Expanded(child: Center(child: Text("Loading",style: TextStyle(color: Colors.white),),),)
        )
    );
  }
}