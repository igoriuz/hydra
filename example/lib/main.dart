import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydra/hydra.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydra Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
      behaviour: const HydraBehaviour(
        breakpointSmall: kSmallBP,
        breakpointMedium: kMediumBP,
        breakpointLarge: kLargeBP,
        isOrientationAware: false,
        isSmallerScreenPreferred: true,
      ),
      small: _buildForMobile(),
      medium: _buildForTablet(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _counter + 1,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Card(
        color: index % 2 == 0 ? Colors.green : Colors.greenAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Item $index'),
        ),
      ),
    );
  }

  Widget _buildScaffold(String title, Widget content) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildForTablet() {
    return _buildScaffold(
      'Rotated Mobile / Tablet Demo',
      Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(42.0),
          child: Stack(
            children: [
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
      ),
    );
  }

  Widget _buildForMobile() {
    return _buildScaffold(
      'Mobile Demo',
      Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ..._buildChildren(),
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      Container(
        color: Colors.orange,
        child: const Text('You have pushed the button this many times:'),
      ),
      Builder(
        builder: (context) => Text(
          '$_counter',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    ];
  }
}
