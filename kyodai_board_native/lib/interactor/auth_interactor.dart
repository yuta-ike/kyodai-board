import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kyodai_board/firebase/firebase_auth.dart';
import 'package:kyodai_board/repo/auth_repo.dart';

/// 匿名でサインイン
Future<void> signInAnonymously() async {
  final userCredential = await auth.signInAnonymously();
  if(userCredential.additionalUserInfo.isNewUser){
    await registerUserData(userCredential.user, isAnonymous: true);
  }
}

/// Googleでサインイン
final GoogleSignIn _googleSignIn = GoogleSignIn();
Future<bool> signInGoogle() async {
  final googleSignInAccount = await _googleSignIn.signIn();
  if(googleSignInAccount == null){
    return false;
  }

  final googleSignInAuthentication = await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final userCredential = await auth.signInWithCredential(credential);
  if(userCredential.additionalUserInfo.isNewUser){
    await registerUserData(userCredential.user, isAnonymous: false);
  }
  return true;
}

/// メールアドレスでサインイン
Future<void> signInWithEmail(String email, String password) async {
  final userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
  if(userCredential.additionalUserInfo.isNewUser){
    await registerUserData(userCredential.user, isAnonymous: false);
  }
}

/// メールアドレスで登録
Future<void> signUpWithEmail(String email, String password) async {
  // TODO: エラーハンドリング.
  // try{
    // ignore: unused_local_variable
    final userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
  // }on FirebaseAuthException catch(e){

  // }
  if (!auth.currentUser.emailVerified) {
    await sendCode();
  }
}

/// 認証コードで認証（いる？）
Future<void> verifyCode(String code) async {
  await auth.checkActionCode(code);
  await auth.applyActionCode(code);
  await auth.currentUser.reload();
  await registerUserData(auth.currentUser, isAnonymous: false);
}

/// 認証コードの送信
Future<void> sendCode() async {
  await auth.currentUser.sendEmailVerification();
}

/// ログアウト
Future<void> Function() signOut = auth.signOut;

/// ユーザー情報の変更
Future<void> updateDisplayName(String newDisplayName) async {
  await auth.currentUser.updateProfile(displayName: newDisplayName);
}

/// メールアドレスの変更
Future<void> updateEmail(String newEmail) async {
  // TODO: 再認証が必要.
  await auth.currentUser.updateEmail(newEmail);
}