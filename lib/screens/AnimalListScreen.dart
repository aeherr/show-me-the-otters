import 'package:flutter/material.dart';

import '../models/Animal.dart';
import '../models/AnimalRepo.dart';

class AnimalListScreen extends StatefulWidget {
  AnimalListScreen();

  @override
  createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State {
  final animals = new List<Animal>();
  final animalsToDisplay = new List<Animal>();

  _AnimalListScreenState();
  TextEditingController editingController = TextEditingController();

  Widget _buildBody(BuildContext context) {
    if (animals.length == 0) {
      return new Container(
        margin: const EdgeInsets.only(top: 20),
        child: new SizedBox(
          child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation(Colors.teal),
              strokeWidth: 5.0),
          height: 100.0,
          width: 100.0,
        ),
      );
    }
    return _buildList(context, animalsToDisplay);
  }

  Widget _buildList(BuildContext context, List<Animal> listAnimals) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children:
            listAnimals.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Animal animal) {
    return Padding(
      key: ValueKey(animal.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(animal.name),
//          onTap: () => Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => AnimalScreen(animal: animal),
//                ),
//              ),
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      query = query.toLowerCase();
      List<Animal> listData = List<Animal>();
      animals.forEach((item) {
        if (item.name.toLowerCase().contains(query)) {
          listData.add(item);
        }
      });
      setState(() {
        animalsToDisplay.clear();
        animalsToDisplay.addAll(listData);
      });
      return;
    } else {
      setState(() {
        animalsToDisplay.clear();
        animalsToDisplay.addAll(animals);
      });
    }
  }

  initState() async {
    super.initState();
    var futureAnimals = await getAnimals();
    setState(() {
      animals.addAll(futureAnimals);
      animalsToDisplay.addAll(futureAnimals);
    });
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animal List"),
      ),
      drawer: new Drawer(
          child: new ListView(
        children: <Widget>[
          Container(
            height: 70,
            child: new DrawerHeader(
                child: new Text(
                  "Show me the Otters!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                decoration: new BoxDecoration(color: Colors.teal),
                padding: EdgeInsets.all(20.0)),
          ),
          new ListTile(
            title: new Text('Animals'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          new ListTile(
            title: new Text('Zoos'),
//            onTap: () {
//              Navigator.of(context).pop();
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => ZooListScreen()));
//            },
            trailing: Icon(Icons.navigate_next),
          ),
        ],
      )),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            _buildBody(context),
          ],
        ),
      ),
    );
  }
}