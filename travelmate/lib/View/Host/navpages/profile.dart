import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/user_model.dart';
import 'package:travelmate/View/Host/cardDetails.dart';
import 'package:travelmate/View/Traveler/homescreen.dart';
import 'package:travelmate/View/Traveler/profileEdit.dart';
import 'package:travelmate/View/Auth/signin.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photo = AppConstants.currentUser.photo;
    final name = AppConstants.currentUser.name;
    String phoneNumber;
    if (AppConstants.currentUser.phoneNumber == null) {
      phoneNumber = '';
    } else {
      phoneNumber = AppConstants.currentUser.phoneNumber.toString();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 255, 146, 99),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 30),
                _buildSectionHeader('Settings'),
                _buildSettingsSection(
                  title: 'Personal Information',
                  icon: Icons.person,
                  context: context,
                  user: AppConstants.currentUser,
                ),
                _buildSettingsSection(
                  title: 'Card Details',
                  icon: Icons.credit_card,
                  context: context,
                  user: AppConstants.currentUser,
                ),
                const SizedBox(height: 20),
                _buildSectionHeader('Support'),
                _buildSupportSection(
                  title: 'How the app works',
                  icon: Icons.info,
                ),
                _buildSupportSection(
                  title: 'Give us feedback',
                  icon: Icons.feedback,
                ),
                const SizedBox(height: 20),
                _buildSectionHeader('Hosting'),
                _buildHostingSection(context),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        backgroundImage: photo,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '+216 $phoneNumber',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required BuildContext context,
    required UserModel user,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color.fromARGB(255, 255, 146, 99)),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            if (title == 'Personal Information') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEdit(),
                ),
              );
            } else if (title == 'Card Details') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreditCard(),
                ),
              );
            } else {
              // Handle other settings
            }
          },
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildSupportSection({required String title, required IconData icon}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color.fromARGB(255, 255, 146, 99)),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Handle onTap action
          },
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildHostingSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.switch_account,
              color: Color.fromARGB(255, 255, 146, 99)),
          title: const Text('Switch to traveler mode'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(userId: AppConstants.currentUser.id!)),
            );
          },
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 86, 86, 86),
        ),
      ),
    );
  }
}
