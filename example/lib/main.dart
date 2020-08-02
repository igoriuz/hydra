import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydra/hydra.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  runApp(MyApp());
}

// This example is just to show how you can use Hydra.
// Splitting widgets into methods is a antipattern. Instead create a new class
// for widgets.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydra Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HydraWidget(
      behaviour: HydraBehaviour(
        breakpointSmall: kSmallBP,
        // mini -> small breakpoint
        breakpointMedium: kMediumBP,
        // small -> medium breakpoint
        breakpointLarge: kLargeBP,
        // medium -> large breakpoint
        // this prevents changing layouts when device is rotated on e.g. mobile devices
        isOrientationAware: false,
        // prefer smaller screens. by default its `false`
        isSmallerScreenPreferred: true,
      ),
      // !! warning: private methods within build methods are not recommended! this is just for demo purposes !!
      small: _buildForMobile(),
      medium: _buildForTablet(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _counter + 1,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Item $index"),
        ),
        color: index % 2 == 0 ? Colors.green : Colors.greenAccent,
      ),
    );
  }

  Widget _buildScaffold(String title, Widget content) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildForTablet() {
    return _buildScaffold(
        " Rotated Mobile / Tablet Demo",
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(28.0 * 1.5),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: MediaQuery.of(context).size.width * .45,
                  top: 0,
                  bottom: 0,
                  right: 64,
                  child: SingleChildScrollView(child: _buildList()),
                ),
                Positioned.fill(
                  right: MediaQuery.of(context).size.width * .55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildChildren(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildForMobile() {
    return _buildScaffold(
        "Mobile Demo",
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: SingleChildScrollView(
            child: Column(
              children: _buildChildren()
                ..add(_buildList()), //),  ..add(_buildList()
            ),
          ),
        ));
  }

  List<Widget> _buildChildren() {
    return <Widget>[
      Container(
        color: Colors.orange,
        child: Text(
          'You have pushed the button this many times:',
        ),
      ),
      Builder(
        builder: (context) => Text(
          '$_counter',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    ];
  }
}
