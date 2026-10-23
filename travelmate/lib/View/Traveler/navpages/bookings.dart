import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/Model/reservation_model.dart';
import 'package:travelmate/ViewModel/reservation_view_model.dart';
import 'package:travelmate/global.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  bool _showPastBookings = false;

  @override
  void initState() {
    super.initState();
    AppConstants.currentUser.pastBookings;
    AppConstants.currentUser.upcomingBookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showPastBookings = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: !_showPastBookings
                        ? const Color.fromARGB(255, 255, 146, 99)
                        : Colors.grey, // Sets the text color to white
                  ),
                  child: const Text(
                    'Upcoming Bookings',
                    style: TextStyle(
                        color: Colors.white), // Ensures text color is white
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showPastBookings = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _showPastBookings
                        ? const Color.fromARGB(255, 255, 146, 99)
                        : Colors.grey, // Sets the text color to white
                  ),
                  child: const Text(
                    'Past Bookings',
                    style: TextStyle(
                        color: Colors.white), // Ensures text color is white
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 20), // Space between buttons and list of cards
            Expanded(
              child: ListView.builder(
                itemCount: _showPastBookings
                    ? AppConstants.currentUser.pastBookings!.length
                    : AppConstants.currentUser.upcomingBookings!.length,
                itemBuilder: (context, index) {
                  final booking = _showPastBookings
                      ? AppConstants.currentUser.pastBookings![index]
                      : AppConstants.currentUser.upcomingBookings![index];
                  final property = booking.property;

                  return Column(
                    children: [
                      _buildBookingCard(
                        photos: property!.photos ?? [],
                        propertyinfo: {
                          'city': '${property.title}',
                          'country': '${property.state}',
                          'type': '${property.category}',
                          'price': '${property.price}',
                        },
                        showReviewButton: _showPastBookings,
                        showDeleteButton: !_showPastBookings,
                        property: property,
                        onDelete: () {
                          _showCancelDialog(context, booking);
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard({
    required List<String> photos,
    required Map<String, String> propertyinfo,
    required bool showReviewButton,
    required bool showDeleteButton,
    required PropertyModel property,
    required VoidCallback onDelete,
  }) {
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
                child: Image.network(
                  photos.isNotEmpty ? photos[0] : '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    propertyinfo['city'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    propertyinfo['country'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${propertyinfo['type'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${propertyinfo['price'] ?? 0.0} DT',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (showReviewButton)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.pencil,
                              color: Color.fromARGB(255, 255, 146, 99),
                            ),
                            onPressed: () {
                              _showReviewDialog(context, property);
                            },
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Add Review',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 255, 146, 99),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (showDeleteButton)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(
                          CupertinoIcons.delete,
                          color: Colors.red,
                        ),
                        onPressed: onDelete,
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

  void _showReviewDialog(BuildContext context, PropertyModel property) {
    final TextEditingController _reviewController = TextEditingController();
    double _rating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Review for ${property.title}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                          ),
                          color: const Color.fromARGB(255, 255, 146, 99),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                              reviewModel.rating = _rating;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _reviewController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Write your review here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            reviewModel.text = _reviewController.text;

                            await propertyViewModel.addReview(context);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 146, 99),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Send Review'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, ReservationModel booking) {
    ReservationViewModel reservationVM = ReservationViewModel(booking);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text('Are you sure you want to cancel this booking?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Show a loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                bool success = await reservationVM.cancelReservation();
                Navigator.of(context).pop(); // Dismiss the loading indicator
                Navigator.of(context).pop(); // Dismiss the confirmation dialog

                if (success) {
                  setState(() {
                    // Remove the cancelled booking from the list
                    AppConstants.currentUser.upcomingBookings!.remove(booking);
                  });
                } else {
                  // Show an error message if cancellation fails
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'Failed to cancel the booking. Please try again later.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
