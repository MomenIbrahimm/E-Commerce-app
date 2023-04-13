class SettingsModel{
  bool? status;
  DataSettingModel? data;

  SettingsModel.fromJson(Map<String,dynamic>json){
    status = json['status'];
    data = DataSettingModel.fromJson(json['data']);
  }
}

class DataSettingModel{
  String? about;
  String? terms;

  DataSettingModel.fromJson(Map<String,dynamic>json){
    about = json['about'];
    terms = json['terms'];
  }

}