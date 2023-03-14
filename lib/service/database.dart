//TODO : ติดต่อกับ firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseEZ {
  static DatabaseEZ instance = DatabaseEZ._();
  DatabaseEZ._();

  Future<void> createUserData(String? username, String? password) async {
    final reference = FirebaseFirestore.instance.collection('user_test');
  }

  //==========================================================================================================
  //TODO : ADD ===============================================================================================

  //TODO : ADD trashType
  Future<void> createTrashType({
    required uid,
    required image_url,
    required name,
  }) async {
    final reference = FirebaseFirestore.instance.collection('trash');

    await reference.doc(uid).set({
      'id': uid,
      'image': image_url,
      'name': name,
      'status': true,
      'timestamp': DateTime.now(),
      'time_create': DateTime.now(),
    });
  }

  //TODO : ADD trashItem
  Future<void> createTrashItem({
    required String typeId,
    required name,
    required double point,
    required subtitle,
  }) async {
    final reference = FirebaseFirestore.instance.collection('trash');

    await reference.doc(typeId).collection('item').add({
      "typeId": typeId,
      "name": name,
      "subtitle": (subtitle != '') ? subtitle : "---",
      "point": point,
      "status": true,
      'timestamp': DateTime.now(),
      'time_create': DateTime.now(),
    });
  }

  //==========================================================================================================
  //TODO : UPDATE ============================================================================================

  //TODO : UPDATE Trash Type
  Future<void> updateTrashType({
    required String typeId,
    required String typeName,
    image_new,
  }) async {
    final reference = FirebaseFirestore.instance.collection('trash');

    //1.กรณีมีรูป
    if (image_new != null) {
      await reference.doc(typeId).update({
        "image": image_new,
        "name": typeName,
        'timestamp': DateTime.now(),
      });
      //2.กรณีไม่มีรูป
    } else {
      await reference.doc(typeId).update({
        "name": typeName,
        'timestamp': DateTime.now(),
      });
    }
  }

  //TODO : UPDATE Trash Item
  Future<void> updateTrashItem({
    required trashId,
    required typeId,
    required name,
    required double point,
    required subtitle,
  }) async {
    final reference = FirebaseFirestore.instance.collection('trash');

    await reference.doc(typeId).collection('item').doc(trashId).update({
      'name': name,
      'point': point,
      'subtitle': (subtitle != '') ? subtitle : "---",
      'timestamp': DateTime.now(),
    });
  }

  //==========================================================================================================
  //TODO : DELETE =============================================================================================

  //TODO : DELETE Trash type
  Future<void> deleteTrashType({required String typeId}) async {
    final reference = FirebaseFirestore.instance.collection('trash');
    await reference.doc(typeId).delete();
  }

  //TODO : DELETE Trash item
  Future<void> deleteTrashItem({
    required String typeId,
    required String itemId,
  }) async {
    final reference = FirebaseFirestore.instance.collection('trash');
    await reference.doc(typeId).collection('item').doc(itemId).delete();
  }
}
