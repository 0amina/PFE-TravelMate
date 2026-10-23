import 'package:flutter/material.dart';
import 'package:travelmate/Model/review_model.dart';

class ReviewCard extends StatefulWidget {
  final ReviewModel review;

  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool isExpanded = false;

  // Determine the star icons based on the rating
  List<Widget> _buildStarIcons(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        stars.add(const Icon(Icons.star, color: Color.fromARGB(255, 255, 146, 99)));
      } else if (i - rating < 1) {
        stars.add(const Icon(Icons.star_half, color: Color.fromARGB(255, 255, 146, 99)));
      } else {
        stars.add(const Icon(Icons.star_border, color: Color.fromARGB(255, 255, 146, 99)));
      }
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: Colors.white, // Ensuring the background color is set to white
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: _buildStarIcons(widget.review.rating ?? 0),
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isExpanded
                        ? widget.review.text ?? 'No review text'
                        : (widget.review.text != null && widget.review.text!.length > 100)
                            ? '${widget.review.text!.substring(0, 100)}...'
                            : widget.review.text ?? 'No review text',
                  ),
                  if (widget.review.text != null && widget.review.text!.length > 100)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? 'See less' : 'See more',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Divider(), // Optional: add a divider between the text and user info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    backgroundImage: widget.review.traveler!.photo, // MemoryImage
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.review.traveler!.name ?? 'Unknown User',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
