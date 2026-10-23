import 'package:flutter/material.dart';
import 'package:travelmate/View/Host/homescreen.dart';
import 'package:travelmate/ViewModel/property_view_model.dart';
import 'package:travelmate/global.dart';

class PropertyPrice extends StatefulWidget {
  const PropertyPrice({super.key});
  @override
  State<PropertyPrice> createState() => _PropertyPriceState();
}

class _PropertyPriceState extends State<PropertyPrice> {
  TextEditingController priceController = TextEditingController(text: '30');
  bool _addingProperty = false;

  @override
  Widget build(BuildContext context) {
    PropertyViewModel propertyVm = PropertyViewModel(propertyModel);
    return Scaffold(
      appBar: AppBar(title: const Text('Pricing')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80,),
            const Text(
              'Now, set your price',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'You can change it at any time',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color.fromARGB(45, 101, 101, 101)),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextField(
                      controller: priceController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter price...',
                        hintStyle: TextStyle(fontSize: 24),
                      ),
                      style: const TextStyle(fontSize: 30),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'DT',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 400), // Adjust the size as needed
 // Adjust the size as needed
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5), // Adjust as needed
                child: ElevatedButton(
                  onPressed: _addingProperty ? null : () async { // Disable button while adding property
                    double price = double.parse(priceController.text);
                    setState(() {
                      propertyModel.price = price;
                      _addingProperty = true; // Set to true when adding property starts
                    });
                    bool success = await propertyVm.addPropertyInfoToFirestore();
                    setState(() {
                      _addingProperty = false; // Set to false when adding property completes
                    });
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Property added successfully!')));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(
                            userId: "userId", // Replace with actual userId
                            selectedIndex: 1, // Go to listings page
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to add property.')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 147, 99, 1),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                const SizedBox(width: 320.0,),
                Text('5/5', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0)),
              ],
            ),
             _addingProperty ? const CircularProgressIndicator() : const SizedBox(), // Circular progress indicator
      
          ],
        ),
      ),
    );
  }
}
