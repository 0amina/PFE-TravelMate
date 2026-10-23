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
        stream: notificationViewModel.getTravelerNotifications(userId!),
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
                title: _getNotificationTitle(notification),
                subtitle: notification.text!,
                icon: _getNotificationIcon(notification),
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

  String _getNotificationTitle(NotifModel notif) {
    if (notif.text!.contains('Your reservation for property')) {
      return 'Reservation Update';
    } else {
      return 'Notification';
    }
  }

  IconData _getNotificationIcon(NotifModel notif) {
    if (notif.text!.contains('has been refused')) {
      return Icons.cancel;
    } else if (notif.text!.contains('has been accepted')) {
      return Icons.confirmation_number_rounded;
    } else {
      return Icons.info;
    }
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

  @override
  void initState() {
    super.initState();
    notificationViewModel.markNotificationAsRead(widget.notif);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      backgroundColor: Colors.white, // Set background color to white
      content: Container(
        width: MediaQuery.of(context).size.width *
            0.8, // Set the width to 80% of the screen width
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetail(
                  'Created At',
                  DateFormat('d MMM yyyy, hh:mm:ss a')
                      .format(widget.notif.createdAt!.toDate())),
              if (!widget.notif.text!.contains('has been refused'))
                _buildDetail(
                    'Dates', widget.notif.reservation!.dates!.join(', ')),
              _buildDetail('Property', widget.notif.property!.title!),
              _buildDetail(
                  'Payment Method', widget.notif.reservation!.paymentMethod!),
              _buildDetail('Total Price',
                  widget.notif.reservation!.totalPrice!.toString()),
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
    {
      actions.add(
        TextButton(
          onPressed: () {
            // Handle OK action
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(
                    255, 255, 146, 99)), // Set OK button color to orange
          ),
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
        ),
      );
    }

    return actions;
  }
}