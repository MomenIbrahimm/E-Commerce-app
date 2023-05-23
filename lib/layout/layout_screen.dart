import 'package:buildcondition/buildcondition.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/layout/cubit.dart';
import 'package:shop_app/layout/state.dart';
import 'package:shop_app/modules/update_screen.dart';
import '../modules/animation.dart';
import '../share/components/components.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.deepPurple),
            ),
            endDrawer: BuildCondition(
              condition: ShopCubit.get(context).settingsModel != null &&
                  ShopCubit.get(context).userModel != null,
              builder: (context) => Drawer(
                backgroundColor: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40.0,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultText(
                            text: ShopCubit.get(context).userModel!.data!.name!,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            size: 20.0),
                        const SizedBox(
                          height: 12.5,
                        ),
                        defaultText(
                            text:
                                ShopCubit.get(context).userModel!.data!.email!,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            size: 18.0),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(SlideAnimate(page: UpdateScreen()));
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.update,
                                    color: Colors.white, size: 30),
                                const SizedBox(
                                  width: 31.0,
                                ),
                                defaultText(
                                    text: 'Update profile', color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        // Row(
                        //   children: [
                        //     Switch(
                        //         value: ShopCubit.get(context).isSwitch,
                        //         onChanged: (value) {
                        //           CacheHelper.saveData(key: 'isDark', value: value).then((value){
                        //             ShopCubit.get(context).switchChange();
                        //           });
                        //         }),
                        //     const SizedBox(
                        //       width: 10.0,
                        //     ),
                        //     defaultText(text: 'Dark mode', color: Colors.white),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 10.0,
                        // ),
                        InkWell(
                          onTap: () {
                            signOut(context);
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8.0,
                              ),
                              const Icon(EvaIcons.logOut,
                                  color: Colors.white, size: 30),
                              const SizedBox(
                                width: 32.0,
                              ),
                              defaultText(text: 'Logout', color: Colors.white),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultText(
                            text:
                                'Terms: ${ShopCubit.get(context).settingsModel!.data!.terms!}',
                            color: Colors.white,
                            size: 14.0),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultText(
                            text:
                                'About: ${ShopCubit.get(context).settingsModel!.data!.about!}',
                            color: Colors.white,
                            size: 14.0),
                      ],
                    ),
                  ),
                ),
              ),
              fallback: (context) =>
                   Center(child:  Center(child: LottieBuilder.asset('assets/loader.json')),),
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(20.0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(EvaIcons.home),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(EvaIcons.shoppingBag),
                    label: 'المنتجات',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category),
                    label: 'الانواع',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(EvaIcons.star),
                    label: 'المفضل',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(EvaIcons.search),
                    label: 'البحث',
                  ),
                ],
                onTap: (index) {
                  ShopCubit.get(context).changeBottom(index);
                  print(ShopCubit.get(context).currentIndex);
                },
                currentIndex: ShopCubit.get(context).currentIndex,
              ),
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: BuildCondition(
                condition: ShopCubit.get(context).homeModel != null,
                builder: (context) => ShopCubit.get(context)
                    .screens[ShopCubit.get(context).currentIndex],
                fallback: (context) =>
                    Center(child:  Center(child: LottieBuilder.asset('assets/loader.json',height: 150.0,width: 150.0,)),),
              ),
            )
        );
      },
    );
  }
}
