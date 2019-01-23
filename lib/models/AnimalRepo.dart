import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Animal.dart';

List<Animal> animals;

Future getAnimals() {
  var completer = new Completer();
  if (animals != null) {
    completer.complete(animals);
  } else {
    Firestore.instance.collection('animals').snapshots().listen((data) {
      animals = new List<Animal>();
      data.documents.forEach((doc) {
        animals.add(Animal.fromSnapshot(doc));
      });
      completer.complete(animals);
    });
  }
  return completer.future;
}
