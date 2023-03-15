class ContentsModel {
  String usercreate;
  String namegroup;
  String name;
  List listname;

  ContentsModel(
    this.usercreate,
    this.namegroup,
    this.name,
    this.listname,
  );

  ContentsModel.fromJson(Map<String, dynamic> json)
      : usercreate = json['usercreate'],
        namegroup = json['namegroup'] ?? '',
        name = json['name'] ?? '',
        listname = [];

  Map<String, dynamic> toJson() => {
        'USERCREATE': usercreate,
        'NAMEGROUP': namegroup,
        'NAME': name,
        'LISTNAMe': [],
      };
}
