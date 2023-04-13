import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/login_screen/login_screen.dart';
import 'package:shop_app/modules/register_screen/register_cubit.dart';
import 'package:shop_app/modules/register_screen/register_state.dart';
import 'package:shop_app/share/components/components.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var passController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
   late SnackBar successSnackBar;
   late SnackBar errorSnackBar;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, ShopRegisterState>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.registerModel.status!) {
              successSnackBar = snackBar(
                title: 'Done :)',
                  message: state.registerModel.message,
                  contentType: ContentType.success);
              ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
              navigateToAndFinish(context, LoginScreen());
            } else {
              errorSnackBar = snackBar(
                  message: state.registerModel.message,
                  title: 'Ops!',
                  contentType: ContentType.failure);
              ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
              print('Error');
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
                        height: 100,
                      ),
                      defaultText(text: 'Register', size: 30),
                      const SizedBox(
                        height: 10,
                      ),
                      const Icon(
                        EvaIcons.logIn,
                        size: 50,
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                        controller: nameController,
                        context: context,
                        keyBoardTyp: TextInputType.emailAddress,
                        text: 'name',
                        icon: const Icon(EvaIcons.person),
                        validateText: 'name field is empty',
                      ),
                      const SizedBox(
                        height: 10.0,
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
                        height: 10.0,
                      ),
                      defaultTextFormField(
                          controller: passController,
                          context: context,
                          keyBoardTyp: TextInputType.visiblePassword,
                          text: 'password',
                          obscure: RegisterCubit.get(context).isPassword,
                          onSubmitted: () {},
                          icon: const Icon(EvaIcons.lock),
                          validateText: 'password field is empty',
                          suffixIcon: IconButton(
                              onPressed: () {
                                RegisterCubit.get(context).isChange();
                              },
                              icon: Icon(RegisterCubit.get(context).suffix))),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultTextFormField(
                        controller: phoneController,
                        context: context,
                        keyBoardTyp: TextInputType.phone,
                        text: 'phone',
                        onSubmitted: () {},
                        icon: const Icon(EvaIcons.phone),
                        validateText: 'phone field is empty',
                      ),
                      defaultMaterialButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              RegisterCubit.get(context).registerUser(
                                email: emailController.text,
                                password: passController.text,
                                name: nameController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                          text: 'Register',
                          context: context,
                          width: 180),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          defaultText(
                              text: 'Already have an account?', size: 14.0),
                          defaultTextButton(
                              onPressed: () {
                                navigateTo(context, LoginScreen());
                              },
                              text: 'Sign in',
                              fontWeight: FontWeight.bold)
                        ],
                      )
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
