import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exercise/domain/models/equipment.dart';
import 'package:flutter_exercise/shared/widgets/center_app_bar.dart';

import '../../../shared/widgets/custom_dialog.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../equipment_detail/view/equipment_detail_view.dart';
import '../view_model/equipment_list_view_model.dart';

class EquipmentListView extends StatelessWidget {
  EquipmentListView({super.key});

  final viewModel = EquipmentListViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterAppBar(
        'Equipment',
        context,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showAddEquipmentDialog(context);
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<QuerySnapshot?>(
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
                          .where((doc) => doc['isAssigned'] == false)
                          .toList();

                      if (filteredData.isEmpty) {
                        return const Text('No available equipment found');
                      }

                      return Expanded(
                        child: ListView.builder(
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
                              padding: const EdgeInsets.all(8),
                              child: ListTile(
                                leading: Image.network(equipment.imageUrl),
                                title: Text(equipment.equipmentCode),
                                trailing: Text(equipment.equipmentSpecs),
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
                        ),
                      );
                    },
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAddEquipmentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      builder: (context) => CustomDialog(
        padding: EdgeInsets.zero,
        onPressed: () async {
          if (viewModel.equipmentFormkey.currentState!.validate()) {
            viewModel.addEquipment();
            Navigator.of(context).pop();
          }
        },
        height: MediaQuery.of(context).size.height / 1.3,
        description: Padding(
            padding: const EdgeInsets.fromLTRB(23, 0, 23, 16),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        padding: const EdgeInsets.only(bottom: 24, top: 16),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.primary,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Form(
                      key: viewModel.equipmentFormkey,
                      child: Column(
                        children: [
                          CustomTextField(
                            viewModel.codeController,
                            labelText: 'Code',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter equipment code.';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            viewModel.descriptionController,
                            labelText: 'Description',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter description.';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            viewModel.specsController,
                            labelText: 'Specs',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter specs.';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            viewModel.imageUrlController,
                            labelText: 'Image',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter image url.';
                              }
                              return null;
                            },
                          ),

                        ],
                      ),
                    ),
                  ],
                ))),
        bottomPadding: const EdgeInsets.only(bottom: 24),
        buttonLabel: 'ADD',
      ),
      barrierColor: Colors.black.withOpacity(0.4),
    );
  }
}
