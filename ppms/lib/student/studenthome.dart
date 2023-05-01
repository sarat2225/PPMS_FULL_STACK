import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:intl/intl.dart';
import 'package:ppms/global/appbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ppms/global/globals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quickalert/quickalert.dart';

class StudentPersonalDetails {
  late TextEditingController genderController;
  late TextEditingController mobileController;
  late TextEditingController dobController;
  late TextEditingController pwdStatusController;
  late TextEditingController stateController;
  late TextEditingController categoryController;
  String gender;
  String mobile;
  String batch;
  String dob;
  String pwdStatus;
  String state;
  String category;

  StudentPersonalDetails({
    required this.gender,
    required this.mobile,
    required this.batch,
    required this.dob,
    required this.pwdStatus,
    required this.state,
    required this.category,
  }) {
    genderController = TextEditingController(text: gender);
    mobileController = TextEditingController(text: mobile);
    dobController = TextEditingController(text: dob);
    pwdStatusController = TextEditingController(text: pwdStatus);
    stateController = TextEditingController(text: state);
    categoryController = TextEditingController(text: category);
  }
}

class Student {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController rollnoController;
  late TextEditingController admissionModeController;
  late TextEditingController joinDateController;
  late TextEditingController isPMRFController;
  late TextEditingController phdStatusController;

  late String firstName;
  late String lastName;
  late String rollno;
  late String admissionMode;
  late String joinDate;
  late String isPMRF;
  late String phdStatus;
  late StudentPersonalDetails personalDetails;

  Student({
    required this.firstName,
    required this.lastName,
    required this.rollno,
    required this.admissionMode,
    required this.joinDate,
    required this.isPMRF,
    required this.phdStatus,
    required this.personalDetails,
  }) {
    firstNameController = TextEditingController(text: firstName);
    lastNameController = TextEditingController(text: lastName);
    rollnoController = TextEditingController(text: rollno);
    admissionModeController = TextEditingController(text: admissionMode);
    joinDateController = TextEditingController(text: joinDate);
    isPMRFController = TextEditingController(text: isPMRF);
    phdStatusController = TextEditingController(text: phdStatus);
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    final studentJson = json['student'];
    final personalDetailsJson = json;

    print(studentJson['first_name']);

    // Extracting data from JSON
    final firstName = studentJson['first_name'];
    final lastName = studentJson['last_name'];
    final admissionMode = studentJson['admission_mode'];
    final joinDate = studentJson['joining_date'];
    final isPMRF = studentJson['is_pmrf'];
    final phdStatus = studentJson['phd_status'];
    final rollno = studentJson['rollno'];
    final gender = personalDetailsJson['gender'];
    final mobile = personalDetailsJson['contact_number'];
    final batch = personalDetailsJson['joining_batch'];
    final dob = personalDetailsJson['date_of_birth'];
    final pwdStatus = personalDetailsJson['pwd_status'];
    final state = personalDetailsJson['state'];
    final category = personalDetailsJson['category'];

    // Creating and returning a new Student object
    return Student(
      firstName: firstName,
      lastName: lastName,
      admissionMode: admissionMode,
      joinDate: joinDate,
      isPMRF: isPMRF,
      phdStatus: phdStatus,
      rollno: rollno,
      personalDetails: StudentPersonalDetails(
        gender: gender,
        mobile: mobile,
        batch: batch,
        dob: dob,
        pwdStatus: pwdStatus,
        state: state,
        category: category,
      ),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['student'] = {
      'first_name': this.firstName,
      'last_name': this.lastName,
      'admission_mode': this.admissionMode,
      'joining_date': this.joinDate,
      'is_pmrf': this.isPMRF,
      'phd_status': this.phdStatus,
      'rollno': this.rollno,
    };
    data['gender'] = this.personalDetails.gender;
    data['contact_number'] = this.personalDetails.mobile;
    data['joining_batch'] = this.personalDetails.batch;
    data['date_of_birth'] = this.personalDetails.dob;
    data['pwd_status'] = this.personalDetails.pwdStatus;
    data['state'] = this.personalDetails.state;
    data['category'] = this.personalDetails.category;
    return data;
  }
}

Future<void> updateStudentDetails(Student updatedDetails, String rollno) async {
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode(updatedDetails);
  final response = await http.patch(
      Uri.parse('$apiUrl/student/$rollno/personal-details/'),
      headers: headers,
      body: body);

  if (response.statusCode == 200) {
    print("Personal details updated successfully");
  } else {
    print("Failed to update student details: ${response.body}");
  }
}

Future<Student> fetchPersonalDetails(String rollno) async {
  print(rollno);
  final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/student/$rollno/personal-details/'));
  if (response.statusCode == 200) {
    return Student.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load student personal details');
  }
}

class AcademicDetails {
  late TextEditingController notesController;
  String? ce;
  String? rps;
  String? jrfSrfConversion;
  String? oc;
  String? thesisSubmissionDate;
  String? vivavoceDate;
  String? dcMeet1;
  String? dcMeet2;
  String? dcMeet3;
  String? dcMeet4;
  String? dcMeet5;
  String? dcMeet6;
  String? dcMeet7;
  String? notes;

  AcademicDetails({
    this.ce,
    this.rps,
    this.jrfSrfConversion,
    this.oc,
    this.thesisSubmissionDate,
    this.vivavoceDate,
    this.dcMeet1,
    this.dcMeet2,
    this.dcMeet3,
    this.dcMeet4,
    this.dcMeet5,
    this.dcMeet6,
    this.dcMeet7,
    this.notes,
  }) {
    notesController = TextEditingController(text: notes);
  }

  factory AcademicDetails.fromJSON(Map<String, dynamic> json) {
    return AcademicDetails(
      ce: json['CE'],
      rps: json['RPS'],
      jrfSrfConversion: json['JRF_SRF_CONVERSION'],
      oc: json['OC'],
      thesisSubmissionDate: json['thesis_submission_date'],
      vivavoceDate: json['vivavoce_date'],
      dcMeet1: json['dc_meet1'],
      dcMeet2: json['dc_meet2'],
      dcMeet3: json['dc_meet3'],
      dcMeet4: json['dc_meet4'],
      dcMeet5: json['dc_meet5'],
      dcMeet6: json['dc_meet6'],
      dcMeet7: json['dc_meet7'],
    );
  }
  Map<String, dynamic> toJSON() {
    return {
      'CE': ce,
      'RPS': rps,
      'JRF_SRF_CONVERSION': jrfSrfConversion,
      'OC': oc,
      'thesis_submission_date': thesisSubmissionDate,
      'vivavoce_date': vivavoceDate,
      'dc_meet1': dcMeet1,
      'dc_meet2': dcMeet2,
      'dc_meet3': dcMeet3,
      'dc_meet4': dcMeet4,
      'dc_meet5': dcMeet5,
      'dc_meet6': dcMeet6,
      'dc_meet7': dcMeet7,
    };
  }
}

Future<AcademicDetails> fetchAcademicDetails(String rollno) async {
  final response =
      await http.get(Uri.parse('$apiUrl/siteadmin/$rollno/progress/'));
  if (response.statusCode == 200) {
    print(response.body);
    return AcademicDetails.fromJSON(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load student personal details');
  }
}

String? getFirstUpcomingEvent(AcademicDetails academicDetails) {
  Map<String, String?> events = {
    'CE': academicDetails.ce,
    'RPS': academicDetails.rps,
    'JRF/SRF Conversion': academicDetails.jrfSrfConversion,
    'OC': academicDetails.oc,
    'Thesis Submission': academicDetails.thesisSubmissionDate,
    'Viva-Voce': academicDetails.vivavoceDate,
    'DC Meet 1': academicDetails.dcMeet1,
    'DC Meet 2': academicDetails.dcMeet2,
    'DC Meet 3': academicDetails.dcMeet3,
    'DC Meet 4': academicDetails.dcMeet4,
    'DC Meet 5': academicDetails.dcMeet5,
    'DC Meet 6': academicDetails.dcMeet6,
    'DC Meet 7': academicDetails.dcMeet7,
  };

  String? firstEventName;
  DateTime? firstEventDate;

  for (var eventName in events.keys) {
    String? eventDateString = events[eventName];
    if (eventDateString != null) {
      DateTime? eventDate = DateTime.tryParse(eventDateString);
      if (eventDate != null && eventDate.isAfter(DateTime.now())) {
        if (firstEventDate == null || eventDate.isBefore(firstEventDate)) {
          firstEventName = eventName;
          firstEventDate = eventDate;
        }
      }
    }
  }

  if (firstEventName != null && firstEventDate != null) {
    return '$firstEventName on ${DateFormat.yMMMMd().format(firstEventDate)}';
  } else {
    return null;
  }
}

int findFirstUpcomingEventIndex(
    AcademicDetails? academicDetails, String joinDate) {
  final now = DateTime.now();
  final events = ['Joining', 'CE', 'RPS', 'JRF-SRF', 'OC', 'Viva-Voce'];
  final dates = [
    joinDate,
    academicDetails?.ce,
    academicDetails?.rps,
    academicDetails?.jrfSrfConversion,
    academicDetails?.oc,
    academicDetails?.vivavoceDate,
  ];
  int index = 7;
  DateTime? firstUpcomingDate;

  for (int i = 0; i < events.length; i++) {
    final eventDate = dates[i];
    if (eventDate != null) {
      final date = DateTime.parse(eventDate);
      if (date.isAfter(now) &&
          (firstUpcomingDate == null || date.isBefore(firstUpcomingDate))) {
        index = i;
        firstUpcomingDate = date;
      }
    }
  }

  return index - 1;
}

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeAppState();
}

class _StudentHomeAppState extends State<StudentHome> {
  Map<String, String> categoryDict = {
    'GE': 'General',
    'OBC': 'OBC',
    'SC': 'SC',
    'ST': 'ST',
    'EWS': 'EWS',
  };
  final genderChoices = {
    'M': 'Male',
    'F': 'Female',
    'O': 'Other',
  };

  Map<String, String> ynChoices = {
    'Y': 'Yes',
    'N': 'No',
  };

  Map<String, int> listTitles = {
    'Batch': 1,
    'Comprehensive Exam': 2,
    'Research Proposal': 3,
    'DC Meet-1': 4,
    'JRF to SRF': 5,
    'DC Meet-2': 6,
    'DC Meet-3': 7,
    'DC Meet-4': 8,
    'DC Meet-5': 9,
    'DC Meet-6': 10,
    'DC Meet-7': 11,
    'Open Colloquium': 12,
    'Thesis Submission': 13,
    'Viva Voce': 14,
  };

  String dateFormat = "yyyy-MM-dd";
  bool isEditMode = false;
  String roll_no = global?.email.split("@")[0] ?? "";
  bool pwdStatusChecked = false;
  int _progressIndex = -1;
  late List<StepperData> stepperData;
  late List<String> events;

  Student? student;
  AcademicDetails? academicDetails;
  void _fetchData() async {
    student = await fetchPersonalDetails(roll_no);
    academicDetails = await fetchAcademicDetails(roll_no);
    print('init done');
    setState(() {
      _progressIndex =
          findFirstUpcomingEventIndex(academicDetails, student?.joinDate ?? "");
      print(_progressIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    events = ['Joining', 'CE', 'RPS', 'JRF-SRF', 'OC', 'Viva-Voce'];
  }

  @override
  Widget build(BuildContext context) {
    stepperData = [
      StepperData(
        title: StepperText(
          "Joining",
          textStyle: TextStyle(
            color: _progressIndex >= 0 ? Colors.blue : Colors.grey,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _progressIndex >= 0 ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: _progressIndex >= 0
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Icon(
                  Icons.circle,
                  color: Colors.grey,
                ),
        ),
      ),
      StepperData(
        title: StepperText(
          "CE",
          textStyle: TextStyle(
            color: _progressIndex >= 1 ? Colors.blue : Colors.grey,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _progressIndex >= 1 ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: _progressIndex >= 1
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Icon(
                  Icons.circle,
                  color: Colors.grey,
                ),
        ),
      ),
      StepperData(
        title: StepperText(
          "RPS",
          textStyle: TextStyle(
            color: _progressIndex >= 2 ? Colors.blue : Colors.grey,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _progressIndex >= 2 ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: _progressIndex >= 2
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Icon(
                  Icons.circle,
                  color: Colors.grey,
                ),
        ),
      ),
      StepperData(
        title: StepperText(
          "JRF-SRF",
          textStyle: TextStyle(
            color: _progressIndex >= 3 ? Colors.blue : Colors.grey,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _progressIndex >= 3 ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: _progressIndex >= 3
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Icon(
                  Icons.circle,
                  color: Colors.grey,
                ),
        ),
      ),
      StepperData(
        title: StepperText(
          "OC",
          textStyle: TextStyle(
            color: _progressIndex >= 4 ? Colors.blue : Colors.grey,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _progressIndex >= 4 ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: _progressIndex >= 4
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Icon(
                  Icons.circle,
                  color: Colors.grey,
                ),
        ),
      ),
      StepperData(
        title: StepperText(
          "Viva-Voce",
          textStyle: TextStyle(
            color: _progressIndex >= 5 ? Colors.blue : Colors.grey,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _progressIndex >= 5 ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: _progressIndex >= 5
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Icon(
                  Icons.circle,
                  color: Colors.grey,
                ),
        ),
      ),
    ];
    final Globals? global =
        ModalRoute.of(context)!.settings.arguments as Globals;
    if (student == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: CustomAppBar(
            pageTitle: 'Student Home Page',
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 48.0,
                  ),
                  Center(
                    child: Container(
                      width: 800,
                      child: AnotherStepper(
                        stepperList: stepperData,
                        stepperDirection: Axis.horizontal,
                        iconWidth: 40,
                        iconHeight: 40,
                        activeBarColor: Colors.orange,
                        inActiveBarColor: Colors.grey,
                        inverted: true,
                        verticalGap: 30,
                        activeIndex: _progressIndex,
                        barThickness: 8,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 300,
                            height: 400,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: ListView(children: [
                              Text(
                                'Form Links',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListTile(
                                title: Text('Guide Consent form (Doc)'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/Guide_Consent_form_17_08_2021.docx')),
                              ),
                              ListTile(
                                title: Text('Guide Consent form (PDF)'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/Guide_Consent_form_17_08_2021.pdf')),
                              ),
                              ListTile(
                                title:
                                    Text('Guide Consent form for ID Program'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/ID_Program_Guide_Consent_form_18_08_2021.pdf')),
                              ),
                              ListTile(
                                title: Text('Guide Change Consent form'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/PhD-Guide-change-form.docx')),
                              ),
                              ListTile(
                                title: Text(
                                    'Doctoral Committee Constitution form'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/PhD-Doctoral-Committee-revised-Form.doc')),
                              ),
                              ListTile(
                                title: Text(
                                    'Doctoral Committee Constitution form for ID Program'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/DC_Form_for_ID_PhD_20_09_2021.docx')),
                              ),
                              ListTile(
                                title: Text(
                                    'Doctoral Committee Constitution form for IITH-Deakin JDP'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/Doctoral_Committee_Constitution_Form_IITH-Deakin_JDP.docx')),
                              ),
                              ListTile(
                                title: Text(
                                    'Review of the PhD Research Progress Defense form'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/PhD-defense-review-form.docx')),
                              ),
                              ListTile(
                                title:
                                    Text('Comprehensive Exam evaluation form'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/ComprehensiveExamFormat_revised(1).docx')),
                              ),
                              ListTile(
                                title: Text(
                                    'Evaluation of Comprehensive Exam Form - IITH-DEAKIN University JDP'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/IITH-Deakin U_JDP_Comprehensive_Exam_Form.docx')),
                              ),
                              ListTile(
                                title: Text(
                                    'Evaluation of the PhD Research Proposal Defense form'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/PhD-Proposal-Defense-form.docx')),
                              ),
                              ListTile(
                                title: Text(
                                    'Evaluation of Research Proposal Defence Form- IITH-Deakin University JDP'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/IITH_Deakin U_JDP_Research_Proposal-Defense-Form.docx')),
                              ),
                              ListTile(
                                title: Text(
                                    'Assessment Committee Report for JRF To SRF under MoE (Ministry of Education)'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/PhD-JRF-to-SRF-MoE(2).docx')),
                              ),
                              ListTile(
                                title: Text('Six-Monthly Report'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://iith.ac.in/academics/assets/files/forms/Six-Monthly Report Format (2).docx')),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                          Container(
                              width: 300,
                              height: 150,
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: ListView(children: [
                                Text(
                                  'Doctoral Committee',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]))
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 480.0,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Personal Details',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[200],
                                            title: Text(
                                              'Edit your Personal Details',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.indigo[900],
                                              ),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                DateTimeField(
                                                  format:
                                                      DateFormat(dateFormat),
                                                  controller: student
                                                      ?.personalDetails
                                                      .dobController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Date of Birth',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Colors.indigo[900]),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                  ),
                                                  onShowPicker: (context,
                                                      currentValue) async {
                                                    final date =
                                                        await showDatePicker(
                                                            context: context,
                                                            firstDate:
                                                                DateTime(1900),
                                                            initialDate:
                                                                currentValue ??
                                                                    DateTime
                                                                        .now(),
                                                            lastDate:
                                                                DateTime(2100));
                                                    if (date != null) {
                                                      setState(() {
                                                        student
                                                                ?.personalDetails
                                                                .dobController
                                                                .text =
                                                            date.toString();
                                                      });
                                                    }
                                                    return date;
                                                  },
                                                ),
                                                DropdownButtonFormField<String>(
                                                  value: student
                                                      ?.personalDetails
                                                      .genderController
                                                      .text,
                                                  decoration: InputDecoration(
                                                    labelText: 'Gender',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Colors.indigo[900]),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                  ),
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: 'M',
                                                      child: Text('Male'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'F',
                                                      child: Text('Female'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'O',
                                                      child: Text('Others'),
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      student
                                                          ?.personalDetails
                                                          .genderController
                                                          .text = value ?? '';
                                                    });
                                                  },
                                                ),
                                                DropdownButtonFormField<String>(
                                                  value: student
                                                      ?.personalDetails
                                                      .categoryController
                                                      .text,
                                                  decoration: InputDecoration(
                                                    labelText: 'Category',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Colors.indigo[900]),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                  ),
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: 'GE',
                                                      child: Text('General'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'EWS',
                                                      child: Text('EWS'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'OBC',
                                                      child: Text('OBC'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'SC',
                                                      child: Text('SC'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'ST',
                                                      child: Text('ST'),
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      student
                                                          ?.personalDetails
                                                          .categoryController
                                                          .text = value ?? '';
                                                    });
                                                  },
                                                ),
                                                DropdownButtonFormField<String>(
                                                  value: student
                                                      ?.personalDetails
                                                      .pwdStatusController
                                                      .text,
                                                  decoration: InputDecoration(
                                                    labelText: 'PWD status',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Colors.indigo[900]),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                  ),
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: 'Y',
                                                      child: Text('Yes'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'N',
                                                      child: Text('No'),
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      student
                                                          ?.personalDetails
                                                          .pwdStatusController
                                                          .text = value ?? '';
                                                    });
                                                  },
                                                ),
                                                TextField(
                                                  controller: student
                                                      ?.personalDetails
                                                      .mobileController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Mobile No.',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Colors.indigo[900]),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                  ),
                                                ),
                                                TextField(
                                                  controller: student
                                                      ?.personalDetails
                                                      .stateController,
                                                  decoration: InputDecoration(
                                                    labelText: 'State',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Colors.indigo[900]),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .indigo[900]!),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              ElevatedButton(
                                                child: Text('Update'),
                                                onPressed: () {
                                                  setState(() {
                                                    student?.personalDetails
                                                            .gender =
                                                        student!
                                                            .personalDetails
                                                            .genderController
                                                            .text;
                                                    student?.personalDetails
                                                            .mobile =
                                                        student!
                                                            .personalDetails
                                                            .mobileController
                                                            .text;
                                                    student?.personalDetails
                                                            .dob =
                                                        student!.personalDetails
                                                            .dobController.text;
                                                    student?.personalDetails
                                                            .pwdStatus =
                                                        student!
                                                            .personalDetails
                                                            .pwdStatusController
                                                            .text;
                                                    student?.personalDetails
                                                            .category =
                                                        student!
                                                            .personalDetails
                                                            .categoryController
                                                            .text;
                                                    student?.personalDetails
                                                            .state =
                                                        student!
                                                            .personalDetails
                                                            .stateController
                                                            .text;

                                                    updateStudentDetails(
                                                        student!, roll_no);
                                                  });
                                                  // Close the dialog box

                                                  Navigator.of(context).pop();

                                                  QuickAlert.show(
                                                      context: context,
                                                      type: QuickAlertType
                                                          .success,
                                                      text:
                                                          "Personal Details Updated successfully",
                                                      width: 100);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Name:',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              student!.firstName +
                                                  ' ' +
                                                  student!.lastName,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Category:',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              categoryDict[student!
                                                  .personalDetails.category]!,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Gender:',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              genderChoices[student!
                                                  .personalDetails.gender]!,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Mobile No:',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              student!.personalDetails.mobile,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 120.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Roll No:',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              student!.rollno,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Date of Birth:',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              student!.personalDetails.dob,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'PWD Status:',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              ynChoices[student!
                                                  .personalDetails.pwdStatus]!,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'State:',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              student!.personalDetails.state,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: 100.0,
                          ), //DC committee
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 300,
                            height: 400,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: ListView(children: [
                              Text(
                                'Academic Details',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Batch:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(student!.personalDetails.batch),
                              ),
                              if (academicDetails?.ce != null)
                                ListTile(
                                  title: Text(
                                    'Comprehensive Exam:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(academicDetails?.ce ?? ''),
                                ),
                              if (academicDetails?.rps != null)
                                ListTile(
                                  title: Text(
                                    'Research Proposal:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(academicDetails?.rps ?? ''),
                                ),
                              if (academicDetails?.dcMeet1 != null)
                                ListTile(
                                  title: Text(
                                    'DC Meet-1:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      Text(academicDetails?.dcMeet1 ?? ''),
                                ),
                              if (academicDetails?.jrfSrfConversion != null)
                                ListTile(
                                  title: Text(
                                    'JRF to SRF:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                      academicDetails?.jrfSrfConversion ?? ''),
                                ),
                              if (academicDetails?.dcMeet2 != null)
                                ListTile(
                                  title: Text(
                                    'DC Meet-2:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      Text(academicDetails?.dcMeet2 ?? ''),
                                ),
                              if (academicDetails?.dcMeet3 != null)
                                ListTile(
                                  title: Text(
                                    'DC Meet-3:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      Text(academicDetails?.dcMeet3 ?? ''),
                                ),
                              if (academicDetails?.dcMeet4 != null)
                                ListTile(
                                  title: Text(
                                    'DC Meet-4:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      Text(academicDetails?.dcMeet4 ?? ''),
                                ),
                              if (academicDetails?.dcMeet5 != null)
                                ListTile(
                                  title: Text(
                                    'DC Meet-5:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      Text(academicDetails?.dcMeet5 ?? ''),
                                ),
                              if (academicDetails?.dcMeet6 != null)
                                ListTile(
                                  title: Text(
                                    'DC Meet-6:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      Text(academicDetails?.dcMeet6 ?? ''),
                                ),
                              if (academicDetails?.dcMeet7 != null)
                                ListTile(
                                  title: Text(
                                    'DC Meet-7:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      Text(academicDetails?.dcMeet7 ?? ''),
                                ),
                              if (academicDetails?.oc != null)
                                ListTile(
                                  title: Text(
                                    'Open Colloquium:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(academicDetails?.oc ?? ''),
                                ),
                              if (academicDetails?.thesisSubmissionDate != null)
                                ListTile(
                                  title: Text(
                                    'Thesis Submission:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                      academicDetails?.thesisSubmissionDate ??
                                          ''),
                                ),
                              if (academicDetails?.vivavoceDate != null)
                                ListTile(
                                  title: Text(
                                    'Viva Voce:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      Text(academicDetails?.vivavoceDate ?? ''),
                                ),
                            ]),
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                          Container(
                              width: 300,
                              height: 100,
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: ListView(children: [
                                Text(
                                  'Upcoming Events',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    getFirstUpcomingEvent(academicDetails!) ??
                                        " ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
