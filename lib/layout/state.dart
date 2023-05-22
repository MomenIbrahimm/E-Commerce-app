import 'package:shop_app/model/change_cart_model.dart';
import '../model/favorite/change_favorite_model.dart';
import '../model/login_model.dart';

abstract class ShopState{}

class ShopInitialState extends ShopState{}

class ChangeBottomNav extends ShopState{}

class IncreaseCounter extends ShopState{}

class DecreaseCounter extends ShopState{}

class ChangeAnimatedState extends ShopState{}

// class SliderState extends ShopState{}

class SwitchChanged extends ShopState{}

class ShopLoginLoadingState extends ShopState{}

class ShopLoginSuccessState extends ShopState{
  final LoginModel loginModel;
  ShopLoginSuccessState(this.loginModel);
}

class ShopLoginErrorState extends ShopState{
  final String error;
  ShopLoginErrorState(this.error);

}

class GetHomeDataLoading extends ShopState{}

class GetHomeDataSuccess extends ShopState{

}

class GetHomeDataError extends ShopState{
  final String error;

  GetHomeDataError(this.error);
}

class GetCategoriesDataLoading extends ShopState{}

class GetCategoriesDataSuccess extends ShopState{}

class GetCategoriesDataError extends ShopState{
  final String error;

  GetCategoriesDataError(this.error);
}

class ChangeFavoriteIcon extends ShopState{}

class PostCartItemSuccess extends ShopState{
  final PostCartModel postCartModel;

  PostCartItemSuccess(this.postCartModel);

}
class ChangePostIcon extends ShopState{}

class PostCartItemError extends ShopState{
  final String error;

  PostCartItemError(this.error);
}

class ChangeFavoriteDataSuccess extends ShopState{
  final ChangeFavoritesModel favouriteModel;

  ChangeFavoriteDataSuccess(this.favouriteModel);

}

class AddFavoriteDataError extends ShopState{
  final String error;

  AddFavoriteDataError(this.error);
}

class GetFavoriteDataLoading extends ShopState{}

class GetFavoriteDataSuccess extends ShopState{}

class GetFavoriteDataError extends ShopState{
  final String error;

  GetFavoriteDataError(this.error);
}

class GetSettingsDataLoading extends ShopState{}

class GetSettingsDataSuccess extends ShopState{}

class GetSettingsDataError extends ShopState{
  final String error;

  GetSettingsDataError(this.error);
}

class GetCartsDataLoading extends ShopState{}

class GetCartsDataSuccess extends ShopState{}

class GetCartsDataError extends ShopState{
  final String error;

  GetCartsDataError(this.error);
}

class GetProfileDataLoading extends ShopState{}

class GetProfileDataSuccess extends ShopState{
  final LoginModel userModel;

  GetProfileDataSuccess(this.userModel);
}

class GetProfileDataError extends ShopState{
  final String error;

  GetProfileDataError(this.error);
}

class UpdateProfileLoadingState extends ShopState{}
class UpdateProfileSuccessState extends ShopState{}
class UpdateProfileErrorState extends ShopState{}

class IsSwitchCheckState extends ShopState{}
