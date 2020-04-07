class RegModel {
  final List<DataModel> data;

  RegModel({this.data});

  factory RegModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;

    List<DataModel> detailsList =
        list.map((i) => DataModel.fromJson(i)).toList();

    return RegModel(data: detailsList);
  }
}

class DataModel {
  final String headingName;
  final List<Details> details;

  DataModel({this.headingName, this.details});

  factory DataModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['details'] as List;

    List<Details> detailsList = list.map((i) => Details.fromJson(i)).toList();

    return DataModel(
        headingName: parsedJson['heading_name'], details: detailsList);
  }
}

class Details {
  final String subTitle;
  final String type;
  final List<String> option;

  Details({this.subTitle, this.type, this.option});

  factory Details.fromJson(Map<String, dynamic> parsedJson) {
    var optionsFromJson = parsedJson['option'];
    List<String> optionsList = new List<String>.from(optionsFromJson);

    return Details(
        subTitle: parsedJson['sub_title'],
        type: parsedJson['type'],
        option: optionsList);
  }
}
