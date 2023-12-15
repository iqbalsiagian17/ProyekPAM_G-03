import 'package:cismo/Mahasiswa/views/bookingruangan_views.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cismo/Mahasiswa/models/bookingruangan.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Mahasiswa/controllers/bookingruangan_controller.dart';
import 'package:cismo/Auth/Login/views/login_views.dart';
import 'package:cismo/global.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';

class FormBookingRuangan extends StatefulWidget {
  final RuanganBooking? formBookingRuangan;
  final String? title;

  FormBookingRuangan({this.formBookingRuangan, this.title});
  
  @override
  _FormBookingRuanganState createState() => _FormBookingRuanganState();
}

class _FormBookingRuanganState extends State<FormBookingRuangan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ruanganController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  bool _loading = false;

  void _editRuanganBooking(int id) async {
  DateTime startTime = DateTime.parse(_startTimeController.text);
  DateTime endTime = DateTime.parse(_endTimeController.text);
  ApiResponse response = await updateRuanganBooking(
    id,
    _ruanganController.text,
    startTime,
    endTime);
    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => BookingRuanganScreen(),
        ),
      );
    } else if (response.error == unauthrorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            )
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }

String unauthorized = 'Unauthorized access. Please login again.';

  void _createRuanganBooking() async {
  DateTime startTime = DateTime.parse(_startTimeController.text);
  DateTime endTime = DateTime.parse(_endTimeController.text);
  
  ApiResponse response = await CreateRuanganBooking(
    _ruanganController.text,
    startTime,
    endTime,
  );

  if (response.error == null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => BookingRuanganScreen(),
      ),
    );
  } else if (response.error == unauthorized) {
    logout().then((value) => {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      )
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${response.error}'),
    ));
    setState(() {
      _loading = !_loading;
    });
  }
}




  @override
  void initState() {
    if (widget.formBookingRuangan != null) {
      final startTime = widget.formBookingRuangan!.startTime;
      final endTime = widget.formBookingRuangan!.endTime;
      final ruangan = widget.formBookingRuangan!.ruangan;
      _ruanganController.text = ruangan;
      _startTimeController.text =DateFormat("yyyy-MM-dd HH:mm").format(startTime as DateTime);
      _endTimeController.text = DateFormat("yyyy-MM-dd HH:mm").format(endTime as DateTime);
        }

    super.initState();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != controller) {
      _selectTime(context, controller, picked);
    }
  }

  Future<void> _selectTime(BuildContext context,
      TextEditingController controller, DateTime pickedDate) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final DateTime combinedDateTime = DateTime(pickedDate.year,
          pickedDate.month, pickedDate.day, picked.hour, picked.minute);
      final formattedDateTime =
          DateFormat("yyyy-MM-dd HH:mm").format(combinedDateTime);
      controller.text = formattedDateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Reason TextField
              
TextFormField(
                controller: _ruanganController,
                decoration: InputDecoration(
                  labelText: 'Ruangan',
                ),
              ),
              SizedBox(height: 16.0),
              // Start Date DatePicker
              TextFormField(
                controller: _startTimeController,
                onTap: () =>
                    _selectDate(context, _startTimeController),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                ),
              ),
              SizedBox(height: 16.0),

              // End Date DatePicker
              TextFormField(
                controller: _endTimeController,
                onTap: () =>
                    _selectDate(context, _endTimeController),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'End Date',
                ),
              ),
              SizedBox(height: 16.0),

              // Submit Button
              ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = !_loading;
      });
      if (widget.formBookingRuangan == null) {
        _createRuanganBooking();
      } else {
        _editRuanganBooking(widget.formBookingRuangan!.id);
      }
    }
  },
  child: Text('Submit'),
),
SizedBox(height: 16.0), // Adding space between buttons
// Refresh Button
 SizedBox(height: 8), // Spacer antara Submit Button dan Refresh Text

            // Refresh Text
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => BookingRuanganScreen(),
                    ),
                  );
                },
                child: Text(
                  'Refresh',
                  style: TextStyle(
                    color: Colors.blue, // Warna teks
                    decoration: TextDecoration.underline, // Garis bawah
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}}