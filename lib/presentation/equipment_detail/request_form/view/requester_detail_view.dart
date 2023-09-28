import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequesterDetailView extends StatefulWidget {
  final String docId;

  const RequesterDetailView({Key? key, required this.docId}) : super(key: key);

  @override
  RequesterDetailViewState createState() => RequesterDetailViewState();
}

class RequesterDetailViewState extends State<RequesterDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('request')
            .where('equipmentId', isEqualTo: widget.docId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('Request not found');
          }

          final requestDoc = snapshot.data!.docs.first;
          final data = requestDoc.data() as Map<String, dynamic>;
          final userName = data['userName'] ?? 'N/A';
          final position = data['position'] ?? 'N/A';
          final schedule = data['schedule'] ?? 'N/A';
          final purpose = data['purpose'] ?? 'N/A';

          final tableData = [
            ['User Name', userName],
            ['Company Position', position],
            ['Schedule', schedule],
            ['Purpose', purpose],
          ];

          final columns = <DataColumn>[
            const DataColumn(label: Text('Field')),
            const DataColumn(label: Text('Value')),
          ];

          final rows = tableData.map((rowData) {
            return DataRow(cells: [
              DataCell(Text(rowData[0])),
              DataCell(Text(rowData[1])),
            ]);
          }).toList();

          return Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: columns,
                rows: rows,
              ),
            ),
          );
        },
      ),
    );
  }
}
