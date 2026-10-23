import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/Model/review_model.dart';
import 'package:travelmate/View/Traveler/conversation_page.dart';
import 'package:travelmate/global.dart';
import 'package:travelmate/View/Traveler/reservation.dart';
import 'package:travelmate/view/theme/theme.dart';
import 'package:travelmate/view/Widgets/review_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/ViewModel/chat_view_model.dart';

class PropertyDetails extends StatefulWidget {
  final PropertyModel property;

  const PropertyDetails({Key? key, required this.property}) : super(key: key);

  @override
  _PropertyDetailsState createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    widget.property.reviews;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> photos = List<String>.from(widget.property.photos ?? []);
    final String title = widget.property.title ?? 'No Title';
    final String description = widget.property.description ?? 'No Description';
    final List<String> amenities =
        List<String>.from(widget.property.amenities ?? []);
    final int bedrooms = widget.property.bedrooms ?? 0;
    final int beds = widget.property.beds ?? 0;
    final int rooms = widget.property.bathrooms ?? 0;
    final String city = widget.property.city ?? 'No City';
    final String state = widget.property.state ?? 'No Country';
    final double rating = widget.property.rating ?? 0.0;
    final double price =
        double.tryParse(widget.property.price.toString()) ?? 0.0;
    propertyModel = widget.property;
    final List<ReviewModel>? reviews = propertyModel.reviews;
    final Map<String, IconData> amenityIcons = {
      'Wifi': Icons.wifi,
      'AirConditioner': Icons.ac_unit,
      'TV': Icons.whatshot,
      'Beach area': Icons.add,
      'Washer': Icons.wash_sharp,
      'Ski': Icons.skip_next,
      'Pool': Icons.pool,
      'Kitchen': Icons.kitchen,
      'Paid Parking': Icons.local_parking,
      'Free Parking': Icons.car_crash,
      'Fire ectinguisher': Icons.fire_extinguisher,
      'Gym': Icons.sports_gymnastics,
    };

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3.0,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            photos[index],
                            fit: BoxFit.cover,
                          );
                        },
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 16.0,
                        left: 16.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child:
                              const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        bottom: 16.0,
                        left: 0,
                        right: 0,
                        child: _buildSliderIndicator(photos.length),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        '$city, $state',
                        style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 88, 88, 88)),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        '$beds beds, $bedrooms bedrooms, $rooms rooms',
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 88, 88, 88)),
                      ),
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                if (index < rating.floor()) {
                                  return const Icon(Icons.star, color: Colors.yellow);
                                } else if (index < rating) {
                                  return const Icon(Icons.star_half, color: Colors.yellow);
                                } else {
                                  return const Icon(Icons.star_border, color: Colors.yellow);
                                }
                              }),
                            ),
                            Text(
                              '   ${rating.toStringAsFixed(1)} \nReviews',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 5.0),
                      _buildHostInfo(),
                      const SizedBox(height: 5.0),
                      const Text(
                        'About the place',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 88, 88, 88),fontSize: 16),
                      ),
                      const SizedBox(height: 5.0),
                      const Divider(),
                      const SizedBox(height: 5.0),
                      const Text(
                        'What this place offers',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: amenities.map((amenity) {
                          IconData? icon = amenityIcons[amenity];
                          return Row(
                            children: [
                              if (icon != null) Icon(icon, size: 20.0, color: Colors.black54),
                              const SizedBox(width: 5.0),
                              Text(
                                amenity,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 88, 88, 88),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 5.0),
                      const Divider(),
                      const SizedBox(height: 5.0),
                      const Text(
                        'Reviews',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      reviews != null && reviews.isNotEmpty
                        ? SizedBox(
                            height: 160,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(reviews.length, (index) {
                                  return ReviewCard(review: reviews[index]);
                                }),
                              ),
                            ),
                          )
                        : const Center(
                            child: Text('No reviews yet'),
                          ),
                      const SizedBox(height: 130.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: MyTheme.lightColorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${price.toStringAsFixed(2)} DT night',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 120.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReservationPage(property: widget.property),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 255, 146, 99),
                            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0), // Smaller border radius
                            ),
                          ),
                          child: const Text('Reserve'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostInfo() {
    String name = widget.property.host?.name ?? 'Mr renter';
    String phone = widget.property.host?.phoneNumber?.toString() ?? '000000';
    final photo = widget.property.host?.photo;

    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: photo,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Text(
                  '+216 $phone',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 88, 88, 88), fontSize: 14.0),
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
  onPressed: () async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? hostId = widget.property.host?.id;
    if (currentUser != null && hostId != null) {
      final viewModel = Provider.of<ChatViewModel>(context, listen: false);
      final conversationId = await viewModel.createOrGetConversation(
        currentUser.uid,
        hostId,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationPage(
            userName: 'Host',
            receiverId: hostId,
            senderId: currentUser.uid,
            conversationId: conversationId,
          ),
        ),
      );
    }
  },
  icon: const Icon(CupertinoIcons.bubble_left_bubble_right_fill, color: Color.fromARGB(255, 255, 146, 99), size: 30),
),

                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        const SizedBox(height: 5),
        const Divider(),
      ],
    );
  }

  Widget _buildSliderIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? const Color.fromARGB(255, 255, 255, 255)
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
