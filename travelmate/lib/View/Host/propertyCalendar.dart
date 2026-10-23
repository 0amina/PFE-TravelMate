import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/ViewModel/property_view_model.dart';

class CalendarPage extends StatefulWidget {
  final PropertyModel property;

  const CalendarPage({super.key, required this.property});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late List<DateTime> bookedDates = [];
  PropertyModel propertyM = PropertyModel();

  @override
  void initState() {
    super.initState();
    propertyM = widget.property;
    fetchBookedDates();
  }

  void fetchBookedDates() async {
    final PropertyViewModel propertyVM = PropertyViewModel(propertyM);
    await propertyVM.getAllBookingsFromFirestore();
    setState(() {
      bookedDates = propertyM.getAllBookedDates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserved Dates for ${widget.property.title}'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SfDateRangePicker(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          selectionColor: const Color.fromARGB(255, 255, 146, 99),
          todayHighlightColor: const Color.fromARGB(255, 255, 146, 99),
          selectionMode: DateRangePickerSelectionMode.single,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            print('Selected range: ${args.value}');
          },
          monthCellStyle: const DateRangePickerMonthCellStyle(
            textStyle: TextStyle(
              fontSize: 20, // Larger text size for the dates
            ),
            blackoutDateTextStyle: TextStyle(
              color: Color.fromARGB(
                  255, 169, 158, 141), // Customize blackout dates appearance
              decoration: TextDecoration.lineThrough,
              fontSize: 20,
            ),
          ),
          monthViewSettings: DateRangePickerMonthViewSettings(
            blackoutDates: bookedDates,
          ),
        ),
      ),
    );
  }
}
