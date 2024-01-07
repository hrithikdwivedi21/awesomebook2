import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:funbook/firebase_services/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/posts.dart';
import '../models/story.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  //  upload post
  Future<String> uploadPost(
      String description, Uint8List file, String uid,
      String username, String profImage,String selectedValue
      ) async{
    String res = "some error occured";
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        category:selectedValue,
        postType: 'Image'
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  // Upload Story
  Future<String> uploadStory(
      Uint8List file, String uid,
      String username, String profImage
      ) async{
    String res = "some error occured";
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage('story', file, true);
      String storyId = const Uuid().v1(); // creates unique id based on time
      Story story = Story(
        uid: uid,
        username: username,
        storyId: storyId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,

      );

      _firestore.collection('story').doc(storyId).set(story.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes , String username , String postUrl , String profilePic , String postOwnerId, String postType) async {
    String res = "Some error occurred";
    try {
      bool isNotOwner = _auth.currentUser!.uid != postOwnerId;
      DocumentSnapshot doc = await _firestore.collection('videos').doc(postId).get();
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });

        if(postType=='Video') {
          if ((doc.data()! as dynamic)['likes'].contains(uid)) {
            await _firestore.collection('videos').doc(postId).update({
              'likes': FieldValue.arrayRemove([uid]),
            });
          } else {
            await _firestore.collection('videos').doc(postId).update({
              'likes': FieldValue.arrayUnion([uid]),
            });
          }
        }
        if(isNotOwner) {
          _firestore.collection('notifications').doc(postOwnerId).collection(
              'feeditems').doc(postId).delete();
        }

      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });

        if(isNotOwner) {
          _firestore.collection('notifications').doc(postOwnerId).collection(
              'feeditems').doc(postId).set(
              {
                "type": "like",
                "uid": uid,
                "username": username,
                "postId": postId,
                "postUrl": postUrl,
                "profilePic": profilePic,
                "timestamp": DateTime.now()
              });
        }
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic , String postUrl , String postOwnerId) async {
    String res = "Some error occurred";
    try {
      bool isNotOwner = _auth.currentUser!.uid != postOwnerId;
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });

        if(isNotOwner) {
          _firestore.collection('notifications').doc(postOwnerId).collection(
              'feeditems').add(
              {
                "type": "Comment",
                "uid": uid,
                "username": name,
                "comment":text,
                "postId": postId,
                "postUrl": postUrl,
                "profilePic": profilePic,
                "timestamp": DateTime.now()
              });
        }
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<String> postVideoComment(String id, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('videos')
            .doc(id)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });

        var collection = FirebaseFirestore.instance.collection('videos');
        collection
            .doc(id)
            .update({'commentCount' : FieldValue.increment(1)});


        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(
      String uid,
      String followId
      ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      print(e.toString());
    }
  }


}