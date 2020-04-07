import 'package:flutter/material.dart';
import 'package:flutterassignment/reg_bloc.dart';
import 'package:flutterassignment/reg_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<TextEditingController> textEditingController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int selectedRadio;
  String _selectedGender = '';
  DateTime selectedDate = DateTime.now();
  String _selectedProfile;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1980, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    registrationBloc = RegistrationBloc();

    registrationBloc.loadData();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildPopUp(
        {String name,
        String email,
        String address,
        String gender,
        String dob,
        List<String> skills,
        String profile}) {
      _buildRowStructure({String key, String value}) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text('$key:', style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
                flex: 3,
              ),
              Expanded(
                child: Text(value),
                flex: 7,
              ),
            ],
          ),
        );
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Details',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildRowStructure(key: 'Name', value: name),
                  _buildRowStructure(key: 'Email', value: email),
                  _buildRowStructure(key: 'Address', value: address),
                  _buildRowStructure(key: 'Gender', value: _selectedGender),
                  _buildRowStructure(key: 'DOB', value: dob),
                  _buildRowStructure(key: 'Skills', value: skills.toString()),
                  _buildRowStructure(key: 'Profile', value: profile),
                ],
              ),
            );
          });
      return SizedBox();
    }

    setSelectedRadio({int val, String selectedGender}) {
      setState(() {
        selectedRadio = val;
        _selectedGender = selectedGender;
      });
    }

    Widget _buildTextField(
        {String label, TextEditingController textEditingController}) {
      return TextField(
        controller: textEditingController,
        onChanged: (val) {},
        decoration: InputDecoration(labelText: label),
      );
    }

    Widget _buildRadioButton({List<String> labelList, String label}) {
      var widgetList = List<Widget>();

      labelList.asMap().forEach((index, data) {
        Widget radio = RadioListTile(
          value: index,
          groupValue: selectedRadio,
          title: Text(labelList[index]),
          onChanged: (val) {
            print("Radio $val");
            setSelectedRadio(val: val, selectedGender: labelList[val]);
          },
          activeColor: Colors.green,
        );
        widgetList.add(radio);
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              label,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Column(children: widgetList),
        ],
      );
    }

    Widget _buildDatePicker({String label}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            onPressed: () => _selectDate(context),
            child: Text(label),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text("${selectedDate.toLocal()}".split(' ')[0]),
        ],
      );
    }

    Widget _buildDropDown(
        {String title, String label, List<String> dropdownList}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: DropdownButton<String>(
              hint: Text(label),
              value: _selectedProfile,
              items: dropdownList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedProfile = newValue;
                });
              },
            ),
          ),
        ],
      );
    }

    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
            future: registrationBloc.loadData(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                RegModel regModel = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                      itemCount: regModel.data.length,
                      itemBuilder: (_, index) {
                        if (regModel.data[index].details[0].type ==
                            'free_text') {
                          String _label = regModel.data[index].headingName;
                          //var textEditing = TextEditingController();
                          return _buildTextField(
                              textEditingController:
                                  textEditingController[index],
                              label: _label);
                        }

                        if (regModel.data[index].details[0].type == 'radio') {
                          return _buildRadioButton(
                              label:
                                  regModel.data[index].headingName.toString(),
                              labelList:
                                  regModel.data[index].details[0].option);
                        }

                        if (regModel.data[index].details[0].type ==
                            'datepicker') {
                          return _buildDatePicker(
                              label: regModel.data[index].details[0].subTitle);
                        }
                        //_buildCheckBoxWidget

                        if (regModel.data[index].details[0].type ==
                            'checkbox') {
                          return CheckBoxWidget(
                              label: regModel.data[index].details[0].subTitle,
                              list: regModel.data[index].details[0].option);
                        }
                        return _buildDropDown(
                          title: regModel.data[index].headingName.toString(),
                          label: regModel.data[index].details[0].subTitle,
                          dropdownList: regModel.data[index].details[0].option,
                        );
                      }),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        MaterialButton(
          onPressed: () {
            print('Skills: ${registrationBloc.skillsList()}');
            List<String> skills = [];


            registrationBloc.skillListStream.listen((val){
              print('val: $val');
              skills.add(val);
            });
            _buildPopUp(
                name: textEditingController[0].text??'',
                email: textEditingController[1].text??'',
                address: textEditingController[2].text??'',
                dob:
                '${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}',
                gender: _selectedGender??'',
                profile: _selectedProfile??'',
                skills: ['Android', 'iOS']);

            print('skills: ${skills.toString()}');

          },
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50.0,
            ),
            child: Text(
              'SAVE',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

class CheckBoxWidget extends StatefulWidget {
  final String label;
  final List<String> list;

  CheckBoxWidget({this.label, this.list});

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  var _checkList;

  @override
  void initState() {
    super.initState();
    _checkList = List.generate(widget.list.length, (i) => false);
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildCheckBoxWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              widget.label,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
              children: List.generate(
                  widget.list.length,
                  (i) => CheckboxListTile(
                        title: Text(widget.list[i]),
                        value: _checkList[i],
                        onChanged: (bool value) => setState(() {
                          _checkList[i] = value;
                          if (value) {
                            registrationBloc.skillListSink(widget.list[i]);
                          }
                        }),
                      )).toList()),
        ],
      );
    }

    return _buildCheckBoxWidget();
  }
}
