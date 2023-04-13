import 'package:shop_app/model/login_model.dart';

abstract class ShopLoginState{}

class InitialLoginState extends ShopLoginState{}

class ShowPassState extends ShopLoginState{}

class ShopLoginLoadingState extends ShopLoginState{}

class ShopLoginSuccessState extends ShopLoginState{
  final LoginModel loginModel;
  ShopLoginSuccessState(this.loginModel);
}

class ShopLoginErrorState extends ShopLoginState{
  final String error;
  ShopLoginErrorState(this.error);

}

