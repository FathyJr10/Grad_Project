import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile_app/api/doctor.dart';
import 'package:mobile_app/colors.dart';
// ignore: unused_import
import 'package:mobile_app/pages/welcome_page.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../api/user.dart';
import '../configure.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class Bookappoint extends StatefulWidget {
  const Bookappoint({super.key});

  @override
  State<Bookappoint> createState() => _BookappointState();
}

class _BookappointState extends State<Bookappoint> {
  Future<void> createAppointment(
      String appointmentDate, List appointmentType, int userId) async {
    final Uri apiUrl = Uri.parse(
        '${AppUrl.Base_Url}/appointment/$userId/${selectedfacility?.doctorId}');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final Map<String, dynamic> data = {
      'appointment_date': appointmentDate,
      'appointment_type': appointmentType,
      'appointment_status': "on going",
      'patient_id': userId,
      'entity_id': selectedfacility?.doctorId
    };

    final String body = json.encode(data);

    final http.Response response =
        await http.post(apiUrl, headers: headers, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to create appointment.');
    } else {
      print(body);
    }
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  late List<Doctor> facilities = [];
  bool isDropdownEnabled = false;
  List<dynamic> selectedAppointmentTypes = [];

  Doctor? selectedfacility;
  @override
  void initState() {
    super.initState();
    fetchDoctors().then((data) {
      setState(() {
        facilities = data;
      });
    });
  }

  TextEditingController textFieldController = TextEditingController();

  void submitButton() {
    if (_formKey.currentState!.validate()) {
      int userId = Provider.of<UserIdProvider>(context, listen: false).id!;
      //print(selectedfacility?.doctorId);
      //createAppointment(dateinput.text, selectedAppointmentTypes, userId);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //position
              mainAxisSize: MainAxisSize.min,
              // wrap content in flutter
              children: <Widget>[
                Text('your booking details'),
                SizedBox(
                  height: 5,
                ),
                Text('Type :$selectedAppointmentTypes'),
                Text('Facility :${selectedfacility?.name}'),
                Text('Date :${dateinput.text}'),

                //Text('Data :$  )
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      'home',
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text('Ok'),
                )
                //Text('Date :${dateinput.text}'),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Book now'),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Theme(
            data: ThemeData(primarySwatch: primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: SizedBox(
                    width: double.infinity,
                    child: DropdownButtonFormField<Doctor>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.local_hospital_outlined),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.greenAccent),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        labelText: 'Healthcare facility',
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items: facilities
                          .map<DropdownMenuItem<Doctor>>((Doctor doctor) {
                        return DropdownMenuItem<Doctor>(
                          value: doctor,
                          child: Text(doctor.name),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a facility';
                        }
                      },
                      value: selectedfacility,
                      onChanged: (newValue) {
                        setState(() {
                          selectedfacility = newValue!;
                          isDropdownEnabled = true;
                          selectedAppointmentTypes.clear();
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            Colors.greenAccent, // Set the desired border color
                        width: 2.5, // Set the desired border width
                      ),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: MultiSelectFormField(
                      border: InputBorder.none,
                      chipBackGroundColor: primary,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                      checkBoxActiveColor: Colors.greenAccent,
                      checkBoxCheckColor: Colors.white,
                      dialogShapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      title: Row(
                        children: const [
                          Icon(
                            Icons.edit_document,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 8),
                          Text('Select appointment Type'),
                        ],
                      ),
                      dataSource: (selectedfacility != null &&
                              selectedfacility?.type == 'clinic')
                          ? [
                              {
                                'display': 'General Check-up',
                              },
                              {
                                'display': 'Specialist Consultation',
                              },
                              {
                                'display': 'Follow-up Appointment',
                              },
                              {
                                'display': 'Diagnostic Test Appointment',
                              },
                              {
                                'display': 'Vaccination Appointment',
                              },
                              {
                                'display': 'Therapy or Counseling Session',
                              },
                              {
                                'display': 'Surgical Procedure',
                              },
                              {
                                'display': 'Maternity or Prenatal Appointment',
                              },
                              {
                                'display': 'Dental or Oral Health Appointment',
                              },
                              {
                                'display': 'Physical Therapy Appointment',
                              },
                            ]
                          : (selectedfacility != null &&
                                  selectedfacility?.type == 'lab')
                              ? [
                                  {
                                    'display': 'CBC Test',
                                  },
                                  {
                                    'display': 'Glucose Test',
                                  },
                                  {
                                    'display': 'Urine Test',
                                  },
                                  {
                                    'display': 'Lipid profile Test',
                                  },
                                  {
                                    'display': 'Liver function Test',
                                  },
                                ]
                              : (selectedfacility != null &&
                                      selectedfacility?.type == 'rad')
                                  ? [
                                      {
                                        'display': 'MRI of the brain',
                                      },
                                      {
                                        'display': 'CT scan of the head',
                                      },
                                      {
                                        'display': 'PET scan of the brain',
                                      },
                                      {
                                        'display': 'Ultrasound of the head',
                                      },
                                      {
                                        'display': 'X-ray of the spine',
                                      },
                                      {
                                        'display': 'MRI of the spine',
                                      },
                                      {
                                        'display': 'CT scan of the spine',
                                      },
                                      {
                                        'display': 'Chest X-ray',
                                      },
                                      {
                                        'display': 'CT scan of the chest',
                                      },
                                      {
                                        'display': 'PET-CT scan of the chest',
                                      },
                                      {
                                        'display': 'Pulmonary function tests',
                                      },
                                      {
                                        'display': 'Abdominal ultrasound',
                                      },
                                      {
                                        'display':
                                            'CT scan of the abdomen and pelvis',
                                      },
                                      {
                                        'display':
                                            'MRI of the abdomen and pelvis',
                                      },
                                      {
                                        'display': 'X-ray of the abdomen',
                                      },
                                      {
                                        'display': 'X-ray of bones and joints',
                                      },
                                      {
                                        'display':
                                            'MRI of joints and soft tissues',
                                      },
                                      {
                                        'display':
                                            'CT scan of bones and joints',
                                      },
                                      {
                                        'display':
                                            'Ultrasound of joints and soft tissues',
                                      },
                                      {
                                        'display': 'Echocardiogram',
                                      },
                                      {
                                        'display': 'Cardiac CT scan',
                                      },
                                      {
                                        'display': 'Cardiac MRI',
                                      },
                                      {
                                        'display': 'Angiography',
                                      },
                                    ]
                                  : [],
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return 'Please select one or more options';
                        }
                        return null;
                      },
                      enabled: isDropdownEnabled,
                      textField: 'display',
                      valueField: 'display',
                      okButtonLabel: 'OK',
                      cancelButtonLabel: 'CANCEL',
                      hintWidget: Text('Please select one or more option'),
                      onSaved: (value) {
                        setState(() {
                          selectedAppointmentTypes = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.003,
                ),
                dateBox(context),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.02),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.02),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.greenAccent,
                          side: BorderSide(color: primary),
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0))),
                      onPressed: () {
                        submitButton();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding dateBox(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid date';
              }
              return null;
            },
            controller: dateinput,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.date_range),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.greenAccent),
                borderRadius: BorderRadius.circular(0),
              ),
              labelText: 'Choose date',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2024));

              if (pickedDate != null) {
                // print(
                //     pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                // print(
                //     formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  dateinput.text = formattedDate;
                  //set output date to TextField value.
                });
              } else {}
            },
          ),
        ));
  }
}
