import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/places.dart';
import 'package:travelmate/global.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  File? _image;

  String? selectedState = AppConstants.currentUser.state;
  String? selectedCity = AppConstants.currentUser.city;
  List<String> _states = [];
  List<String> _cities = [];

  final Places places = Places();

  @override
  void initState() {
    super.initState();
    selectedState;
    selectedCity;
    _loadStates();
    nameController.text = AppConstants.currentUser.name ?? '';
    emailController.text = AppConstants.currentUser.email ?? '';
    birthdayController.text = AppConstants.currentUser.birthday ?? '';
    phoneNumberController.text =
        AppConstants.currentUser.phoneNumber.toString();
    if (_image == null && AppConstants.currentUser.photo != null) {
      _image = _convertMemoryImageToFile(AppConstants.currentUser.photo);
    }
  }

  Future<void> _loadStates() async {
    try {
      List<String> states = await places.fetchTunisiaStates();
      states = states.toSet().toList(); // Remove duplicates
      states.sort(); // Sort alphabetically
      setState(() {
        _states = states;
      });
      if (selectedState != null && selectedState!.isNotEmpty) {
        await _fetchCitiesForState(selectedState!);
      }
    } catch (e) {
      print('Failed to load Tunisia states: $e');
    }
  }

  Future<void> _fetchCitiesForState(String state) async {
    try {
      List<String> cities = await places.fetchTunisiaCities(state);
      cities = cities.toSet().toList(); // Remove duplicates
      cities.sort(); // Sort alphabetically
      setState(() {
        _cities = cities;
      });
    } catch (e) {
      print('Failed to load cities for state $state: $e');
    }
  }

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  File _convertMemoryImageToFile(MemoryImage? memoryImage) {
    if (memoryImage == null) {
      throw ArgumentError('MemoryImage cannot be null');
    }
    // Convert MemoryImage to File
    final byteData = memoryImage.bytes;
    final buffer = byteData.buffer;
    final filePath = '${Directory.systemTemp.path}/temp_image.png';
    final file = File(filePath);
    file.writeAsBytesSync(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(r'^\d{8}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor:
            const Color.fromARGB(255, 255, 146, 99), // AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : AppConstants.currentUser.photo
                                as ImageProvider<Object>?,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: getImage,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 146, 99),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Change Photo',
                          style: TextStyle(
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 70),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    hintText: 'Enter your name',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      filled: true,
                      fillColor: Colors.white),
                  value: selectedState != '' ? selectedState : null,
                  items: _states.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedState = newValue;
                      selectedCity = null;
                      _cities = [];
                      _fetchCitiesForState(newValue!);
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      filled: true,
                      fillColor: Colors.white),
                  value: selectedCity != '' ? selectedCity : null,
                  items: _cities.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCity = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    hintText: 'Enter your phone number',
                  ),
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now()
                          .subtract(const Duration(days: 365 * 18)),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now()
                          .subtract(const Duration(days: 365 * 18)),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(
                                  0xFF8AB4F8), // Set your desired color here
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      setState(() {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        birthdayController.text = formattedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: birthdayController,
                      decoration: InputDecoration(
                        labelText: 'Birthday',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        hintText: 'Select your birthday',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                Center(
                  child: ElevatedButton(
                    onPressed: showUpdateConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 146, 99),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showUpdateConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to update your profile?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                userViewModel.updateUserData(
                    nameController,
                    selectedState,
                    selectedCity,
                    phoneNumberController,
                    birthdayController,
                    _image,
                    emailController,
                    context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
