class Equipment {
  String equipmentCode;
  String description;
  String equipmentSpecs;
  String imageUrl;
  bool isAssigned;
  String assignedTo;

  Equipment({
    this.equipmentCode = '',
    this.description = '',
    this.equipmentSpecs = '',
    this.imageUrl = '',
    this.isAssigned = false,
    this.assignedTo = '',
  });
}
