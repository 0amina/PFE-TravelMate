import 'package:flutter/material.dart';
import 'package:travelmate/View/Host/navpages/AddProperty/PropertyPrice.dart';
import 'package:travelmate/global.dart';

class PropertyDescrip extends StatefulWidget {
  const PropertyDescrip({super.key});
  @override
  State<PropertyDescrip> createState() => _PropertyDescripState();
}

class _PropertyDescripState extends State<PropertyDescrip> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Description')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Enter title...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter description...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
        const SizedBox(height: 350),
Align(
  alignment: Alignment.centerRight,
  child: ElevatedButton(
    onPressed: () {
      // Perform action with title and description
      String title = _titleController.text;
      String description = _descriptionController.text;
      // Update property with title and description
      setState(() {
        propertyModel.title = title;
        propertyModel.description = description;
      });

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PropertyPrice(),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(255, 147, 99, 1),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    child: const Text(
      'Next',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
 const Row(
  children: [
    const SizedBox(width: 325.0,),
    Text('4/5', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0)),
  ],
),

          ],
        ),
      ),
    );
  }
}
