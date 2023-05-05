import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ppms/global/globals.dart';

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

class StudentTable extends StatefulWidget {
  StudentTable({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Student> paginatedDataSource = [];
List<Student> _students = [];
final int rowsPerPage = 10;

class _MyHomePageState extends State<StudentTable> {
  StudentDataSource? _studentDataSource;
  AcademicDetails? academicDetails;

  bool showLoadingIndicator = true;
  double pageCount = 0;

  final TextEditingController _searchController = TextEditingController();

  String? _selectedParameter;

  Future<List<Student>> fetchStudentDetails(String Param) async {
    final response = await http
        .get(Uri.parse('$apiUrl/siteadmin/all-student-detailed-data/?$Param'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      var data1 = data.map((json) => Student.fromJson(json)).toList();
      return data1;
    } else {
      throw Exception('Failed to load student personal details');
    }
  }

  Future<void> populateData(String Param) async {
    var data = await fetchStudentDetails(Param);
    setState(() {
      _students = data;
      _studentDataSource = StudentDataSource();
      pageCount = (_students.length / rowsPerPage).ceilToDouble();
    });
  }

  @override
  void initState() {
    super.initState();
    populateData('');
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_studentDataSource != null) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 25.0,
                ),
                // Create a new container for the search bar
                Row(
                  children: [
                    SizedBox(
                      width: 50.0,
                    ),
                    Container(
                      width: 175.0,
                      child: DropdownButtonFormField<String>(
                        value: _selectedParameter,
                        onChanged: (value) {
                          setState(() {
                            _selectedParameter = value;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: 'rollno',
                            child: Text('Roll No'),
                          ),
                          DropdownMenuItem(
                            value: 'admission_mode',
                            child: Text('Admission Mode'),
                          ),
                          DropdownMenuItem(
                            value: 'phd_status',
                            child: Text('PhD Status'),
                          ),
                          DropdownMenuItem(
                            value: 'year_of_joining',
                            child: Text('Year of Joining'),
                          ),
                          DropdownMenuItem(
                            value: 'gender',
                            child: Text('Gender'),
                          ),
                          DropdownMenuItem(
                            value: 'category',
                            child: Text('Category'),
                          ),
                          DropdownMenuItem(
                            value: 'pwd_status',
                            child: Text('PWD Status'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Select a parameter',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 35.0,
                    ),
                    Container(
                      width: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            print("#");
                            // Call setState to rebuild the datagrid when the search text changes
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            String? Param = _selectedParameter;
                            Param = Param! + "=";
                            Param = Param + _searchController.text;
                            populateData(Param);
                            print(_students);
                            _studentDataSource!.buildDataGridRows();
                          });
                        },
                        icon: Icon(Icons.search))
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Row(children: [
                      Column(
                        children: [
                          SizedBox(
                              height: constraints.maxHeight - 50,
                              width: constraints.maxWidth,
                              child: buildStack(constraints)),
                          Container(
                            height: 50,
                            width: constraints.maxWidth,
                            child: SfDataPager(
                              pageCount: pageCount,
                              direction: Axis.horizontal,
                              onPageNavigationStart: (int pageIndex) {
                                setState(() {
                                  showLoadingIndicator = true;
                                });
                              },
                              delegate: _studentDataSource!,
                              onPageNavigationEnd: (int pageIndex) {
                                setState(() {
                                  showLoadingIndicator = false;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ]);
                  }),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildDataGrid(BoxConstraints constraint) {
    if (_studentDataSource != null) {
      return SfDataGrid(
          rowHeight: 60.0,
          source: _studentDataSource!,
          allowSorting: true,
          columnWidthMode: ColumnWidthMode.fill,
          columns: <GridColumn>[
            GridColumn(
                columnName: 'Name',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Name',
                    ))),
            GridColumn(
                columnName: 'Roll No',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Roll No',
                    ))),
            GridColumn(
                columnName: 'Batch',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Batch',
                    ))),
            GridColumn(
                columnName: 'gender',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text('Gender'))),
            GridColumn(
                columnName: 'Pwd Status',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Pwd Status',
                    ))),
            GridColumn(
                columnName: 'PhD Status',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'PhD Status',
                    ))),
            GridColumn(
                columnName: 'Admission Mode',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Admission Mode',
                    ))),
            GridColumn(
                columnName: 'Joining Date',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Joining Date',
                    ))),
          ]);
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildStack(BoxConstraints constraints) {
    List<Widget> _getChildren() {
      final List<Widget> stackChildren = [];
      stackChildren.add(buildDataGrid(constraints));

      if (showLoadingIndicator) {
        stackChildren.add(Container(
          color: Colors.black12,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        ));
      }

      return stackChildren;
    }

    return Stack(
      children: _getChildren(),
    );
  }
}

class StudentDataSource extends DataGridSource {
  StudentDataSource() {
    paginatedDataSource = _students.toList();
    buildDataGridRows();
  }

  List<DataGridRow> _studentData = [];

  @override
  List<DataGridRow> get rows => _studentData;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    await Future.delayed(const Duration(seconds: 1));
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _students.length) {
      if (endIndex > _students.length) {
        endIndex = _students.length;
      }
      paginatedDataSource =
          _students.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  void buildDataGridRows() {
    _studentData = paginatedDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'Name', value: e.firstName + ' ' + e.lastName),
              DataGridCell<String>(columnName: 'Roll No', value: e.rollno),
              DataGridCell<String>(
                  columnName: 'Batch', value: e.personalDetails.batch),
              DataGridCell<String>(
                  columnName: 'gender', value: e.personalDetails.gender),
              DataGridCell<String>(
                  columnName: 'Pwd Status', value: e.personalDetails.pwdStatus),
              DataGridCell<String>(
                  columnName: 'PhD Status', value: e.phdStatus),
              DataGridCell<String>(
                  columnName: 'Admission Mode', value: e.admissionMode),
              DataGridCell<String>(
                  columnName: 'Joining Date', value: e.joinDate),
            ]))
        .toList();
  }

  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == 'Name') {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(dataGridCell.value.toString()),
          );
        } else if (dataGridCell.columnName == 'Roll No') {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(dataGridCell.value.toString()),
          );
        } else if (dataGridCell.columnName == 'Batch') {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(dataGridCell.value.toString()),
          );
        } else if (dataGridCell.columnName == 'gender') {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(dataGridCell.value.toString()),
          );
        } else if (dataGridCell.columnName == 'Pwd Status') {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(dataGridCell.value.toString()),
          );
        } else if (dataGridCell.columnName == 'PhD Status') {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(dataGridCell.value.toString()),
          );
        } else if (dataGridCell.columnName == 'Admission Mode') {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(dataGridCell.value.toString()),
          );
        } else if (dataGridCell.columnName == 'Joining Date') {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(dataGridCell.value.toString()),
          );
        } else {
          return Container();
        }
      }).toList(),
    );
  }
}

class StudentPersonalDetails {
  String gender;
  String mobile;
  String batch;
  String dob;
  String pwdStatus;
  String state;
  StudentPersonalDetails({
    required this.gender,
    required this.mobile,
    required this.batch,
    required this.dob,
    required this.pwdStatus,
    required this.state,
  });
}

class Student {
  String firstName;
  String lastName;
  String rollno;
  String admissionMode;
  String joinDate;
  String isPMRF;
  String phdStatus;
  StudentPersonalDetails personalDetails;

  Student({
    required this.firstName,
    required this.lastName,
    required this.rollno,
    required this.admissionMode,
    required this.joinDate,
    required this.isPMRF,
    required this.phdStatus,
    required this.personalDetails,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    final studentJson = json['student'];
    final personalDetailsJson = json;

    //print(studentJson['first_name']);

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
      ),
    );
  }
}
