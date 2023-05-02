import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ppms/global/globals.dart';

class professorTable extends StatefulWidget {
  professorTable({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<professor> paginatedDataSource = [];
List<professor> _professors = [];
final int rowsPerPage = 10;

class _MyHomePageState extends State<professorTable> {
  professorDataSource? _professorDataSource;

  bool showLoadingIndicator = true;
  double pageCount = 0;

  final TextEditingController _searchController = TextEditingController();

  String? _selectedParameter;

  Future<List<professor>> fetchprofessorDetails() async {
    final response =
        await http.get(Uri.parse('$apiUrl/siteadmin/all-professors-list'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      var data1 = data.map((json) => professor.fromJson(json)).toList();
      print(data1);
      return data1;
    } else {
      throw Exception('Failed to load professor personal details');
    }
  }

  Future<void> populateData() async {
    var data = await fetchprofessorDetails();
    setState(() {
      _professors = data;
      _professorDataSource = professorDataSource();
      pageCount = (_professors.length / rowsPerPage).ceilToDouble();
    });
  }

  @override
  void initState() {
    super.initState();
    populateData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_professorDataSource != null) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 75.0,
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
                              delegate: _professorDataSource!,
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
    if (_professorDataSource != null) {
      return SfDataGrid(
          rowHeight: 60.0,
          source: _professorDataSource!,
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
                columnName: 'Department',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Department',
                    ))),
            GridColumn(
                columnName: 'Field',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Field',
                    ))),
            GridColumn(
                columnName: 'Email',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text('Email'))),
            GridColumn(
                columnName: 'Qualification',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Qualification',
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

class professorDataSource extends DataGridSource {
  professorDataSource() {
    paginatedDataSource = _professors.toList();
    buildDataGridRows();
  }

  List<DataGridRow> _professorData = [];

  @override
  List<DataGridRow> get rows => _professorData;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    await Future.delayed(const Duration(seconds: 1));
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _professors.length) {
      if (endIndex > _professors.length) {
        endIndex = _professors.length;
      }
      paginatedDataSource =
          _professors.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  void buildDataGridRows() {
    _professorData = paginatedDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'Name', value: e.first_name + ' ' + e.last_name),
              DataGridCell<String>(
                  columnName: 'Department', value: e.department),
              DataGridCell<String>(columnName: 'Field', value: e.field),
              DataGridCell<String>(columnName: 'Email', value: e.email),
              DataGridCell<String>(
                  columnName: 'Qualification', value: e.qualification),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
}

class professor {
  String first_name;
  String last_name;
  String department;
  String field;
  String email;
  String qualification;

  professor({
    required this.first_name,
    required this.last_name,
    required this.department,
    required this.field,
    required this.email,
    required this.qualification,
  });

  factory professor.fromJson(Map<String, dynamic> json) {
    final professorJson = json;
    // Extracting data from JSON
    print(professorJson);
    final first_name = professorJson['first_name'];
    final last_name = professorJson['last_name'];
    final department = professorJson['department'];
    final field = professorJson['field'];
    final email = professorJson['email'];
    final qualification = professorJson['qualification'];
    // Creating and returning a new professor object
    return professor(
      first_name: first_name,
      last_name: last_name,
      department: department,
      field: field,
      email: email,
      qualification: qualification,
    );
  }
}
