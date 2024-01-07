import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:funbook/firebase_services/storage_methods.dart';
import 'package:funbook/models/user.dart' as model;
import 'package:google_sign_in/google_sign_in.dart';
class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file!=null
          ) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl =
        await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User _user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
            is_subscribed:false
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(_user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<String> updateUser({
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    User currentUser = _auth.currentUser!;
    String res = "Some error Occurred";
    try {
      if (
          username.isNotEmpty ||
          bio.isNotEmpty
      ) {
          String? photoUrl;
          photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

          await _firestore
              .collection("users")
              .doc(currentUser.uid)
              .update({"bio": bio, "username": username,"photoUrl":photoUrl});

          await _firestore
              .collection("posts")
              .where("uid",isEqualTo: currentUser.uid)
              .get()
              .then((value) => value.docs.forEach((doc) {
            doc.reference.update({'bio': bio,'username':username,'photoUrl':photoUrl});
          }));


        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateUserdata({
    required String username,
    required String bio,
  }) async {
    User currentUser = _auth.currentUser!;
    String res = "Some error Occurred";
    try {
      if (
      username.isNotEmpty ||
          bio.isNotEmpty
      ) {


          await _firestore
              .collection("users")
              .doc(currentUser.uid)
              .update({"bio": bio, "username": username});

          await _firestore
              .collection("posts")
              .where("uid",isEqualTo: currentUser.uid)
              .get()
              .then((value) => value.docs.forEach((doc) {
            doc.reference.update({'bio': bio,'username':username});
          }));


        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<String> googleLogin() async {
    print("googleLogin method Called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    String res = "Some error Occurred";
    try {
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return '';
      }

      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
      await FirebaseAuth.instance.signInWithCredential(credential);

      model.User _user = model.User(
        username: result.displayName!,
        uid: finalResult.user!.uid,
        email: result.email,
        bio: "",
        followers: [],
        following: [],
        photoUrl: result.photoUrl!,
          is_subscribed:false
      );

      // adding user in our database
      await  FirebaseFirestore.instance
          .collection("users")
          .doc(finalResult.user!.uid)
          .set(_user.toJson());

      res = "success";

    } catch (error) {
      return error.toString();
    }
    return res;
  }



  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    }
    on FirebaseAuthException catch (e){
      if(e.code=='wrong-password'){
        res = "Please enter a valid password";
      }
      if(e.code=='user-not-found'){
        res = "You are not registered with us";
      }
      if(e.code=='invalid-email'){
        res = "Please enter a valid email id";
      }
      // res = e.toString();
    }
    catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}