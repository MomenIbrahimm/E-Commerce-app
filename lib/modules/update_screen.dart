import 'dart:math';

import 'package:buildcondition/buildcondition.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../layout/cubit.dart';
import '../layout/state.dart';
import '../share/components/components.dart';

class UpdateScreen extends StatelessWidget {
  UpdateScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            toolbarHeight: 50.0,
            titleTextStyle: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  EvaIcons.arrowIosBackOutline,
                  color: Colors.deepPurple,
                )),
          ),
          body: BuildCondition(
            condition: ShopCubit.get(context).userModel != null,
            builder: (context) {
              var model = ShopCubit.get(context).userModel!;
              emailController.text = model.data!.email!;
              nameController.text = model.data!.name!;
              phoneController.text = model.data!.phone!;
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Transform(
                            transform: Matrix4.rotationZ(pi * 4)
                              ..scale(1.0)
                              ..translate(0.0),
                            child: LottieBuilder.asset(
                              'assets/update.json',
                              height: 250.0,
                            )),
                        defaultTextFormField(
                          controller: nameController,
                          context: context,
                          keyBoardTyp: TextInputType.text,
                          text: 'Name',
                          icon: const Icon(EvaIcons.person),
                          validateText: 'name field is empty',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultTextFormField(
                          controller: phoneController,
                          context: context,
                          keyBoardTyp: TextInputType.phone,
                          text: 'Phone',
                          icon: const Icon(EvaIcons.phone),
                          validateText: 'phone field is empty',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultTextFormField(
                          controller: emailController,
                          context: context,
                          keyBoardTyp: TextInputType.emailAddress,
                          text: 'Email',
                          icon: const Icon(EvaIcons.email),
                          validateText: 'email field is empty',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultMaterialButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                ShopCubit.get(context).updateProfile(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    email: emailController.text);
                              }
                            },
                            text: 'Save'),
                        if (state is UpdateProfileLoadingState)
                          const LinearProgressIndicator(),
                        AnimatedContainer(
                          width: ShopCubit.get(context).containerWidth,
                            height:  ShopCubit.get(context).containerHeight,
                            duration: const Duration(seconds: 1),
                            child: GestureDetector(
                              onTap: (){
                                ShopCubit.get(context).changeContainer();
                              },
                              child: const Image(
                                  image: NetworkImage(
                                      'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aHVtYW58ZW58MHx8MHx8fDA%3D&w=1000&q=80')),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
