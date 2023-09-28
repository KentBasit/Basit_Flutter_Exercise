import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/firebase/authentication.dart';
import '../../../services/firebase/firestore_services.dart';

class EquipmentListViewModel {
  final firebaseAuth = Authentication(FirebaseAuth.instance);
  final codeController = TextEditingController();
  final specsController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final imageUrlController = TextEditingController();
  final assignedToController = TextEditingController();
  final equipmentFormkey = GlobalKey<FormState>();
  bool isAssigned = false;

  Stream<QuerySnapshot> getEquipmentStream() {
    return FirebaseFirestore.instance
        .collection('equipment')
        .snapshots();
  }

  Future<void> addEquipment() async {
    final fireStoreService =
    FireStoreServices(userUid: firebaseAuth.getCurrentUserUid() ?? '');
    fireStoreService.addEquipment(
      codeController.text,
      descriptionController.text,
      specsController.text,
      imageUrlController.text,
      isAssigned,
      assignedToController.text,
    );
  }
}
