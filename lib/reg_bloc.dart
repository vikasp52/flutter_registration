
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:flutterassignment/reg_model.dart';

class RegistrationBloc{

  final BehaviorSubject<String> _skillListController = BehaviorSubject();
  Stream<String> get skillListStream => _skillListController.stream;
  Function(String) get skillListSink => _skillListController.sink.add;

  Future<String> _loadRegAsset() async {
    return await rootBundle.loadString('assets/sample_data.json');
  }

  Future<RegModel> loadData() async {
    String jsonString = await _loadRegAsset();

    print('jsonString: $jsonString');

    final jsonResponse = json.decode(jsonString);
    print('jsonResponse: $jsonResponse');

    RegModel regModel = RegModel.fromJson(jsonResponse);
    return regModel;
  }

  List<String> skillsList({String skill}){
    List<String> list = [];
    print('widget.list[i]: $skill');
    list.add(skill);
    return list;
  }

  void dispose(){
    _skillListController.close();
  }

}

RegistrationBloc registrationBloc = RegistrationBloc();