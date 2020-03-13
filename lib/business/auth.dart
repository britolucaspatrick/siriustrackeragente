import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:siriustrackeragente/models/user.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Auth {
  static Future<void> resetPassword() async {
    getCurrentFirebaseUser().then((value){
      return FirebaseAuth.instance.sendPasswordResetEmail(email: value.email);
    });
  }

  static Future<GoogleSignInAccount> signOutGoogle() async {
    await GoogleSignIn().signOut();
  }

  static Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return user.user;
  }

  static Future<String> signUp(String email, String password) async {
    AuthResult user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return user.user.uid;
  }

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  static void addUser(User user) async {
    print(user.userID);
    checkUserExist(user.userID).then((value) {
      if (!value) {
        Firestore.instance
            .document("users/${user.userID}")
            .setData(user.toJson());
      } else {
        //update
        Firestore.instance
            .document('users/${user.userID}')
            .updateData(user.toJson());
      }
    });
  }

  static Future<bool> checkUserExist(String userID) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$userID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Stream<User> getUser(String userID) {
    return Firestore.instance
        .collection("users")
        .where("userID", isEqualTo: userID)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return User.fromDocument(doc);
      }).first;
    });
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'Usuário com este email não encontrado.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Senha inválida.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'Sem conexão à internet.';
          break;
        case 'The email address is already in use by another account.':
          return 'O endereço de email já foi utilizado.';
          break;
        default:
          return 'Ocorreu um erro desconhecido.';
      }
    } else {
      return 'Ocorreu um erro desconhecido.';
    }
  }
}
