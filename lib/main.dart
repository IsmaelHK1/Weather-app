import 'package:app/widgets/background.dart';
import 'package:app/widgets/city.dart';
import 'package:app/widgets/nextDay.dart';
import 'package:app/widgets/todayWeatherBoard.dart';
import 'package:flutter/material.dart';
import 'models/todayWeather.dart';
import 'api/api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Weather app'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: background(),
        child: Center(
          child: FutureBuilder<TodayWeatherData>(
            future: fetchWeatherToday('Paris'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    city(snapshot.data),
                    todayWeatherBoard(snapshot.data),
                    const Padding(padding: EdgeInsets.only(top: 70)),
                    nextday(snapshot.data, 1),
                    nextday(snapshot.data, 2),
                    nextday(snapshot.data, 3),
                    nextday(snapshot.data, 4),
                    nextday(snapshot.data, 5),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
