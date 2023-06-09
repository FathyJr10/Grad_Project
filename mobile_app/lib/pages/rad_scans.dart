import 'package:flutter/material.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/notifications_service.dart';
import 'package:mobile_app/pages/rad_report.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api/user.dart';
import '../configure.dart';

class rad_scans extends StatefulWidget {
  const rad_scans({super.key});

  @override
  State<rad_scans> createState() => _rad_scansState();
}

class _rad_scansState extends State<rad_scans> {
  List<Map<String, dynamic>> scansList = [];

  void getReportlist(int patientId) {
    fetchScansList(patientId).then((list) {
      setState(() {
        scansList = list;
      });
    }).catchError((error) {
      // Handle error
      print('Error: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    int userId = Provider.of<UserIdProvider>(context, listen: false).id!;
    getReportlist(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Radiology Scans'),
        centerTitle: true,
        backgroundColor: primary,
        shadowColor: Colors.greenAccent,
        elevation: 10,
      ),
      body: scansList.isEmpty
          ? Center(
              child: Text(
              'You dont have any Results yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ))
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: scansList.length,
                        itemBuilder: (context, index) {
                          final scans = scansList[index];
                          String dateTimeString = scans['created_at'];
                          DateTime dateTime = DateTime.parse(dateTimeString);
                          String date =
                              DateFormat("dd-MM-yyyy").format(dateTime);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 4.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.greenAccent,
                                ),
                                borderRadius:
                                    BorderRadius.circular(20.0), //<-- SEE HERE
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => rad_report(
                                            scans: scansList[index],
                                          )));
                                },
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(scans['name'] ?? ''),
                                        Text(' - '),
                                        Text(scans['entityName'].toLowerCase()),

                                      ],
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    )
                                  ],
                                ),
                                subtitle: Text(scans['examined_part'] ?? ''),
                                leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/rad.png')),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Future<Map<String, dynamic>> fetcEntityById(int entityId) async {
  final response =
      await http.get(Uri.parse('${AppUrl.Base_Url}/entity/$entityId'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch entity');
  }
}

Future<List<Map<String, dynamic>>> fetchScansList(int patientId) async {
  final response = await http
      .get(Uri.parse('${AppUrl.Base_Url}/radiology/patient/$patientId'));

  if (response.statusCode == 200) {
    final List<dynamic> scansJsonList = jsonDecode(response.body);
    final List<Map<String, dynamic>> scansList = [];

    for (final scansJson in scansJsonList) {
      scansList.add(Map<String, dynamic>.from(scansJson));
      final entityData = await fetcEntityById(scansJson['entity_id'] ?? 0);
      final entityName = entityData['name'] ?? 'not specified';
      scansList.last['entityName'] = entityName;
      print(scansList);
    }
    await NotficationService.showNotification(
      title: 'New medical record',
      body: 'Its Radiology report from ${scansList.last['entityName']}.',
      scheduled: true,
      interval: 10, // Single notification, not repeating
      // Date in "2023-05-26" format
    );
    return scansList;
  } else {
    throw Exception('Failed to fetch Scans list');
  }
}
