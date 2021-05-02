import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> register(String email, String password, String name) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    String uID = FirebaseAuth.instance.currentUser.uid;
    DocumentReference docRef = FirebaseFirestore.instance.collection('Users').doc(uID);
    docRef.set({
      'name' : name,
      'email' : email,
    });

    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The Password provided is too weak');
    } else if (e.code == 'email-already-in-use') {
      print('The Email is already in use!');
    }
    return false;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('Signed Out!');
    print(FirebaseAuth.instance.currentUser);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}