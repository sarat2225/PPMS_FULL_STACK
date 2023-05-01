import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:data_table_2/data_table_2.dart';

enum SortDirection { ascending, descending }

class SortState {
  SortDirection sortDirection;
  int columnIndex;

  SortState(this.sortDirection, this.columnIndex);
}

class MyDataTable extends StatefulWidget {
  const MyDataTable({Key? key}) : super(key: key);

  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  final String apiUrl = 'http://127.0.0.1:8000/student/detailed-data';
  int _rowsPerPage = 10;
  int _totalItems = 0;
  List<Student> _dataList = [];

  Future<void> _getData() async {
    var response = await http.get(Uri.parse(apiUrl));
    var data = jsonDecode(response.body);

    setState(() {
      _dataList = (data as List).map((item) => Student.fromJson(item)).toList();
    });
  }

  late List<SortState> _sortStates;

  void sort<T>(Comparable<T> Function(Student d) getField, int columnIndex) {
    final sortState = _sortStates[columnIndex];
    if (sortState.sortDirection == SortDirection.ascending) {
      _dataList.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        final comparison = Comparable.compare(aValue, bValue);
        return comparison;
      });
      _sortStates[columnIndex] =
          SortState(SortDirection.descending, columnIndex);
    } else {
      _dataList.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        final comparison = Comparable.compare(bValue, aValue);
        return comparison;
      });
      _sortStates[columnIndex] =
          SortState(SortDirection.ascending, columnIndex);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _sortStates = List.filled(8, SortState(SortDirection.ascending, -1));
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      showFirstLastButtons: true,
      availableRowsPerPage: [10],
      columns: [
        DataColumn(
          label: Row(
            children: [
              Text('Name'),
              _sortStates[0].columnIndex == 0
                  ? _sortStates[0].sortDirection == SortDirection.ascending
                      ? Icon(Icons.arrow_upward)
                      : Icon(Icons.arrow_downward)
                  : SizedBox(
                      width: 0,
                    ),
            ],
          ),
          onSort: (columnIndex, ascending) =>
              sort<String>((d) => d.firstName + " " + d.lastName, columnIndex),
        ),
        DataColumn(
          label: Row(
            children: [
              Text('Roll No'),
              _sortStates[1].columnIndex == 1
                  ? _sortStates[1].sortDirection == SortDirection.ascending
                      ? Icon(Icons.arrow_drop_up)
                      : Icon(Icons.arrow_drop_down)
                  : SizedBox(),
            ],
          ),
          onSort: (columnIndex, ascending) =>
              sort<String>((d) => d.rollno, columnIndex),
        ),
        DataColumn(
          label: Row(
            children: [
              Text('Batch'),
              _sortStates[2].columnIndex == 2
                  ? _sortStates[2].sortDirection == SortDirection.ascending
                      ? Icon(Icons.arrow_drop_up)
                      : Icon(Icons.arrow_drop_down)
                  : SizedBox(),
            ],
          ),
          onSort: (columnIndex, ascending) =>
              sort<String>((d) => d.personalDetails.batch, columnIndex),
        ),
        DataColumn(
          label: Row(
            children: [
              Text('Gender'),
              _sortStates[3].columnIndex == 3
                  ? _sortStates[3].sortDirection == SortDirection.ascending
                      ? Icon(Icons.arrow_drop_up)
                      : Icon(Icons.arrow_drop_down)
                  : SizedBox(
                      width: 0,
                    ),
            ],
          ),
          onSort: (columnIndex, ascending) =>
              sort<String>((d) => d.personalDetails.gender, columnIndex),
        ),
        DataColumn(
          label: Row(
            children: [
              Text('Pwd Status'),
              _sortStates[4].columnIndex == 4
                  ? _sortStates[4].sortDirection == SortDirection.ascending
                      ? Icon(Icons.arrow_drop_up)
                      : Icon(Icons.arrow_drop_down)
                  : SizedBox(),
            ],
          ),
          onSort: (columnIndex, ascending) =>
              sort<String>((d) => d.personalDetails.pwdStatus, columnIndex),
        ),
        DataColumn(
          label: Row(
            children: [
              Text('PhD status'),
              _sortStates[5].columnIndex == 5
                  ? _sortStates[5].sortDirection == SortDirection.ascending
                      ? Icon(Icons.arrow_drop_up)
                      : Icon(Icons.arrow_drop_down)
                  : SizedBox(),
            ],
          ),
          onSort: (columnIndex, ascending) =>
              sort<String>((d) => d.phdStatus, columnIndex),
        ),
        DataColumn(
          label: Row(
            children: [
              Text('Admission Mode'),
              _sortStates[6].columnIndex == 6
                  ? _sortStates[6].sortDirection == SortDirection.ascending
                      ? Icon(Icons.arrow_drop_up)
                      : Icon(Icons.arrow_drop_down)
                  : SizedBox(),
            ],
          ),
          onSort: (columnIndex, ascending) =>
              sort<String>((d) => d.admissionMode, columnIndex),
        ),
        DataColumn(
          label: Row(
            children: [
              Text('Joining Date'),
              _sortStates[7].columnIndex == 7
                  ? _sortStates[7].sortDirection == SortDirection.ascending
                      ? Icon(Icons.arrow_drop_up)
                      : Icon(Icons.arrow_drop_down)
                  : SizedBox(),
            ],
          ),
          onSort: (columnIndex, ascending) =>
              sort<String>((d) => d.joinDate, columnIndex),
        ),
      ],
      header: Text('My Data Table'),
      rowsPerPage: _rowsPerPage,
      onRowsPerPageChanged: (value) {
        setState(() {
          //print(value);
          _rowsPerPage = value!;
          _getData();
        });
      },
      onPageChanged: (value) {
        setState(() {
          _getData();
        });
      },
      source: MyDataTableSource(_dataList),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _getData();
            });
          },
        ),
      ],
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<Student> dataList;

  MyDataTableSource(this.dataList);

  @override
  DataRow? getRow(int index) {
    if (index >= dataList.length) {
      return null;
    }
    final item = dataList[index];
    return DataRow.byIndex(index: index, cells: item.toDataCells());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dataList.length;

  @override
  int get selectedRowCount => 0;
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

  List<DataCell> toDataCells() {
    return [
      DataCell(Text(firstName + ' ' + lastName)),
      DataCell(Text(rollno)),
      DataCell(Text(personalDetails.batch)),
      DataCell(Text(personalDetails.gender)),
      DataCell(Text(personalDetails.pwdStatus)),
      DataCell(Text(phdStatus)),
      DataCell(Text(admissionMode)),
      DataCell(Text(joinDate)),
    ];
  }

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
