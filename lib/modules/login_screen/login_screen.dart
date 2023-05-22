import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/layout/layout_screen.dart';
import 'package:shop_app/modules/animation.dart';
import 'package:shop_app/modules/finger_print.dart';
import 'package:shop_app/modules/register_screen/register_screen.dart';
import 'package:shop_app/share/components/components.dart';
import 'package:shop_app/modules/login_screen/login_cubit.dart';
import 'package:shop_app/modules/login_screen/login_state.dart';
import 'package:shop_app/share/network/remote/cach_helper.dart';
import 'package:shop_app/share/style/const.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var passController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  late SnackBar successSnackBar;
  late SnackBar errorSnackBar;
  String fPrint = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginState>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status == true) {
              print(state.loginModel.data!.token);
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {

                token = state.loginModel.data!.token!;
                Navigator.of(context)
                    .pushAndRemoveUntil(SlideAnimate(page: const LayoutScreen()),(route) => false,);

                successSnackBar = snackBar(
                    message: state.loginModel.message,
                    contentType: ContentType.success,
                    title: 'Okey');
                ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
              });
            } else {
              print('some error');
              errorSnackBar = snackBar(
                  message: state.loginModel.message,
                  title: 'Ops!',
                  contentType: ContentType.failure);
              ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100.0,
                      ),

                      defaultText(
                        text: 'User Login',
                        size: 30,
                      ),

                      Lottie.asset(
                        'assets/login.json',
                        height: 170.0,
                        width: double.infinity,
                      ),

                      defaultTextFormField(
                        controller: emailController,
                        context: context,
                        keyBoardTyp: TextInputType.emailAddress,
                        text: 'email address',
                        icon: const Icon(EvaIcons.email),
                        validateText: 'email field is empty',
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      defaultTextFormField(
                        controller: passController,
                        context: context,
                        keyBoardTyp: TextInputType.visiblePassword,
                        text: 'password',
                        obscure: ShopLoginCubit.get(context).isPassword,
                        icon: const Icon(EvaIcons.lock),
                        validateText: 'password field is empty',
                        suffixIcon: IconButton(
                            onPressed: () {
                              ShopLoginCubit.get(context).isChange();
                            },
                            icon: Icon(ShopLoginCubit.get(context).suffix)),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: state is ShopLoginLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : defaultMaterialButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passController.text,
                                    );
                                  }
                                },
                                text: 'LOGIN',
                                context: context,
                                width: 180),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: defaultMaterialButton(
                            onPressed: () async {
                              final isAuthenticated =
                                  await LocalAuthApi.authenticate();
                              if (isAuthenticated) {
                                Navigator.of(context).push(
                                    SlideAnimate(page: const LayoutScreen()));
                              }
                            },
                            text: 'Login With FingerPrint',
                            width: 200),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          defaultText(
                              text: 'don\'t have an account?', size: 14.0),
                          defaultTextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              text: 'Register',
                              fontWeight: FontWeight.bold,
                              size: 17.0)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
