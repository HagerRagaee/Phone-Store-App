import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:phone_store/Classes/sales_class.dart';
import 'package:phone_store/Classes/service_class.dart';
import 'package:phone_store/Data/data_sales_layer.dart';
import 'package:phone_store/Data/data_service_layer.dart';
import 'package:phone_store/structure/sales_card.dart';
import 'package:phone_store/structure/sales_excel_builder.dart';

class ShowTodaysSales extends StatefulWidget {
  const ShowTodaysSales({super.key});

  @override
  State<ShowTodaysSales> createState() => _ShowTodaysSalesState();
}

class _ShowTodaysSalesState extends State<ShowTodaysSales> {
  List<SaleRecord> _items = [];
  List<ServiceRecord> _services = [];

  List<DateTime?> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    fetchTodaySales();
    fetchTodayService(); // Fetch today's sales on init
  }

  Future<void> fetchTodaySales() async {
    try {
      final items = await FirebaseOperations.getTodaySales();
      setState(() {
        _items = items;
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  Future<void> fetchTodayService() async {
    try {
      final services = await DataServiceLayer.getTodayServices();
      setState(() {
        _services = services;
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  Future<void> fetchSalesForDates(List<DateTime?> dates) async {
    try {
      final items = await FirebaseOperations.getSalesByDate(dates);
      setState(() {
        _items = items;
      });
    } catch (e) {
      print('Error fetching sales for selected dates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (_items.isNotEmpty || _services.isNotEmpty) {
                SalesToExcel.createExcelFile(_items, _services);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No data to export!')),
                );
              }
            },
            icon: Icon(
              Icons.open_in_browser,
              color: Colors.white,
            ),
          ),
        ],
        title: Center(
          child: Text(
            'Daily Sales Report',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 182, 250),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              "Selected Dates: ${_selectedDates.isEmpty ? '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}' : _selectedDates.map((date) => date!.toLocal().toString().split(' ')[0]).join(', ')}",
              style: TextStyle(fontSize: 19),
            ),
            trailing: IconButton(
              onPressed: () async {
                var results = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(),
                  dialogSize: const Size(325, 400),
                  value: _selectedDates,
                  borderRadius: BorderRadius.circular(15),
                );
                if (results != null && results.isNotEmpty) {
                  setState(() {
                    _selectedDates = results; // Update selected dates
                  });
                  await fetchSalesForDates(_selectedDates);
                }
              },
              icon: Icon(Icons.date_range),
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Text("No sales records found."),
                  )
                : ListView(
                    children: [
                      SalesCard(items: _items),
                      SizedBox(height: 60),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
