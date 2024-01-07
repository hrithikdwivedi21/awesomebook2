import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

import '../models/postvideo.dart';
import '../models/video.dart';

class UploadVideoController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;


  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = _storage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = _storage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload video
  Future<String> uploadVideo(String songName, String caption, String videoPath) async {
    String res="Some error occured";
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc =
      await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String postUrl = await _uploadImageToStorage("Video $len", videoPath);
      String postId = const Uuid().v1(); // creates unique id based on time
      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        uid: uid,
        id: postId,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['photoUrl'],
        thumbnail: postUrl,

      );

      await firestore.collection('videos').doc(postId).set(
        video.toJson(),
      );


      PostVideo postvideo = PostVideo(
        description: caption,
        uid: uid,
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: (userDoc.data()! as Map<String, dynamic>)['photoUrl'],
        category:'',
        videoUrl: videoUrl,
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        postType: 'Video'
      );
      firestore.collection('posts').doc(postId).set(postvideo.toJson());

      res ="Success";
      return res;
    } catch (e) {

      res =  e.toString();
      return res;

    }
  }
}