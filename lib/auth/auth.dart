import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartcar/global/common/toast.dart';
// xu li lognin logout signup trong file nay
class FirebaseAuthService{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<User?> signUpWithEmailAndPassword (String email, String password) async{
    try{
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch(e){
      if(e.code=='email-already-in-use'){
        showToast(message: "The email address is already in use");
      }else{
        showToast(message:"An error occured");
      }
    }
    return null;
  }
  Future<User?> signInWithEmailAndPassword (String email, String password) async{
    try{
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch(e){
      if(e.code=='user-not-found'||e.code=='wrong-password'){
        showToast(message: "Invalid email or password");
      }else{
        showToast(message:"An error occured");
      }
    }
    return null;
  }
}
