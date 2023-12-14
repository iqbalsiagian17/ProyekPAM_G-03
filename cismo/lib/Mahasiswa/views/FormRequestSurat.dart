import 'package:cismo/Mahasiswa/views/requestsurat_views.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cismo/Mahasiswa/models/surat.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Mahasiswa/controllers/requestsurat_controller.dart';
import 'package:cismo/Auth/Login/views/login_views.dart';
import 'package:cismo/global.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';

class FormRequestSurat extends StatefulWidget {
  final RequestSurat? formRequestSurat;
  final String? title;

  FormRequestSurat({this.formRequestSurat, this.title});
  @override
  _FormRequestSuratState createState() => _FormRequestSuratState();
}

class _FormRequestSuratState extends State<FormRequestSurat> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _objectiveController = TextEditingController();
final TextEditingController _departureDateTimeController = TextEditingController();

  bool _loading = false;

  void _editrequestsurat(int id) async {
  DateTime returnDateTime = DateTime.parse(_departureDateTimeController.text);
    
    ApiResponse response = await updateRequestSurat(
        id, _objectiveController.text, returnDateTime);
    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RequestSuratScreen(),
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

  void _createrequestsurat() async {
    DateTime returnDateTimeController =
    DateTime.parse(_departureDateTimeController.text);
    ApiResponse response = await CreateRequestSurat(
        _objectiveController.text, returnDateTimeController);

    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RequestSuratScreen(),
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
    if (widget.formRequestSurat != null) {
      final pickuptime = widget.formRequestSurat!.pickuptime;
      final objective = widget.formRequestSurat!.reason;
      _objectiveController.text = objective ?? '';
      if (pickuptime != null) {
        _departureDateTimeController.text =
            DateFormat("yyyy-MM-dd HH:mm").format(pickuptime);
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
              // objective TextField
              TextFormField(
                controller: _objectiveController,
                decoration: InputDecoration(
                  labelText: 'objective',
                ),
              ),
              SizedBox(height: 16.0),

              // Tanggal Keluar (Departure Date) DatePicker
              TextFormField(
                controller: _departureDateTimeController,
                onTap: () => _selectDate(context, _departureDateTimeController),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Pengambilan',
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
                    if (widget.formRequestSurat == null) {
                      _createrequestsurat();
                    } else {
                      _editrequestsurat(widget.formRequestSurat!.id ?? 0);
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
