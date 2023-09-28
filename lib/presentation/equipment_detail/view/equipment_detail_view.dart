import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exercise/shared/widgets/center_app_bar.dart';

import '../../../../domain/models/equipment.dart';
import '../request_form/view/request_view.dart';
import '../request_form/view/requester_detail_view.dart';

class EquipmentDetailView extends StatefulWidget {
  const EquipmentDetailView({
    required this.equipment,
    required this.docId,
    Key? key,
  }) : super(key: key);

  final Equipment equipment;
  final String docId;

  @override
  EquipmentDetailViewState createState() => EquipmentDetailViewState();
}

class EquipmentDetailViewState extends State<EquipmentDetailView> {
  Map<String, dynamic>? requestData;

  @override
  void initState() {
    super.initState();
    fetchRequestData();
  }

  void fetchRequestData() {
    FirebaseFirestore.instance.collection('request').doc(widget.docId).get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          requestData = snapshot.data() as Map<String, dynamic>;
        });
      } else {
        if (kDebugMode) {
          print("Document with docId ${widget.docId} does not exist in 'request' collection.");
        }
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Error fetching document: $error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterAppBar(widget.equipment.equipmentCode, context),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LimitedBox(
                maxWidth: 400,
                child: Image.network(widget.equipment.imageUrl, fit: BoxFit.contain),
              ),
              const SizedBox(height: 16),
              DataTable(
                columnSpacing: 16,
                columns: const [
                  DataColumn(label: Text('Detail')),
                  DataColumn(label: Text('Value')),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Description')),
                    DataCell(Text(widget.equipment.description)),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Equipment Specs')),
                    DataCell(Text(widget.equipment.equipmentSpecs)),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Assigned To')),
                    DataCell(Text(widget.equipment.isAssigned ? widget.equipment.assignedTo : 'Not Assigned')),
                  ]),
                  if (widget.equipment.isAssigned && requestData != null)
                    DataRow(cells: [
                      const DataCell(Text('Requester Name')),
                      DataCell(Text(requestData!['userName'] ?? 'N/A')),
                    ]),

                ],
              ),
              if (!widget.equipment.isAssigned)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RequestForm(
                          userName: widget.equipment.assignedTo,
                          docId: widget.docId,
                        ),
                      ),
                    );
                  },
                  child: const Text('Request'),
                ),
              if (widget.equipment.isAssigned)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RequesterDetailView(docId: widget.docId),
                      ),
                    );
                  },
                  child: const Text('View Request Details'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
