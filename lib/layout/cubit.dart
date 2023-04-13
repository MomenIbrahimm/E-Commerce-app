import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/state.dart';
import 'package:shop_app/model/category_model.dart';
import 'package:shop_app/model/change_cart_model.dart';
import 'package:shop_app/model/favorite/change_favorite_model.dart';
import 'package:shop_app/model/favorite/get_favorite_model.dart';
import 'package:shop_app/model/get_carts_model.dart';
import 'package:shop_app/model/login_model.dart';
import 'package:shop_app/model/settings_model.dart';
import 'package:shop_app/modules/category_screen.dart';
import 'package:shop_app/modules/favourite_screen.dart';
import 'package:shop_app/modules/home_screen.dart';
import 'package:shop_app/modules/product_screen.dart';
import 'package:shop_app/share/network/end_points.dart';
import 'package:shop_app/share/network/remote/dio_helper.dart';
import 'package:shop_app/share/style/const.dart';
import '../model/home_model.dart';
import '../modules/search_screen/search_screen.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int counter = 1;

  void increaseCounter() {
    counter++;
    emit(IncreaseCounter());
  }

  void decreaseCounter() {
    if (counter != 1) {
      counter--;
    } else {
      counter = 1;
    }
    emit(DecreaseCounter());
  }

  bool isSwitch=false;
  void switchChange({bool? fromShared}){
    if(fromShared != null)
      {
        isSwitch = fromShared;
      }else{
      isSwitch =!isSwitch;
    }
    emit(SwitchChanged());
  }

  void changeBottom(index) {
    currentIndex = index;
    emit(ChangeBottomNav());
  }

  List<Widget> screens =[
    const HomeScreen(),
    const ProductScreen(),
    const CategoryScreen(),
    const FavouriteScreen(),
    SearchScreen(),
  ];

  LoginModel? userModel;

  getProfileData() {
    emit(GetProfileDataLoading());

    DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(GetProfileDataSuccess(userModel!));
    }).catchError((error){
      emit(GetProfileDataError(error.toString()));
    });
  }

  HomeModel? homeModel;

  Map<int, bool> favourites = {};

  Map<int, bool> listCarts = {};

  getHomeData() {
    emit(GetHomeDataLoading());

    DioHelper.getData(url: home, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      //list of favorite
      for (var element in homeModel!.data!.products) {
        favourites.addAll({
          element.id: element.inFavorites,
        });
      }
      // print(favourites.toString()); //list of carts
      for (var element in homeModel!.data!.products) {
        listCarts.addAll({
          element.id: element.inCart,
        });
      }
      emit(GetHomeDataSuccess());
    }).catchError((error) {
      emit(GetHomeDataError(error.toString()));
      print(error.toString());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavourites(int productId) {
    favourites[productId] = !favourites[productId]!;
    emit(ChangeFavoriteIcon());

    DioHelper.postData(
      url: favorites,
      token: token,
      data: {'product_id': productId},
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (changeFavoritesModel!.status == false) {
        favourites[productId] = !favourites[productId]!;
      }
      {
        getFavoriteData();
      }
      emit(ChangeFavoriteDataSuccess(changeFavoritesModel!));
    }).catchError((error) {
      favourites[productId] = !favourites[productId]!;
      emit(AddFavoriteDataError(error.toString()));
      print(error.toString());
    });
  }

  FavoriteModel? favoriteModel;

  void getFavoriteData() {
    emit(GetFavoriteDataLoading());

    DioHelper.getData(
      url: favorites,
      token: token,
    ).then((value) {
      favoriteModel = FavoriteModel.fromJson(value.data);
      emit(GetFavoriteDataSuccess());
    }).catchError((error) {
      emit(GetFavoriteDataError(error.toString()));
      print(error.toString());
    });
  }

  CategoryModel? categoryModel;

  getCategoriesData() {
    emit(GetCategoriesDataLoading());

    DioHelper.getData(url: categories, token: token).then((value) {
      categoryModel = CategoryModel.fromJson(value.data);
      emit(GetCategoriesDataSuccess());
      print(categoryModel!.status);
    }).catchError((error) {
      emit(GetCategoriesDataError(error.toString()));
    });
  }

  SettingsModel? settingsModel;

  getDataSetting() {
    DioHelper.getData(
      url: settings,
      token: token,
    ).then((value) {
      settingsModel = SettingsModel.fromJson(value.data);
      print(settingsModel!.data!.terms!.toString());
      emit(GetSettingsDataSuccess());
    }).catchError((error) {
      emit(GetSettingsDataError(error.toString()));
    });
  }

  PostCartModel? postCartModel;

 void addCart(productId) {

    listCarts[productId] = !listCarts[productId]!;

    emit(ChangePostIcon());

    DioHelper.postData(url: CARTS, token: token, data: {
      'product_id': productId,
    }).then((value) {
      postCartModel = PostCartModel.fromJson(value.data);
      print(postCartModel!.message);
      if (postCartModel!.status == false) {
        listCarts[productId] = !listCarts[productId]!;
      } else {
        getCartsData();
        emit(PostCartItemSuccess(postCartModel!));
      }

    }).catchError((error) {
      listCarts[productId] = !listCarts[productId]!;
      emit(PostCartItemError(error.toString()));
      print(error.toString());
    });
  }

  GetCartsModel? getCartsModel;

  void getCartsData() {
    emit(GetCartsDataLoading());

    DioHelper.getData(
      url: CARTS,
      token: token,
    ).then((value) {
      getCartsModel = GetCartsModel.fromJson(value.data);
      print(getCartsModel!.data!.total!);
      emit(GetCartsDataSuccess());
    }).catchError((error) {
      emit(GetCartsDataError(error.toString()));
      print(error.toString());
    });
  }

 void updateProfile({
    required String  name,
    required String phone,
    required String email,
  }) {

    emit(UpdateProfileLoadingState());

    DioHelper.putData(url: update, token: token, data: {
      'name': name,
      'phone': phone,
      'email': email,
    }).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(UpdateProfileSuccessState());
      print(userModel!.data!.name);
      print('Data saved');
    }).catchError((error) {
      emit(UpdateProfileErrorState());
      print(error.toString());
    });
  }
}
