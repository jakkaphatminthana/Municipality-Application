import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  //TODO : Import Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //TODO : เรียกข้อมูล User ณ ตอนนี้
  Stream<User?> get authStateChenges => _auth.idTokenChanges();

  //==========================================================================================================

  // //TODO 1. Function Register with Email
  // Future registerEmail(String email, String password) async {
  //   //TODO try ตรวจสอบโค้ด
  //   try {
  //     //TODO : Register
  //     await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: "${email}@gmail.com", password: password)
  //         .then((value) async {
  //       //TODO : อ้างอิง User ปัจจุบันตอนนี้
  //       User? userEZ = FirebaseAuth.instance.currentUser;

  //       //TODO : สร้าง Model Database Profile
  //       await FirebaseFirestore.instance
  //           .collection("users")
  //           .doc(userEZ?.uid)
  //           .set({
  //         "id": userEZ?.uid,
  //         "username": email,
  //         "role": "Member",
  //       });
  //     });

  //     //TODO : Check Error
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       Fluttertoast.showToast(
  //         msg: "รหัสผ่านไม่ปลอดภัย",
  //         gravity: ToastGravity.CENTER,
  //       );
  //     } else if (e.code == 'email-already-in-use') {
  //       Fluttertoast.showToast(
  //         msg: "บัญชีนี้มีอยู่แล้วในระบบแล้ว",
  //         gravity: ToastGravity.CENTER,
  //       );
  //     }
  //     return "not_work";
  //   }
  // }

  //TODO 2. Function Login
  Future LoginEmail(String email, String password) async {
    try {
      //TODO : Login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${email}@gmail.com", password: password);

      //TODO : Check Error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: "ไม่พบบัญชีนี้",
          gravity: ToastGravity.BOTTOM,
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: "รหัสผ่านผิดหรือเลขบัตรไม่ถูกต้อง",
          gravity: ToastGravity.BOTTOM,
        );
      }
      return "not_work";
    }
  }

  //=====================================================================================================
  //TODO 1: Add user by admin
  Future signUpWithEmailPasswordAdminPastor(
    String email,
    String password,
  ) async {
    try {
      FirebaseApp tempApp = await Firebase.initializeApp(
          name: 'temporaryregister', options: Firebase.app().options);

      //TODO 1.1: สร้าง user โดยไม่ต้อง login
      UserCredential result = await FirebaseAuth.instanceFor(app: tempApp)
          .createUserWithEmailAndPassword(
              email: "${email}@gmail.com", password: password);

      //TODO 1.2: สร้าง Model Database Profile
      await FirebaseFirestore.instance
          .collection("users")
          .doc(result.user!.uid)
          .set({
        "id": result.user!.uid,
        "username": email,
        "role": "Member",
        "point": 0,
      }).then((value) {
        Fluttertoast.showToast(
          msg: "เพิ่มเสร็จแล้ว",
          gravity: ToastGravity.BOTTOM,
        );
      });

      tempApp.delete();
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "!!! รหัสผ่านเดาง่ายเกินไป",
          gravity: ToastGravity.BOTTOM,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "!!! มีบัญชีนี้อยู่ในระบบแล้ว",
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
