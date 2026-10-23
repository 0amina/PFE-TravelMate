import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/reservation_model.dart';
import 'package:travelmate/View/Host/notification.dart';
import 'package:travelmate/ViewModel/Auth/user_view_model.dart';
import 'package:travelmate/ViewModel/notification_view_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<bool> _isSelected;
  late List<ReservationModel> displayedReservations = [];
  final name = AppConstants.currentUser.name;
  final notificationViewModel = NotificationViewModel();
  final UserViewModel userVM = UserViewModel(AppConstants.currentUser);
  final userId = AppConstants.currentUser.id;

  @override
  void initState() {
    super.initState();
    _isSelected = List<bool>.generate(3, (index) => index == 0);
    userVM.categorizeReservations().then((_) {
      setState(() {
        displayedReservations = AppConstants.currentUser.checkingOut!;
      });
    });
  }

  Widget buildReservationCard(ReservationModel reservation) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 170,
                height: 140,
                child: reservation.property?.photos != null &&
                        reservation.property!.photos!.isNotEmpty
                    ? Image.network(
                        reservation.property!.photos!.first,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/h1.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reservation for:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color.fromARGB(255, 255, 146, 99),
                    ),
                  ),
                  Text(
                    reservation.property?.title ?? 'No title available',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Traveler: ${reservation.traveler?.name ?? 'No traveler available'}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Total Price: ${reservation.totalPrice ?? '0'} DT',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome, ${AppConstants.currentUser.name} !'),
        actions: [
          StreamBuilder<int>(
            stream:
                notificationViewModel.getUnreadHostNotificationsCount(userId!),
            builder: (context, snapshot) {
              int unreadCount = snapshot.data ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.bell,
                      color: Color.fromARGB(255, 255, 146, 99),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 255, 146, 99),
                ),
                SizedBox(width: 8),
                Text(
                  'Reservations',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 146, 99),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildButton('Checking Out', Icons.exit_to_app,
                      AppConstants.currentUser.checkingOut),
                  _buildButton('Currently Hosting', Icons.hotel,
                      AppConstants.currentUser.currentlyHosting),
                  _buildButton('Arriving Soon', Icons.airport_shuttle,
                      AppConstants.currentUser.arrivingSoon),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: displayedReservations.isEmpty
                ? const Center(child: Text('No reservations to retrieve'))
                : ListView.builder(
                    itemCount: displayedReservations.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final reservation = displayedReservations[index];
                      return buildReservationCard(reservation);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      String text, IconData iconData, List<ReservationModel>? reservations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectButton(text, reservations!);
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: _isSelected[_buttonIndex(text)]
              ? Colors.white
              : const Color.fromARGB(255, 255, 146, 99),
          backgroundColor: _isSelected[_buttonIndex(text)]
              ? const Color.fromARGB(255, 255, 146, 99)
              : const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: _isSelected[_buttonIndex(text)]
                  ? const Color.fromARGB(255, 255, 146, 99)
                  : Colors.orange,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData),
            const SizedBox(width: 4),
            Text(text),
          ],
        ),
      ),
    );
  }

  int _buttonIndex(String text) {
    switch (text) {
      case 'Checking Out':
        return 0;
      case 'Currently Hosting':
        return 1;
      case 'Arriving Soon':
        return 2;
      default:
        return 0;
    }
  }

  void _selectButton(String text, List<ReservationModel> reservations) {
    for (int i = 0; i < _isSelected.length; i++) {
      _isSelected[i] = text == _buttonText(i);
    }
    displayedReservations = reservations;
  }

  String _buttonText(int index) {
    switch (index) {
      case 0:
        return 'Checking Out';
      case 1:
        return 'Currently Hosting';
      case 2:
        return 'Arriving Soon';
      default:
        return '';
    }
  }
}
