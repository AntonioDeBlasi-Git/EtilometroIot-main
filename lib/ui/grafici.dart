import 'package:flutter/material.dart';
import 'package:flutter_application/ui/chartLine.dart';
import 'package:graphic/graphic.dart';
import 'package:flutter_application/services/sql_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application/utils/alcol_item.dart';
import 'package:flutter_application/ui/profile_page.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter_application/ui/map.dart';
import '../main.dart';
import 'MainPage.dart';

class Grafici extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statistiche',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      home: GraphicsPage(title: 'Statistiche'),
    );
  }
}

class GraphicsPage extends StatefulWidget {
  GraphicsPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _GraphicsPageState createState() => _GraphicsPageState();
}

class _GraphicsPageState extends State<GraphicsPage> {
  List<AlcolItem> _AlcolData = [];
  List<Element> _ElementList = [];
  TooltipBehavior? _tooltipBehavior;
  int currentIndex = 2;

  void get_records() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _AlcolData = AlcolItem.convertToAlcolItemList(data);
      _ElementList = fun(_AlcolData);
    });
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    get_records();
  }

void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  
  if(currentIndex == 0){
   Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MyHomePage(title: "Etilometro") ));
  }

  if(currentIndex == 1){
   Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const profile_page()));
  }
  if(currentIndex == 2){
     Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Grafici()));
  }
  if(currentIndex == 3){
    Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MapPage()));
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Statistiche")),
      body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.deepPurple.shade100),
              borderRadius: BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
            ),
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text('Grafico valori di alcol',
                          style: TextStyle(fontSize: 18)),
                    ),
                    IconButton(
                      alignment: Alignment.center,
                      onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChartLine()))
                      },
                      icon: Icon(Icons.zoom_in),
                    ),
                  ]),
              SfCartesianChart(
                palette: <Color>[Colors.deepPurple.shade300],
                primaryXAxis: DateTimeAxis(
                    minimum: DateTime(2023, 1), maximum: DateTime(2023, 12)),
                primaryYAxis: NumericAxis(
                    numberFormat:
                        NumberFormat.decimalPatternDigits(decimalDigits: 0)),
                legend:
                    Legend(isVisible: true, position: LegendPosition.bottom),
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
              )
            ])),
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.deepPurple.shade100),
              borderRadius: BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
            ),
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text('Misurazioni mensili',
                          style: TextStyle(fontSize: 18)),
                    ),
                    IconButton(
                      alignment: Alignment.center,
                      onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChartLine()))
                      },
                      icon: Icon(Icons.zoom_in),
                    ),
                  ]),
              SfCartesianChart(
                  palette: <Color>[Colors.deepPurple.shade300],
                  legend:
                      Legend(isVisible: true, position: LegendPosition.bottom),
                  tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries>[
                    ColumnSeries<Element, String>(
                        name: 'Tot. misurazioni mensili',
                        dataSource: _ElementList,
                        xValueMapper: (Element a, _) => a.month,
                        yValueMapper: (Element a, _) => a.count,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true)
                  ],
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    labelFormat: '{value}',
                  ))
            ]))
      ]),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MainPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButtonLocation: 
                    FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: 0.2,
        backgroundColor: Colors.deepPurple,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
        currentIndex: currentIndex,
        hasInk: true,
        inkColor: Colors.black12,
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        onTap: changePage,
        items: [
          BubbleBottomBarItem(
            backgroundColor:  Colors.deepPurple.shade200,
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text('Home'),
          ),
          BubbleBottomBarItem(
            backgroundColor:  Colors.deepPurple.shade200,
            icon: Icon(
              Icons.account_box,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.account_box,
              color: Colors.black,
            ),
            title: Text('Profilo'),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.deepPurple.shade200,
            icon: Icon(
              Icons.add_chart,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.add_chart,
              color: Colors.black,
            ),
            title: Text('Statistiche'),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.deepPurple.shade200,
            icon: Icon(
              Icons.map,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.map,
              color: Colors.black,
            ),
            title: Text('Mappa'),
          ),]
,
      ),
    );
  }
}

Future<List<AlcolItem>> get_data() async {
  final data = await SQLHelper.getItems();
  return AlcolItem.convertToAlcolItemList(data);
}

String month(int i) {
  switch (i) {
    case 1:
      {
        return "gen";
      }
    case 2:
      {
        return "Feb";
      }
    case 3:
      {
        return "Mar";
      }
    case 4:
      {
        return "Apr";
      }
    case 5:
      {
        return "Mag";
      }
    case 6:
      {
        return "Giu";
      }
    case 7:
      {
        return "Lug";
      }
    case 8:
      {
        return "Ago";
      }
    case 9:
      {
        return "Set";
      }
    case 10:
      {
        return "Ott";
      }
    case 11:
      {
        return "Nov";
      }
    case 12:
      {
        return "Dic";
      }
    default:
      {
        return "Inv";
      }
  }
}

List<Element> fun(List<AlcolItem> data) {
  List<Element> list = [];
  int counter = 0;

  for (int i = 0; i < data.length; i++) {
    AlcolItem curr = data.elementAt(i);

    if (i == 0) {
      list.add(new Element(0, month(curr.createdAt.month)));
    } else {
      String m = month(curr.createdAt.month);
      bool present = false;

      for (int k = 0; k < list.length; k++) {
        if (list.elementAt(k).month == m) {
          list.elementAt(k).count++;
          present = true;
        }
      }
      if (!present) {
        list.add(new Element(0, month(curr.createdAt.month)));
      }
    }
  }

  return new List<Element>.from(list.reversed);
}

class Element {
  Element(this.count, this.month);
  int count;
  String month;
}
