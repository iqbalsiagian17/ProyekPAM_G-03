import 'package:cismo/Mahasiswa/views/izinbermalam_views.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cismo/Mahasiswa/models/izinbermalam.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Mahasiswa/controllers/izinbermalam_controller.dart';
import 'package:cismo/Auth/Login/views/login_views.dart';

import 'package:cismo/global.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';

class FormIzinBermalam extends StatefulWidget {
  final RequestIzinBermalam? formIzinBermalam;
  final String? title;

  FormIzinBermalam({this.formIzinBermalam, this.title});
  
  @override
  _FormIzinBermalamState createState() => _FormIzinBermalamState();
}

class _FormIzinBermalamState extends State<FormIzinBermalam> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  bool _loading = false;

  void _editIzinBermalam(int id) async {
    DateTime startDate = DateTime.parse(_startDateController.text);
    DateTime endDate = DateTime.parse(_endDateController.text);
    ApiResponse response = await updateIzinBermalam(
        id, _reasonController.text, startDate, endDate);
    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RequestIzinBermalamScreen(),
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

  void _createIzinBermalam() async {
    DateTime startDate = DateTime.parse(_startDateController.text);
    DateTime endDate = DateTime.parse(_endDateController.text);

    ApiResponse response =
        await CreateIzinBermalam(_reasonController.text, startDate, endDate);

    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RequestIzinBermalamScreen(),
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

  @override
  void initState() {
    if (widget.formIzinBermalam != null) {
      final startDate = widget.formIzinBermalam!.startDate;
      final endDate = widget.formIzinBermalam!.endDate;
      final reason = widget.formIzinBermalam!.reason;
      _reasonController.text = reason ?? '';
      if (startDate != null) {
        _startDateController.text =
            DateFormat("yyyy-MM-dd HH:mm").format(startDate);
      }
      if (endDate != null) {
        _endDateController.text = DateFormat("yyyy-MM-dd HH:mm").format(endDate);
      }
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
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Alasan',
                ),
              ),
              SizedBox(height: 16.0),

              // Start Date DatePicker
              TextFormField(
                controller: _startDateController,
                onTap: () =>
                    _selectDate(context, _startDateController),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Berangkat',
                ),
              ),
              SizedBox(height: 16.0),

              // End Date DatePicker
              TextFormField(
                controller: _endDateController,
                onTap: () =>
                    _selectDate(context, _endDateController),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Kembali',
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
                    if (widget.formIzinBermalam == null) {
                      _createIzinBermalam();
                    } else {
                      _editIzinBermalam(widget.formIzinBermalam!.id ?? 0);
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
