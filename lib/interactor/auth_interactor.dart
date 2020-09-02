import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> signInGoogle() async {
  final googleSignInAccount = await googleSignIn.signIn();
  final googleSignInAuthentication = await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  await auth.signInWithCredential(credential);
}

Future<void> Function() signOut = auth.signOut;