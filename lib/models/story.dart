import 'package:cloud_firestore/cloud_firestore.dart';

class Story {

  final String uid;
  final String username;
  final String storyId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;


  const Story(
      {
        required this.uid,
        required this.username,
        required this.storyId,
        required this.datePublished,
        required this.postUrl,
        required this.profImage,

      });

  static Story fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Story(

        uid: snapshot["uid"],
        storyId: snapshot["storyId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],

    );
  }

  Map<String, dynamic> toJson() => {

    "uid": uid,
    "username": username,
    "storyId": storyId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profImage': profImage,

  };
}