import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:flutter_application/services/sql_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application/utils/alcol_item.dart';

class ChartLine extends StatelessWidget {
  const ChartLine({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const _ChartLine(title: "Etilometro"),
    );
  }
}

class _ChartLine extends StatefulWidget {
  const _ChartLine({super.key, required this.title});

  final String title;

  @override
  State<_ChartLine> createState() => _ChartLineState();
}

class _ChartLineState extends State<_ChartLine> {
  List<SalesData> _chartData = [];
  List<AlcolItem> _AlcolData = [];
  TooltipBehavior? _tooltipBehavior;

  void get_records() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _chartData = getChartData();
      _AlcolData = AlcolItem.convertToAlcolItemList(data);
    });
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    get_records();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text("Statistiche")),
        body: SfCartesianChart(
          backgroundColor: Colors.white,
          borderColor: Colors.deepPurple,
          //title: ChartTitle(text: 'Yearly sales analysis'),
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries<AlcolItem, DateTime>>[
            LineSeries<AlcolItem, DateTime>(
                name: 'AlcolValues',
                dataSource: _AlcolData,
                xValueMapper: (AlcolItem a, _) => a.createdAt,
                yValueMapper: (AlcolItem a, _) =>
                    num.parse(a.itemName.substring(3)),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                ),
                enableTooltip: true)
          ],
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2022, 8), maximum: DateTime(2023, 2)),

          primaryYAxis: NumericAxis(
              numberFormat:
                  NumberFormat.decimalPatternDigits(decimalDigits: 0)),
        ));
  }
}

List<SalesData> getChartData() {
  final List<SalesData> chartData = [
    SalesData(2017, 25),
    SalesData(2018, 12),
    SalesData(2019, 24),
    SalesData(2020, 18),
    SalesData(2021, 30)
  ];
  return chartData;
}

Future<List<AlcolItem>> get_data() async {
  final data = await SQLHelper.getItems();
  return AlcolItem.convertToAlcolItemList(data);
}
class ciao{}

class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}
