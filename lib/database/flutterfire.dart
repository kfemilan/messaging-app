import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/models/Account.dart';

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
      'name': name,
      'email': email,
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

Future<int> createConversation(List<Account> users, String name) async {
  try {
    // Get uID of current user
    var uID = FirebaseAuth.instance.currentUser.uid;
    List<String> userIDs = users.map((value) => value.id).toList();
    userIDs.add(uID);
    userIDs.sort();

    QuerySnapshot x = await FirebaseFirestore.instance.collection("Conversations").where("people", isEqualTo: userIDs).get();
    print(x.size);
    if (x.size != 0) {
      return -1;
    }

    DocumentReference conRef = await FirebaseFirestore.instance.collection('Conversations').add({'name': name, 'people': userIDs});

    for (var i = 0; i < userIDs.length; i++) {
      DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(userIDs[i]);
      userRef.update({
        'conversations': FieldValue.arrayUnion([conRef.id])
      });
    }

    return 1;
  } catch (e) {
    print(e);
    return 0;
  }
}

Future<String> getName(String userId) async {
  try {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    String name = userSnapshot.data()['name'] as String;
    return name;
  } on Exception catch (e) {
    print(e);
    return "Error Retrieving Name";
  }
}

Future<bool> leaveConversation(String conversationId) async {
  try {
    // await FirebaseFirestore.instance.collection('Conversations').doc(conversationId).delete();
    DocumentSnapshot convoSnapshot = await FirebaseFirestore.instance.collection('Conversations').doc(conversationId).get();
    List<dynamic> people = convoSnapshot.data()['people'];

    if (people.length <= 2) // If only two people are in the convo
      await FirebaseFirestore.instance.collection('Conversations').doc(conversationId).delete();
    else {
      // If Group chat
      DocumentReference convoRef = FirebaseFirestore.instance.collection('Conversations').doc(conversationId);
      convoRef.update({
        'people': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser.uid])
      });
    }
    return true;
  } on Exception catch (e) {
    print("Deletion/Leave failed! Error: $e");
  }
  return false;
}
