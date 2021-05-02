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

Future<bool> createPM(Account user) async {
  try {
    // Get uID of current user
    var uID = FirebaseAuth.instance.currentUser.uid;

    // Create the ConversationID for Private Message
    var pmID = uID + "_" + user.id;

    //Add a conversation with blank name for PMs
    await FirebaseFirestore.instance.collection('Conversations').doc(pmID).set({"name": ""});

    //Get Reference of the Collection of People in a Conversation
    CollectionReference peopleRef = FirebaseFirestore.instance.collection('Conversations').doc(pmID).collection('People');

    // Add current user and target user as people in the conversation
    peopleRef.doc(user.id).set({});
    peopleRef.doc(uID).set({});
    await FirebaseFirestore.instance.collection('Users').doc(uID).collection('Conversations').doc(pmID).set({});
    await FirebaseFirestore.instance.collection('Users').doc(user.id).collection('Conversations').doc(pmID).set({});

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> createGC(List<Account> users, String gcName) async {
  try {
    // Add a Conversation with GC Name
    DocumentReference conRef = await FirebaseFirestore.instance.collection('Conversations').add({"name": gcName});

    // Get Refrence for Collection of People within the conversation
    CollectionReference peopleRef = FirebaseFirestore.instance.collection('Conversations').doc(conRef.id).collection('People');

    // get current user's ID
    var uID = FirebaseAuth.instance.currentUser.uid;

    // Add the user as part of the people in the conversation
    peopleRef.doc(uID).set({});
    // Add the conversation as part of the conversations of that user
    await FirebaseFirestore.instance.collection('Users').doc(uID).collection('Conversations').doc(conRef.id).set({});

    // Do the same above, but for all the users added by the current user
    for (var i = 0; i < users.length; i++) {
      peopleRef.doc(users[i].id).set({});
      await FirebaseFirestore.instance.collection('Users').doc(users[i].id).collection('Conversations').doc(conRef.id).set({});
    }

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
