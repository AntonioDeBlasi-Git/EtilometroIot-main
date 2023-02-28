import 'dart:math';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/home.dart';
import 'package:flutter_application/services/sql_helper.dart';
import 'package:flutter_application/ui/profile_page.dart';
import 'package:flutter_application/utils/alcol_item.dart';
import 'utils/our_button.dart';
import 'ui/MainPage.dart';
import 'ui/grafici.dart';
import 'package:flutter_application/ui/map.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;
  int _selectedIndex = 0;
  int sconti = 0;
  int count = 0;
  List<AlcolItem> _AlcolData = [];
  int currentIndex = 0;

  List<String> qr_curr = [];
  List<String> qr_available = [
    "lib/images/Bar_Juta.jpg",
    "lib/images/Cinema_Victoria.jpg",
    "lib/images/Forno_Moreno.jpg",
    "lib/images/Galleria_Estense.jpg",
    "lib/images/Teatro_Storchi.jpg"
  ];

  void get_records() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _AlcolData = AlcolItem.convertToAlcolItemList(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _CountItems(_AlcolData);
     currentIndex = 0;
  }

  Future<void> loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedList = prefs.getStringList('qr_curr');
    if (savedList != null) {
      setState(() {
        qr_curr = savedList;
      });
    }
  }

  Future<void> saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList('qr_curr', qr_curr);
  }

  Future<void> _CountItems(List<AlcolItem> _AlcolData) async {
    final data = await SQLHelper.getItems();
    setState(() {
      _AlcolData = AlcolItem.convertToAlcolItemList(data);
    });

    int cnt = _AlcolData.length;
    int pt = 0;
    while (cnt > 10) {
      cnt -= 10;
      pt += 1;
    }

    await loadList();

    if (pt != sconti) {
      for (int i = 0; i < (pt - qr_curr.length); i++) {
        int rnd = Random().nextInt(qr_available.length);
        setState(() {
          qr_curr.add(qr_available[rnd]);
          saveList();
        });
      }
    }
    setState(() {
      count = cnt;
      sconti = pt;
    });
  }

 void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  
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
      appBar: AppBar(
        title: const Text('Etilometro'),
      ),
      backgroundColor: Colors.deepPurple[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(),
            Container(
                     alignment: Alignment.center,
                     child: Text("I tuoi progressi",  style:
                            TextStyle(fontSize: 20, color: Colors.deepPurple)),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: CircularPercentIndicator(
                  animation: true,
                  animationDuration: 1,
                  radius: 120,
                  lineWidth: 30,
                  percent: 0.1 * count,
                  progressColor: Colors.deepPurple,
                  backgroundColor: Colors.deepPurple.shade200,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Text((count * 10).toString() + "%",
                      style: TextStyle(fontSize: 40, color: Colors.deepPurple)),
                )),
            Container(
                height: 65,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Sconti accumulati: $sconti",
                        style:
                            TextStyle(fontSize: 20, color: Colors.deepPurple)),
                    OurButton(
                      backgroundColor: Colors.deepPurple,
                      text: "Visualizza",
                      textColor: Colors.white,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Sconti'),
                                content: Container(
                                    height: 300,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: qr_curr.length,
                                      itemBuilder: (context, index) => Card(
                                          color: Colors.deepPurple[100],
                                          margin: const EdgeInsets.all(15),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        title: Text(
                                                            qr_curr[index]
                                                                .replaceAll(
                                                                    "_", " ")
                                                                .replaceAll(
                                                                    ".jpg", "")
                                                                .substring(11)),
                                                        content: Container(
                                                            height: 300,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                20,
                                                            child: Image.asset(
                                                                qr_curr[
                                                                    index])));
                                                  });
                                            },
                                            child: ListTile(
                                              leading:
                                                  Image.asset(qr_curr[index]),
                                              title: Text(qr_curr[index]
                                                  .replaceAll("_", " ")
                                                  .replaceAll(".jpg", "")
                                                  .substring(11)),
                                            ),
                                          )),
                                    )),
                                actions: <Widget>[
                                  OurButton(
                                    text: "close",
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    backgroundColor: Colors.deepPurple,
                                    splashColor: Colors.deepPurple.shade200,
                                    textColor: Colors.white,
                                  ),
                                ],
                              );
                            });
                      },
                      splashColor: Colors.white,
                    )
                  ],
                )),
            SizedBox(height: 0),
          ],
        ),
      ),
      
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
