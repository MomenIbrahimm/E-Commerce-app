import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/model/login_model.dart';
import 'package:shop_app/modules/login_screen/login_screen.dart';
import 'package:shop_app/modules/login_screen/login_state.dart';
import 'package:shop_app/share/network/end_points.dart';
import 'package:shop_app/share/network/remote/dio_helper.dart';
import '../../share/components/components.dart';
import '../../share/network/remote/cach_helper.dart';
import '../../share/style/const.dart';

class ShopLoginCubit extends Cubit<ShopLoginState>{
  ShopLoginCubit() : super (InitialLoginState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

 bool isPassword = true;
 IconData suffix = EvaIcons.eye;

  void isChange(){
    isPassword =!isPassword;
    isPassword?suffix=EvaIcons.eye:suffix=EvaIcons.eyeOff;
    emit(ShowPassState());
  }

  void removeData(context){
    CacheHelper.removeData(key:'token').then((value){
      navigateToAndFinish(context, LoginScreen());
    });
  }

  void userLogin({
   required String email,
   required String password,
}){
    emit(ShopLoginLoadingState());
    DioHelper.postData(
        url: login,
        data: {
          'email' : email,
          'password' : password,
        },
    ).then((value){
      loginModel= LoginModel.fromJson(value.data);
      print(loginModel!.status);
      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error){
      print(error.toString());
      emit(ShopLoginErrorState(error.toString()));
    });
  }

}