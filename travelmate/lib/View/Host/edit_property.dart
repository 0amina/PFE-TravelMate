import 'package:flutter/material.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/ViewModel/property_view_model.dart';

class EditPropertyPage extends StatefulWidget {
  final PropertyModel property;

  const EditPropertyPage({Key? key, required this.property}) : super(key: key);

  @override
  _EditPropertyPageState createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.property.title ?? '';
    _descriptionController.text = widget.property.description ?? '';
    _priceController.text = widget.property.price?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Property'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter title...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter description...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Price:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                hintText: 'Enter price...',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                // Update property details
                widget.property.title = _titleController.text;
                widget.property.description = _descriptionController.text;
                widget.property.price = double.tryParse(_priceController.text) ?? 0;

                // Save updated property to Firestore
                bool success = await PropertyViewModel(widget.property).updateProperty(widget.property);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Property updated successfully!'),
                  ));
                  Navigator.pop(context); // Go back to previous page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Failed to update property.'),
                  ));
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
