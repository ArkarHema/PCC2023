import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class new_line extends StatefulWidget {
  const new_line({super.key});

  @override
  State<new_line> createState() => _new_lineState();
}

class _new_lineState extends State<new_line> {
  String selectedMonth = 'January'; // Default selected month

  // List of months
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
              child: Container(
                  child: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          DropdownButton<String>(
            value: selectedMonth,
            onChanged: (String? newValue) {
              setState(() {
                selectedMonth = newValue!;
              });
            },
            items: months.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 20.0,
          ),
          SfCartesianChart(
              // Enables the tooltip for all the series in chart
              tooltipBehavior: _tooltipBehavior,
              // Initialize category axis
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
                // Initialize line series
                LineSeries<ChartData, String>(
                    // Enables the tooltip for individual series
                    enableTooltip: true,
                    dataSource: [
                      // Bind data source
                      ChartData('day1', 35),
                      ChartData('day2', 25),
                      ChartData('day3', 30),
                      ChartData('day4', 45),
                      ChartData('day5', 40)
                    ],
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ]),
          const SizedBox(
            height: 20.0,
          ),
        ],
      )))),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
