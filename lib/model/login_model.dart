class LoginModel {
   bool? status;
   String? message;
   UserData? data;

  LoginModel.fromJson(json){
    status = json['status'];
    message = json['message'];
    data = json['data'] == null ? null: UserData.fromJson(json['data']);
  }

}

class UserData {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? token;
  int? points;
  int? credit;

  UserData.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    token = json['token'];
    image = json['image'];
    credit = json['credit'];
    points = json['points'];
  }
}