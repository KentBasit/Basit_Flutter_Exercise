import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_exercise/domain/models/equipment.dart';
import 'package:flutter_exercise/shared/widgets/center_app_bar.dart';
import '../../equipment_detail/view/equipment_detail_view.dart';
import '../view_model/equipment_list_view_model.dart';

class AssignedEquipmentListView extends StatelessWidget {
  AssignedEquipmentListView({super.key});

  final viewModel = EquipmentListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterAppBar(
        'Assigned Equipment',
        context,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamBuilder<QuerySnapshot?>(
            stream: viewModel.getEquipmentStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final data = snapshot.data;
              if (data == null || data.docs.isEmpty) {
                return const Text('No assigned equipment found');
              }

              final filteredData = data.docs
                  .where((doc) => doc['isAssigned'] == true)
                  .toList();

              return ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final equipmentData =
                  filteredData[index].data() as Map<String, dynamic>;
                  final docId = filteredData[index].reference.id;

                  final equipment = Equipment(
                    equipmentCode: equipmentData['equipmentCode'] ?? '',
                    description: equipmentData['description'] ?? '',
                    equipmentSpecs: equipmentData['equipmentSpecs'] ?? '',
                    imageUrl: equipmentData['imageUrl'] ?? '',
                    isAssigned: equipmentData['isAssigned'] ?? false,
                    assignedTo: equipmentData['assignedTo'] ?? '',
                  );

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(equipment.imageUrl),
                      title: Text(equipment.equipmentCode),
                      trailing: Text(equipment.assignedTo),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EquipmentDetailView(
                              equipment: equipment,
                              docId: docId,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
