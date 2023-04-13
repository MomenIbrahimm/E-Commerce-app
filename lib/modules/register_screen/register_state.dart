import 'package:shop_app/model/login_model.dart';

abstract class ShopRegisterState{}

class InitialRegisterState extends ShopRegisterState{}

class ShowPassState extends ShopRegisterState{}

class ShopRegisterLoadingState extends ShopRegisterState{}

class ShopRegisterSuccessState extends ShopRegisterState{
  final LoginModel registerModel;

  ShopRegisterSuccessState(this.registerModel);
}

class ShopRegisterErrorState extends ShopRegisterState{
  final String error;
  ShopRegisterErrorState(this.error);

}