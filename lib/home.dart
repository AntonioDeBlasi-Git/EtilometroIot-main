import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'main.dart';





class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
      title: 'Home',
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
      home: HomePage(),
    );
  }

}




class HomePage extends StatefulWidget{
const HomePage({super.key});
 @override
  _HomeState createState() => _HomeState();
}




class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin{

  late final AnimationController _controller;
  @override
  void initState(){
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  bool bookmarked = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
           child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             Container(),
              Container(
                     alignment: Alignment.center,
                     child: Text("Benvenuto in EtilApp!",  style:
                            TextStyle(fontSize: 30, color: Colors.deepPurple.shade100)),
            ),
            GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MyHomePage(title: "Etilometro") ));
            },
            child: Lottie.network('https://assets8.lottiefiles.com/packages/lf20_m5znn9ts.json',
           ),
           ),
            Container( alignment: Alignment.center,
                     child: Text("Clicca sulla birra per iniziare",  style:
                            TextStyle(fontSize: 20, color: Colors.deepPurple.shade100)),),
                            Container()
           ],

           )
      ),
    );
  }

}
