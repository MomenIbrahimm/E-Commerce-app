import 'package:bloc/bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/model/login_model.dart';
import 'package:shop_app/modules/register_screen/register_state.dart';
import 'package:shop_app/share/network/end_points.dart';
import 'package:shop_app/share/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<ShopRegisterState> {
  RegisterCubit() :super(InitialRegisterState());

  static RegisterCubit get(context) => BlocProvider.of(context);


  LoginModel? registerModel ;

  bool isPassword = true;
  IconData suffix = EvaIcons.eye;

  void isChange() {
    isPassword = !isPassword;
    isPassword ? suffix = EvaIcons.eye : suffix = EvaIcons.eyeOff;
    emit(ShowPassState());
  }

  void registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
}) {
    emit(ShopRegisterLoadingState());

    DioHelper.postData(
        url: register,
        data: {
          'email':email,
          'name':name,
          'phone':phone,
          'password':password,
        }
    ).then((value){
      registerModel = LoginModel.fromJson(value.data);
      // print(registerModel!.data!.name);
      emit(ShopRegisterSuccessState(registerModel!));
    }).catchError((error){
      print(error.toString());
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

}