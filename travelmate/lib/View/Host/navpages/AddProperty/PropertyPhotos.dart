import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelmate/View/Host/navpages/AddProperty/PropDescription.dart';
import 'package:travelmate/global.dart';

class PhotoSelectionPage extends StatefulWidget {
  const PhotoSelectionPage({super.key});
  @override
  State<PhotoSelectionPage> createState() => _PhotoSelectionPageState();
}

class _PhotoSelectionPageState extends State<PhotoSelectionPage> {
  @override
  void initState() {
    super.initState();
    propertyModel.displayImages ??= [];
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final imageData = await pickedFile.readAsBytes();
      setState(() {
        propertyModel.displayImages!.add(MemoryImage(imageData));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Selection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategoryButton(
                  icon: Icons.photo_library,
                  text: 'Import',
                  fontSizee: 20,
                  width: 170,
                  height: 100,
                  onTap: () => _getImage(ImageSource.gallery),
                ),
                const SizedBox(width: 10),
                CategoryButton(
                  icon: Icons.camera_alt,
                  text: 'Take a Photo',
                  fontSizee: 20,
                  width: 170,
                  height: 100,
                  onTap: () => _getImage(ImageSource.camera),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Selected Photos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: propertyModel.displayImages!.length,
                itemBuilder: (context, index) {
                  final photo = propertyModel.displayImages![index];
                  return ListTile(
                    leading: Image(image: photo), // No null check needed
                    title: Text('Photo ${index + 1}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Color.fromRGBO(255, 147, 99, 1)),
                      onPressed: () {
                        setState(() {
                          propertyModel.displayImages!.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDescrip(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(270, 5, 5, 5),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 147, 99, 1),
                  borderRadius: BorderRadius.circular(25),
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
                SizedBox(width: 325.0),
                Text('3/5', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final double fontSizee;
  final double width;
  final double height;
  final VoidCallback onTap;

  const CategoryButton({
    this.icon,
    required this.text,
    required this.fontSizee,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 35,
                  color: const Color.fromRGBO(255, 147, 99, 1),
                ),
                const SizedBox(height: 10), // Add spacing between icon and text
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSizee,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
