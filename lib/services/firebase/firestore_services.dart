import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireStoreServices {
  FireStoreServices({required this.userUid});
  final String userUid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser() async {
    final Map<String, dynamic> data = <String, dynamic>{
      'equipmentCode': '001',
      'description': 'Macbook',
      'equipmentSpecs': 'M1 Chip',
      'imageUrl':
      'https://upload.wikimedia.org/wikipedia/en/4/43/MacBook_Air_2011_School_Computer_May_2017.png',
      'isAssigned': 'false',
      'assignedTo': 'kbkentoy29@gmail.com',
    };

    final DocumentReference documentReferencer = _firestore
        .collection('equipment')
        .doc();

    await documentReferencer.set(data).whenComplete(() {
      if (kDebugMode) {
        print('User added to the database');
      }
    }).catchError((e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    });
  }

  Future<void> addEquipment(
      String equipmentCode, String description, String equipmentSpecs, String imageUrl, bool isAssigned, String assignedTo) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'equipmentCode': equipmentCode,
      'description': description,
      'equipmentSpecs': equipmentSpecs,
      'imageUrl': imageUrl,
      'isAssigned' : isAssigned,
      'assignedTo' : assignedTo,
    };

    final DocumentReference documentReferencer = _firestore
        .collection('equipment')
        .doc();

    await documentReferencer.set(data).whenComplete(() {
      if (kDebugMode) {
        print('equipment added to the database');
      }
    }).catchError((e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    });
  }
}

Future<void> addRequest({
  required String userName,
  required String schedule,
  required String purpose,
  required String position,
  required String equipmentId,
}) async {
  try {
    final Map<String, dynamic> requestData = {
      'userName': userName,
      'position': position,
      'schedule': schedule,
      'purpose': purpose,
      'equipmentId': equipmentId,
    };

    await FirebaseFirestore.instance.collection('request').add(requestData);

    if (kDebugMode) {
      print('Request added to Firestore');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }
  }
}
