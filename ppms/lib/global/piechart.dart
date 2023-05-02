import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class DashboardPieChart extends StatelessWidget {
  final int admitted;
  final int courseworkCompleted;
  final int ceCompleted;
  final int rpsCompleted;
  final int jrfSrf;
  final int ocCompleted;
  final int vivaVoceCompleted;
  final int totalActiveStudents;

  const DashboardPieChart({
    Key? key,
    required this.admitted,
    required this.courseworkCompleted,
    required this.ceCompleted,
    required this.rpsCompleted,
    required this.jrfSrf,
    required this.ocCompleted,
    required this.vivaVoceCompleted,
    required this.totalActiveStudents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: SfCircularChart(
        legend: Legend(isVisible: true, position: LegendPosition.right),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
              dataSource: <ChartData>[
                ChartData('Admitted', admitted),
                ChartData('Coursework Completed', courseworkCompleted),
                ChartData('CE Completed', ceCompleted),
                ChartData('RPS Completed', rpsCompleted),
                ChartData('JRF/SRF', jrfSrf),
                ChartData('OC Completed', ocCompleted),
                ChartData('Viva Voce Completed', vivaVoceCompleted),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (ChartData data, _) => data.color,
              dataLabelMapper: (ChartData data, _) => '${data.y}',
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }
}

class ChartData {
  final String x;
  final int y;
  final Color color;

  ChartData(this.x, this.y, {this.color = Colors.blue});
}
