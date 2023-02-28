import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/services/sql_helper.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../services/alcol_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'profile_page.dart';
import 'MainPage.dart';
import 'grafici.dart';
import 'map.dart';

//profile page where all the user alcol record will be shown and will be send to the local db and to the server
class profile_page extends StatelessWidget {
  const profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: AlcolProvider(),
        child: MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            title: 'Dati utente',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
            ),
            home: const Profile()));
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int currentIndex = 1;
  // All records
  List<Map<String, dynamic>> _records = [];

  //method that check for permission and get the current location
  bool _isPermissionRequestInProgress = false;
  Position position = Position(
    latitude: 0.0,
    longitude: 0.0,
    altitude: 0.0,
    accuracy: 0.0,
    heading: 0.0,
    speed: 0.0,
    timestamp: DateTime.now(),
    speedAccuracy: 0,
  );
  Future<void> getCurrentLocation() async {
    if (_isPermissionRequestInProgress) {
      return;
    }

    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      } else if (status.isDenied) {
        _isPermissionRequestInProgress = true;
        Map<Permission, PermissionStatus> status = await [
          Permission.location,
        ].request();
        _isPermissionRequestInProgress = false;
      }
      if (await Permission.location.isPermanentlyDenied) {
        openAppSettings();
      }
    }
    return;
  }

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshRecords() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _records = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshRecords(); // Loading the records when the profile page is open
    getCurrentLocation(); //get the current location
  }

  final TextEditingController _titleController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingRecord =
          _records.firstWhere((element) => element['id'] == id);
      _titleController.text = existingRecord['data'];
      getCurrentLocation();
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'data'),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ));
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
        appBar: AppBar(
          title: const Text('Dati Utente'),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.deepPurple[100],
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(_records[index]['data'] +
                        '\n' +
                        _records[index]['createdAt'].toString() +
                        "\nLatitude:" +
                        _records[index]['latitude'].toString() +
                        "\nLongitude:" +
                        _records[index]['longitude'].toString()),
                  ),
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
