import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ppms/global/globals.dart';
import 'package:ppms/global/piechart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int numStudentsPassedOut = 0;
  int numStudentsWithPMRF = 0;
  int admitted = 0;
  int courseworkCompleted = 0;
  int ceCompleted = 0;
  int rpsCompleted = 0;
  int jrfSrf = 0;
  int ocCompleted = 0;
  int vivaVoceCompleted = 0;
  int totalActiveStudents = 0;
  List<Map<String, dynamic>> yearlyJoiningStudentCount = [];
  List<Map<String, dynamic>> yearlyPassedOutStudentCount = [];

  Future<void> fetchDashboardDetails() async {
    final response = await http.get(Uri.parse('$apiUrl/siteadmin/dashboard'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        numStudentsPassedOut = data['num_students_passed_out'];
        numStudentsWithPMRF = data['num_students_with_pmrf'];
        admitted = data['admitted'];
        courseworkCompleted = data['coursework_completed'];
        ceCompleted = data['CE_completed'];
        rpsCompleted = data['RPS_completed'];
        jrfSrf = data['JRF_SRF'];
        ocCompleted = data['OC_completed'];
        vivaVoceCompleted = data['VivaVoce_completed'];
        totalActiveStudents = data['TotalActiveStudents'];
        yearlyJoiningStudentCount =
            List<Map<String, dynamic>>.from(data['YearlyJoiningStudentCount']);
        yearlyPassedOutStudentCount = List<Map<String, dynamic>>.from(
            data['YearlyPassedOutStudentCount']);
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDashboardDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: Container(
                  height: 80.0,
                  width: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('NO OF STUDENTS PASSED OUT'),
                      SizedBox(
                        height: 10,
                      ),
                      Text(numStudentsPassedOut.toString()),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Container(
                  height: 80.0,
                  width: 160,
                  child: Column(
                    children: [
                      Text('NO OF PMRF STUDENTS'),
                      SizedBox(
                        height: 10,
                      ),
                      Text(numStudentsWithPMRF.toString()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Wrap(
          children: [
            DashboardPieChart(
              admitted: 100,
              courseworkCompleted: 50,
              ceCompleted: 75,
              rpsCompleted: 20,
              jrfSrf: 40,
              ocCompleted: 90,
              vivaVoceCompleted: 30,
              totalActiveStudents: 500,
            ),
          ],
        )
      ],
    );
  }
}
