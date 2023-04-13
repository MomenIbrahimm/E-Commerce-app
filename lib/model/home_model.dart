class HomeModel {
   bool? status;
   HomeDataModel? data;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel {

  List<BannersModel> banners=[];
  List<ProductModel> products=[];

  HomeDataModel.fromJson(Map<String,dynamic> json){
     json['banners'].forEach((element){
       banners.add(BannersModel.fromJson(element));
     });

     json['products'].forEach((element){
       products.add(ProductModel.fromJson(element));
     });
  }
}

class BannersModel {
   int? id;
   String? image;

  BannersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class ProductModel {

   late int id;
   late dynamic price;
   late dynamic oldPrice;
   late dynamic discount;
   late String image;
   late String name;
   late String description;
   late bool inFavorites;
   late bool inCart;
   late List images =[];

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
    json['images'].forEach((element){
      images.add(element);
    });
  }
}
