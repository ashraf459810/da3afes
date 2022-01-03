import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../extensions.dart';

class ContactUsBlocBloc extends Bloc<ContactUsBlocEvent, ContactUsBlocState> {
  @override
  ContactUsBlocState get initialState => InitialContactUsBlocState();

  @override
  Stream<ContactUsBlocState> mapEventToState(
    ContactUsBlocEvent event,
  ) async* {
    if (event is LoadMakes) {
      var makes = await getMakes(event.id);
      yield MakesLoaded(makes);
    }
  }
}

@immutable
abstract class ContactUsBlocEvent extends Equatable {}

class LoadMakes extends ContactUsBlocEvent {
  String id;
  LoadMakes(this.id);
  @override
  List<Object> get props => [this.id];
}

Future<Map<String, String>> getMakes(String id) async {
  Map<String, String> map = {};

  print("triggers");
  await Future.forEach(kakma.entries, (element) {
    MapEntry<String, String> item = element;
    if (item.value == id) {
      print("triggers");

      var model_name = moodel[item.key];
      map[item.key] = model_name;
    }
  });
//  map.removeWhere((key, value) => key == "79");
  print("result is" + map.toString());

  return map;
//  await kakma.forEach((key, value)
//  {
//    if (value == "id") {
//      var model_id = makes[key];
//      map[model_id] = key;
//    }
//  });
}

@immutable
abstract class ContactUsBlocState extends Equatable {}

class InitialContactUsBlocState extends ContactUsBlocState {
  @override
  List<Object> get props => [];
}

class MakesLoaded extends ContactUsBlocState {
  final Map<String, String> makes;

  MakesLoaded(this.makes);

  @override
  List<Object> get props => [this.makes];
}
