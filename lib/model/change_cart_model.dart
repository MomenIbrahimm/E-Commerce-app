class PostCartModel{
  bool? status ;
  String? message ;

  PostCartModel.fromJson(Map<String,dynamic>json){
    status = json['status'];
    message = json['message'];
  }
}