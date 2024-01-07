import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funbook/models/story.dart';
import 'package:story_view/story_view.dart';

class StoryPageView extends StatefulWidget {
  final uid;
  const StoryPageView({Key? key, this.uid}) : super(key: key);

  @override
  State<StoryPageView> createState() => _StoryPageViewState();
}


class _StoryPageViewState extends State<StoryPageView> {
  var storyData = {};

  @override
  void initState() {
    super.initState();
    getData();
  }


  getData() async {

    var userSnap = await FirebaseFirestore.instance
        .collection('story')
        .where("uid",isEqualTo: widget.uid)
        .get();
    print(userSnap);
    // storyData = userSnap.data()!;
  }

  final controller = StoryController();
  @override
  Widget build(BuildContext context) {
    print(storyData);
    List<StoryItem> storyItems = [
      StoryItem.pageImage(url: "https://st1.bollywoodlife.com/wp-content/uploads/2021/11/Hrithik-Roshan.jpg",controller: controller,caption: "Hello, from the other side2",),
      StoryItem.pageImage(url: "https://cdn1-production-images-kly.akamaized.net/HPclmuh1u6OOTniy0yE42gUaNWI=/1200x900/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/1796535/original/029253100_1512903389-hrithik_roshan-2.jpg",controller: controller,caption: "Hello, from the other side2",),
    ]; //
    return Material(
      child: StoryView(
          storyItems: storyItems,
          controller: controller,
          inline: false,
          repeat: false,
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              Navigator.pop(context);
            }
          }),
    );
  }
}
