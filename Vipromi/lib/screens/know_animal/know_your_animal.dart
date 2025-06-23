import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipromi/viewmodels/feed_bloc/feed_bloc.dart';
import 'package:vipromi/models/feed_product_model.dart';

class KnowYourAnimal extends StatefulWidget {
  const KnowYourAnimal({super.key});
  @override
  State<KnowYourAnimal> createState() {
    return _KnowYourAnimalState();
  }
}

class _KnowYourAnimalState extends State<KnowYourAnimal> {
  ConsumerProduct? selectedProduct;
  final TextEditingController quantityController = TextEditingController();

  // Recommended values (for a 20kg DMI cow):
  final double requiredProtein = 3.2;
  final double requiredFat = 0.6;
  final double requiredFiber = 4.4;
  final double requiredAsh = 1.2;
  final double requiredMoisture = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OutlinedButton(
        onPressed: () {
          // Triggering the check action
          _checkNutritionalValues(context);
        },
        child: Text('Check'),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text("Know Your Animal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select a Raw Material"),
                  DropdownButton<ConsumerProduct>(
                    isExpanded: true,
                    value: selectedProduct,
                    hint: Text("Choose Raw Material"),
                    items: state.allProducts.map((product) {
                      return DropdownMenuItem(
                        value: product,
                        child: Text(product.rawMaterial),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProduct = value;
                        quantityController.clear();
                      });
                    },
                  ),
                  if (selectedProduct != null) ...[
                    SizedBox(height: 16),
                    TextField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        labelText: "Enter Quantity (kg)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        final quantity = double.tryParse(quantityController.text) ?? 0;
                        if (quantity > 0) {
                          context.read<FeedBloc>().add(ProductSelected(selectedProduct!));
                          context.read<FeedBloc>().add(UpdateProductQuantity(
                            product: selectedProduct!,
                            quantityInKg: quantity,
                          ));
                        }
                      },
                      child: Text("Add to Calculation"),
                    ),
                  ],
                  SizedBox(height: 24),
                  Text("Added Materials:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  if (state.selectedProducts.isEmpty)
                    Text("No materials added yet."),
                  ...state.selectedProducts.map((sp) => Card(
                    child: ListTile(
                      title: Text(sp.product.rawMaterial),
                      subtitle: Text("Quantity: ${sp.quantityInKg} kg"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<FeedBloc>().add(RemoveProduct(sp.product));
                        },
                      ),
                    ),
                  )),
                  SizedBox(height: 24),
                  Text("Nutritional Totals:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Protein: ${state.totalProtein.toStringAsFixed(2)} kg  (Required: 3.2 kg)"),
                  Text("Fat: ${state.totalFat.toStringAsFixed(2)} kg  (Required: 0.6 kg)"),
                  Text("Fiber: ${state.totalFiber.toStringAsFixed(2)} kg  (Required: 4.4 kg)"),
                  Text("Ash: ${state.totalAsh.toStringAsFixed(2)} kg  (Required: 1.2 kg)"),
                  Text("Moisture: ${state.totalMoisture.toStringAsFixed(2)} kg  (Required: 10 kg)"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _checkNutritionalValues(BuildContext context) {
    final FeedState state = context.read<FeedBloc>().state;
    bool anyAlertShown = false;

    // Check each nutritional value and show SnackBar if the value is sufficient
    if (state.totalProtein >= requiredProtein) {
      _showSuccessSnackBar(context, "Protein quantity is good! ✅");
      anyAlertShown = true;
    }
    if (state.totalFat >= requiredFat) {
      _showSuccessSnackBar(context, "Fat quantity is good! ✅");
      anyAlertShown = true;
    }
    if (state.totalFiber >= requiredFiber) {
      _showSuccessSnackBar(context, "Fiber quantity is good! ✅");
      anyAlertShown = true;
    }
    if (state.totalAsh >= requiredAsh) {
      _showSuccessSnackBar(context, "Ash quantity is good! ✅");
      anyAlertShown = true;
    }
    if (state.totalMoisture >= requiredMoisture) {
      _showSuccessSnackBar(context, "Moisture quantity is good! ✅");
      anyAlertShown = true;
    }

    if (!anyAlertShown) {
      _showFailureSnackBar(context, "meet the requirement");
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text(message),
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showFailureSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 8),
          Text(message),
        ],
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }
}
