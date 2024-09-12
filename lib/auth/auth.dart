import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartcar/global/common/toast.dart';
// xu li lognin logout signup trong file nay
class FirebaseAuthService{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<User?> signUpWithEmailAndPassword (String email, String password, String username) async{
    try{
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user; // luu bien dang nhap credential vao trong bien user
      //cap nhat displayName ()
      await user?.updateDisplayName(username);// cap nhat thuoc tinh displayname nho vao username va dung toan tu ? de chac rang dung no la null van khong bi loi
      await user?.updateDisplayName(email);
      await user?.reload();//   de cap nhat nhung thay doi trong firebase
      return _firebaseAuth.currentUser;//tra ve thong tin nguoi dung dang nhap
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
      User?user= credential.user;
      if(user!=null){
        String?username=user.displayName;//lay username
      }
      return user;
    } on FirebaseAuthException catch(e){
      if(e.code=='user-not-found'||e.code=='wrong-password'){
        showToast(message: "Invalid email or password");
      }else{
        showToast(message:"An error occured");
      }
    }
    return null;
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
