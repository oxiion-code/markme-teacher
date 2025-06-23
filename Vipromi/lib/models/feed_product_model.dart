class ConsumerProduct {
  final int serialNo;
  final String rawMaterial;
  final double fatPercent;
  final double proteinPercent;
  final double fiberPercent;
  final double ashPercent;
  final double moisturePercent;
  final int energyKcalPerKg;
  final double fatKg;
  final double proteinKg;
  final double fiberKg;
  final double ashKg;
  final double moistureKg;

  ConsumerProduct({
    required this.serialNo,
    required this.rawMaterial,
    required this.fatPercent,
    required this.proteinPercent,
    required this.fiberPercent,
    required this.ashPercent,
    required this.moisturePercent,
    required this.energyKcalPerKg,
    required this.fatKg,
    required this.proteinKg,
    required this.fiberKg,
    required this.ashKg,
    required this.moistureKg,
  });

  factory ConsumerProduct.fromJson(Map<String, dynamic> json) {
    return ConsumerProduct(
      serialNo: json['S. No.'] as int,
      rawMaterial: json['Raw Material'] as String,
      fatPercent: (json['Fat (%)'] as num).toDouble(),
      proteinPercent: (json['Protein (%)'] as num).toDouble(),
      fiberPercent: (json['Fiber (%)'] as num).toDouble(),
      ashPercent: (json['Ash (%)'] as num).toDouble(),
      moisturePercent: (json['Moisture (%)'] as num).toDouble(),
      energyKcalPerKg: json['Energy (kcal/kg)'] as int,
      fatKg: (json['Fat (kg)'] as num).toDouble(),
      proteinKg: (json['Protein (kg)'] as num).toDouble(),
      fiberKg: (json['Fiber (kg)'] as num).toDouble(),
      ashKg: (json['Ash (kg)'] as num).toDouble(),
      moistureKg: (json['Moisture (kg)'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'S. No.': serialNo,
      'Raw Material': rawMaterial,
      'Fat (%)': fatPercent,
      'Protein (%)': proteinPercent,
      'Fiber (%)': fiberPercent,
      'Ash (%)': ashPercent,
      'Moisture (%)': moisturePercent,
      'Energy (kcal/kg)': energyKcalPerKg,
      'Fat (kg)': fatKg,
      'Protein (kg)': proteinKg,
      'Fiber (kg)': fiberKg,
      'Ash (kg)': ashKg,
      'Moisture (kg)': moistureKg,
    };
  }
}