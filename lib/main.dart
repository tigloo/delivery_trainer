import 'package:delivery_trainer/bloc/departurelist_bloc.dart';
import 'package:delivery_trainer/bloc/speech_bloc.dart';
import 'package:delivery_trainer/departure.dart';
import 'package:delivery_trainer/speakable_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Trainer',
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
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SpeechBloc()),
          BlocProvider(create: (context) => DepartureListBloc()),
        ],
        child: const MyHomePage(title: 'Delivery Trainer'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool audioEnabled = true;
  String currentClearanceText = '';

  void _toggleAudio() {
    setState(() {
      audioEnabled = !audioEnabled;
    });
  }

  List<SpeakableString> departureToSpeakable(Departure departure) {
    return <SpeakableString>[
      SpeakableString.callsign(displayText: departure.callsign),
      SpeakableString.literal(displayText: 'Nuremberg Delivery'),
      SpeakableString.literal(displayText: 'Information Alpha'),
      SpeakableString.literal(displayText: 'Startup approved'),
      SpeakableString.literal(displayText: 'cleared ') +
          SpeakableString.airport(displayText: departure.destination),
      SpeakableString.route(displayText: departure.sid),
      SpeakableString.literal(displayText: 'flight planned route'),
      SpeakableString.literal(displayText: 'Climb flight level ') +
          SpeakableString.natoizedString(displayText: '070'),
      SpeakableString.literal(displayText: 'squawk ') +
          SpeakableString.squawk(displayText: departure.squawk),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: BlocBuilder<DepartureListBloc, DepartureListState>(
        builder: (context, depListState) {
          final departureListState = depListState as CurrentDepartureList;
          return BlocBuilder<SpeechBloc, SpeechState>(
            builder: (context, speechState) {
              return Row(
                children: [
                  Expanded(
                    child: Column(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Table(
                          border: TableBorder.all(),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            ...departureListState.departures
                                .map((departure) => TableRow(
                                      decoration: departure ==
                                              departureListState.departures[
                                                  departureListState
                                                      .currentDeparture]
                                          ? const BoxDecoration(
                                              color: Colors.grey)
                                          : null,
                                      children: [
                                        Text(departure.callsign),
                                        Text(departure.destination),
                                        Text(departure.sid),
                                        Text(departure.squawk),
                                      ],
                                    ))
                                .toList(),
                          ],
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _toggleAudio,
                              child: Icon(
                                  audioEnabled
                                      ? Icons.speaker_notes
                                      : Icons.speaker_notes_off,
                                  color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                primary: Colors.blue, // <-- Button color
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final speakable = departureToSpeakable(
                                    departureListState.departures[
                                        departureListState.currentDeparture]);

                                currentClearanceText = speakable
                                    .map((e) => e.displayText)
                                    .toList()
                                    .join(', ');

                                BlocProvider.of<SpeechBloc>(context).initialize(
                                    speakable
                                        .map((e) => e.speechText)
                                        .toList());

                                if (audioEnabled) {
                                  BlocProvider.of<SpeechBloc>(context).start();
                                }
                              },
                              child: const Icon(Icons.play_arrow,
                                  color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                primary: Colors.blue, // <-- Button color
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<SpeechBloc>(context)
                                    .initialize([]);
                                BlocProvider.of<DepartureListBloc>(context)
                                    .clearCurrent();
                              },
                              child: const Icon(Icons.arrow_forward,
                                  color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                primary: Colors.blue, // <-- Button color
                              ),
                            ),
                          ],
                        ),
                        Text(currentClearanceText),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
