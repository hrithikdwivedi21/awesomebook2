import 'package:cloud_firestore/cloud_firestore.dart';

class PostVideo {
  final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final String category;
  final String videoUrl;
  final int commentCount;
  final int shareCount;
  final String songName;
  final String postType;

  const PostVideo(
      {required this.description,
        required this.uid,
        required this.username,
        required this.likes,
        required this.postId,
        required this.datePublished,
        required this.postUrl,
        required this.profImage,
        required this.category,
        required this.videoUrl,
        required this.commentCount,
        required this.shareCount,
        required this.songName,
        required this.postType,
      });

  static PostVideo fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostVideo(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        category: snapshot['category'],
        videoUrl: snapshot['videoUrl'],
        commentCount: snapshot['commentCount'],
        shareCount: snapshot['shareCount'],
        songName:snapshot['songName'],
        postType:snapshot['postType']
    );
  }

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "likes": likes,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profImage': profImage,
    'category':category,
    'videoUrl':videoUrl,
    'commentCount':commentCount,
    'shareCount':shareCount,
    'songName':songName,
    'postType':postType,
  };
}