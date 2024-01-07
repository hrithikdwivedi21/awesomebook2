import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/video.dart';


class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
        firestore.collection('videos').snapshots().map((QuerySnapshot query) {
          List<Video> retVal = [];
          for (var element in query.docs) {
            retVal.add(
              Video.fromSnap(element),
            );
          }
          return retVal;
        }));
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = _auth.currentUser!.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      firestore.collection('posts').doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });

      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {

      firestore.collection('posts').doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });

      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}