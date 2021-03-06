import 'package:flutter/material.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:sqflite/sqflite.dart';

import '../db/city.dart';
import '../db/DatabaseHandler.dart';
import '../main.dart';

List<City> cities = [];

//cities is the list of cities that are in the database
Future<void> getCities() async {
  final Database db = await DatabaseHandler().initializeDB();
  final List<Map<String, dynamic>> maps = await db.query('cities');
  cities = List.generate(maps.length, (i) {
    return City.fromMap(maps[i]);
  });
}

class NavDrawer extends StatelessWidget {
  late DatabaseHandler handler;

  @override
  void initState() {
    handler = DatabaseHandler();
    //open the database
    handler.initializeDB();

    //get the cities from the database
    cities = handler.getCities() as List<City>;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(133, 232, 230, 230),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Center(
                  child: Column(
            children: [
              const Text(
                'Mes Villes',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 30,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              ElevatedButton(
                  onPressed: () {
                    (prompt(context)).then((value) {
                      if (value != null) {
                        // Add the city to the database
                        DatabaseHandler handler = DatabaseHandler();
                        handler.addCity(City(name: value)).then((id) {
                          cities.add(City(name: value));
                        });

                        getCities();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                      title: value,
                                    )));
                      }
                    });
                  },
                  child: const Text(
                    'Ajouter une ville',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontStyle: FontStyle.italic),
                  )),
            ],
          ))),
          ListView.builder(
            shrinkWrap: true,
            // padding: const EdgeInsets.all(),
            itemCount: cities.length,
            itemBuilder: (context, index) {
              return ListTile(
                //title is the city name,
                title: Text(
                  //print all the cities in the database
                  cities[index].name,
                ),
                textColor: Colors.white,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: cities[index].name,
                      ),
                    ),
                  );
                },
                //create a button that will delete the city from the database with the city name
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //delete the city from the database
                    DatabaseHandler handler = DatabaseHandler();
                    handler.deleteCity(cities[index].name).then((value) {
                      //update the list of cities
                      getCities();
                    });

                    //go to the home page with the first city in the database in title
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  title: cities[0].name,
                                )));
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
