import 'package:flutter/material.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/View/Traveler/navpages/propetyDetails.dart';
import 'package:travelmate/global.dart';

class PropertyCard extends StatefulWidget {
  final PropertyModel property;

  const PropertyCard({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkIfFavorite();
  }

  void _checkIfFavorite() {
    setState(() {
      _isFavorite = AppConstants.currentUser.favProperties!
          .any((property) => property.id == widget.property.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> photosUrl = widget.property.photos ?? [];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetails(property: widget.property),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: photosUrl.length,
                      itemBuilder: (BuildContext context, int index) {
                        final imageUrl = photosUrl[index];
                        return Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        );
                      },
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      photosUrl.length,
                      (int index) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.property.category ?? ''} in ${widget.property.state ?? ''}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        widget.property.title ?? '',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 71, 71, 71),
                          fontSize: 16,
                          
                        ),
                      ),
                      SizedBox(height: 3,),
                      Text(
                        '${widget.property.price ?? ''} DT night',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 71, 71, 71),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : null,
                      size: 32.0,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      userViewModel.addFavouriteProperty(widget.property, _isFavorite);
    } else {
      userViewModel.removeFavouriteProperty(widget.property, _isFavorite);
    }
    _checkIfFavorite();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}