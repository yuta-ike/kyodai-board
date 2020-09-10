import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/repo/auth_repo.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> signInGoogle() async {
  final googleSignInAccount = await _googleSignIn.signIn();
  final googleSignInAuthentication = await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final userCredential = await auth.signInWithCredential(credential);
  if(userCredential.additionalUserInfo.isNewUser){
    await registerUserData(userCredential.user);
  }
}

Future<void> Function() signOut = auth.signOut;