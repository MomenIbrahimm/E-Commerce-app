import 'package:buildcondition/buildcondition.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            titleTextStyle: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
          ),
          body: BuildCondition(
            condition:ShopCubit.get(context).userModel != null ,
            builder:(context){
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
                        Center(
                          child: SizedBox(
                            width: 170,
                            height: 170,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                const CircleAvatar(
                                  radius: 85.0,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://scontent.fcai21-4.fna.fbcdn.net/v/t1.6435-9/173275350_3976522115731723_2630501664218342178_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=c-qwEbkOtL8AX9stnaH&_nc_ht=scontent.fcai21-4.fna&oh=00_AfAa944Py93zUvEyyDMyTWEqUBEchfOjqKeCppJlEQsmTg&oe=64475158'),
                                    radius: 80.0,
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 50.0,),
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

                        defaultMaterialButton(onPressed: () {
                          if(formKey.currentState!.validate())
                            {
                              ShopCubit.get(context).updateProfile(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text);
                            }
                        }, text: 'Save'),
                        if(state is UpdateProfileLoadingState)
                          const LinearProgressIndicator()
                      ],
                    ),
                  ),
                ),
              );
            },
            fallback: (context)=>const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
