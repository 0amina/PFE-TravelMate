import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/notification_model.dart';
import 'package:travelmate/ViewModel/notification_view_model.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationViewModel = NotificationViewModel();
    final userId = AppConstants.currentUser.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: StreamBuilder<List<NotifModel>>(
        stream: notificationViewModel.getHostNotifications(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications'));
          }

          return ListView(
            children: snapshot.data!.map((notification) {
              return _buildNotification(
                notif: notification,
                title: 'New reservation',
                subtitle: notification.text!,
                icon: Icons.notifications,
                iconColor: Color.fromARGB(255, 255, 146, 99),
                context: context,
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildNotification({
    required NotifModel notif,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required BuildContext context,
  }) {
    DateTime dateTime = notif.createdAt!.toDate();
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    String formattedDate = DateFormat('d MMM yyyy').format(dateTime);
    String displayTime =
        dateTime.isBefore(DateTime.now().subtract(Duration(days: 1)))
            ? formattedDate
            : formattedTime;
    return Column(
      children: [
        Container(
          color: notif.readStatus == true
              ? Colors.transparent
              : Colors.grey.withOpacity(0.2),
          child: ListTile(
            title: Text(title),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(subtitle),
                ),
                Text(
                  displayTime,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            leading: CircleAvatar(
              child: Icon(
                icon,
                color: iconColor, // Set the icon color here
              ),
            ),
            onTap: () {
              // Show reservation details popup
              handleNotificationClick(context, notif);
            },
          ),
        ),
        const Divider(), // Add a divider below each notification
      ],
    );
  }

  void handleNotificationClick(BuildContext context, NotifModel notif) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReservationDetailsPopup(
          notif: notif,
          title: 'Reservation Details',
        );
      },
    );
  }
}

class ReservationDetailsPopup extends StatefulWidget {
  final NotifModel notif;
  final String title;

  const ReservationDetailsPopup({
    required this.notif,
    required this.title,
  });

  @override
  _ReservationDetailsPopupState createState() =>
      _ReservationDetailsPopupState();
}

class _ReservationDetailsPopupState extends State<ReservationDetailsPopup> {
  final notificationViewModel = NotificationViewModel();
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.notif.reservation!.status!;
    notificationViewModel.markNotificationAsRead(widget.notif);
    _fetchLatestReservationStatus();
  }

  Future<void> _fetchLatestReservationStatus() async {
  // Check if the property or reservation is null or if their IDs are empty
  if (widget.notif.property == null || 
      widget.notif.reservation == null) {
    setState(() {
      status = 'unknown';
    });
    return;
  }

  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('properties')
        .doc(widget.notif.property!.id)
        .collection('reservations')
        .doc(widget.notif.reservation!.id)
        .get();

    if (snapshot.exists) {
      setState(() {
        status = snapshot['status'] ?? 'unknown';
      });
    } else {
      setState(() {
        status = 'unknown';
      });
    }
  } catch (e) {
    setState(() {
      status = 'unknown';
    });
    print("Error fetching reservation status: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      backgroundColor: Colors.white,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetail(
                  'Created At',
                  DateFormat('d MMM yyyy, hh:mm:ss a')
                      .format(widget.notif.createdAt!.toDate())),
              _buildDetail(
                  'Dates', widget.notif.reservation!.dates!.join(', ')),
              _buildDetail('Property', widget.notif.property!.title!),
              _buildDetail('Number of Guests',
                  widget.notif.reservation!.nbGuests!.toString()),
              _buildDetail(
                  'Payment Method', widget.notif.reservation!.paymentMethod!),
              _buildDetail('Total Price',
                  widget.notif.reservation!.totalPrice!.toString()),
              _buildDetail('Traveler details',
                  '${widget.notif.traveler!.name} \n${widget.notif.traveler!.phoneNumber}'),
            ],
          ),
        ),
      ),
      actions: _buildActions(context, widget.notif),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, NotifModel notif) {
    List<Widget> actions = [];

    if (status == 'pending') {
      actions.addAll([
        TextButton(
          onPressed: () async {
            bool confirmed = await _showConfirmationDialog(
                context, 'Are you sure you want to accept this reservation?');
            if (confirmed) {
              await notificationViewModel.acceptReservation(notif);
              setState(() {
                status = 'accepted';
              });
              Navigator.of(context).pop();
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 255, 146, 99)),
          ),
          child: const Text(
            'Accept',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () async {
            bool confirmed = await _showConfirmationDialog(
                context, 'Are you sure you want to refuse this reservation?');
            if (confirmed) {
              await notificationViewModel.refuseReservation(notif);
              setState(() {
                status = 'refused';
              });
              Navigator.of(context).pop();
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
          ),
          child: const Text(
            'Refuse',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]);
    } else {
      actions.add(
        Center(
          child: Text(
            status == 'accepted' ? 'accepted' : 'refused',
            style: TextStyle(
              color: status == 'accepted' ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return actions;
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}