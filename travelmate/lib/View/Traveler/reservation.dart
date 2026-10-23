import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/ViewModel/property_view_model.dart';
import 'package:travelmate/global.dart';
import 'package:travelmate/payment_service.dart';

class ReservationPage extends StatefulWidget {
  final PropertyModel property;

  const ReservationPage({Key? key, required this.property}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late DateTime? fromDate = null;
  late DateTime? toDate = null;
  late List<DateTime> dates = [];
  late int numberGuests = 1;
  late String paymentMethod = '';
  late bool _acceptTerms = false;
  late double? totalPrice;
  Timestamp createdAt = Timestamp.now();
  final user = AppConstants.currentUser;
  late List<DateTime> bookedDates = [];
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fromDate;
    toDate;
    numberGuests = 1;
    propertyModel = widget.property;
    bookedDates;
    fetchBookedDates();
  }

  final PropertyViewModel propertyVM = PropertyViewModel(propertyModel);
  void fetchBookedDates() async {
    await propertyVM.getAllBookingsFromFirestore();
    setState(() {
      bookedDates = propertyModel.getAllBookedDates();
    });
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    DateTime? newFromDate;
    DateTime? newToDate;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color to white
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors
                        .white, // Ensure the Expanded child has a white background
                    child: SfDateRangePicker(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      selectionColor: const Color.fromARGB(255, 255, 146, 99),
                      startRangeSelectionColor:
                          const Color.fromARGB(255, 255, 146, 99),
                      endRangeSelectionColor:
                          const Color.fromARGB(255, 255, 146, 99),
                      todayHighlightColor: const Color.fromARGB(
                          255, 255, 146, 99), // Change the selection color
                      rangeSelectionColor: const Color.fromARGB(255, 255, 179,
                          128), // Set the background color to white
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is PickerDateRange) {
                          newFromDate = args.value.startDate;
                          newToDate = args.value.endDate;
                        }
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(
                        fromDate,
                        toDate,
                      ),
                      enablePastDates: false,
                      monthCellStyle: const DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(
                          fontSize: 20, // Larger text size for the dates
                        ),
                        blackoutDateTextStyle: TextStyle(
                          color: Color.fromARGB(255, 169, 158,
                              141), // Customize blackout dates appearance
                          decoration: TextDecoration.lineThrough,
                          fontSize: 20,
                        ),
                      ),
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        blackoutDates: bookedDates,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color.fromARGB(
                            255, 255, 146, 99), // Set the text color to orange
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 255, 255,
                                255)), // Larger text size for the button
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (newFromDate != null && newToDate != null) {
                          setState(() {
                            fromDate = newFromDate;
                            toDate = newToDate;
                            dates = [];
                            DateTime currentDate = fromDate!;
                            while (currentDate.isBefore(toDate!) ||
                                currentDate.isAtSameMomentAs(toDate!)) {
                              dates.add(currentDate);
                              currentDate =
                                  currentDate.add(const Duration(days: 1));
                            }
                          });
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color.fromARGB(
                            255, 255, 146, 99), // Set the text color to orange
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 255, 255,
                                255)), // Larger text size for the button
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmReservation() async {
    if (propertyModel.id != null) {
      reservationModel.property = propertyModel;
      reservationModel.traveler = user;
      reservationModel.dates = dates;
      reservationModel.createdAt = createdAt;
      reservationModel.nbGuests = numberGuests;
      reservationModel.totalPrice = bookingPrice;
      reservationModel.paymentMethod = paymentMethod;

      if (paymentMethod == 'card') {
        bool paymentSuccess = await PaymentService.simulatePayment(
          cardNumberController.text,
          expiryDateController.text,
          cvvController.text,
          bookingPrice!,
        );

        if (!paymentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment failed. Please try again.'),
            ),
          );
          return;
        }
      }

      propertyViewModel.makeNewBooking(dates, context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservation added successfully!'),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Reservation',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color.fromARGB(255, 255, 146, 99)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Divider(),
                Text(
                  'Property: ${propertyModel.title}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Dates: ${fromDate?.toLocal().toString().split(' ')[0]} - ${toDate?.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 57, 55, 55)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Guests: $numberGuests',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 57, 55, 55)),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Total Price: $bookingPrice DT',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 57, 55, 55)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Payment Method: ${paymentMethod == 'card' ? 'Card' : 'Pay when meeting'}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 57, 55, 55)),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 255, 146, 99)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Reserve and Pay',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 255, 146, 99)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _confirmReservation();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> photos = (propertyModel.photos as List).cast<String>();
    int numberOfNights = dates.isNotEmpty ? dates.length : 0;
    totalPrice = numberOfNights * ((propertyModel.price ?? 0.0).toDouble());
    bookingPrice = totalPrice;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
                          Text(
                            propertyModel.title ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            propertyModel.state ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            propertyModel.category ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${propertyModel.price ?? ''} DT',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Renting',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Dates:\n${fromDate != null && toDate != null ? ' ${fromDate!.toString().split(' ')[0]} - ${toDate!.toString().split(' ')[0]}' : 'From - To'}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _showDateRangePicker(context);
                      },
                      // Call the function here
                      child: Text(
                        fromDate != null && toDate != null ? 'Edit' : 'Add',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 146, 99)),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Guests:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 255, 146, 99),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove),
                          color: Colors.white,
                          iconSize: 18,
                          onPressed: () {
                            setState(() {
                              if (numberGuests > 1) {
                                numberGuests--;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '$numberGuests',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 255, 146, 99),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                          iconSize: 18,
                          onPressed: () {
                            setState(() {
                              if (numberGuests < 10) {
                                numberGuests++;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Price',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total(DT) \n \$${propertyModel.price ?? 0} x $numberOfNights nights',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0), // Adjust the value as needed
                          child: Text(
                            '$bookingPrice DT',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: const Text('Pay when meeting'),
                      leading: Radio(
                        value: 'person',
                        groupValue: paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value.toString();
                          });
                        },
                        activeColor: const Color.fromARGB(255, 255, 146, 99),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: const Text('Pay By Card'),
                      leading: Radio(
                        value: 'card',
                        groupValue: paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value.toString();
                          });
                        },
                        activeColor: const Color.fromARGB(255, 255, 146, 99),
                      ),
                    ),
                    Visibility(
                      visible: paymentMethod == 'card',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Card Payment Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: cardNumberController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Card Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: expiryDateController,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              labelText: 'Expiry Date (MM/YY)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: cvvController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rules',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        const Text(
                            '   Follow the house rules. \n   Treat your host’s home like yours. \n    Pay full on time.',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value!;
                                });
                              },
                            ),
                            const Text(
                              'Read and accept.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 146, 99),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            _showConfirmationDialog(context);
                          },
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
