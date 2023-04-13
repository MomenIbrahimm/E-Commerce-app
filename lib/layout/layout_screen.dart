import 'package:buildcondition/buildcondition.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit.dart';
import 'package:shop_app/layout/state.dart';
import 'package:shop_app/modules/update_screen.dart';
import 'package:shop_app/share/network/remote/cach_helper.dart';
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
            drawer: BuildCondition(
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
                          height: 50.0,
                        ),
                        Container(
                          width: 130.0,
                          height: 130.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            image: const DecorationImage(
                                image: NetworkImage(
                                    'https://scontent.fcai21-4.fna.fbcdn.net/v/t1.6435-9/173275350_3976522115731723_2630501664218342178_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=BNyIQx2oKucAX8P7T3g&_nc_ht=scontent.fcai21-4.fna&oh=00_AfAY5WgjnNPzhhTR2Bc_MG2hMcGdshVsNVdlHqGMkau3jQ&oe=64463818'),
                                fit: BoxFit.cover),
                          ),
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
                              navigateTo(context, UpdateScreen());
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
                        Row(
                          children: [
                            Switch(
                                value: ShopCubit.get(context).isSwitch,
                                onChanged: (value) {
                                  CacheHelper.saveData(key: 'isDark', value: value).then((value){
                                    ShopCubit.get(context).switchChange();
                                  });
                                }),
                            const SizedBox(
                              width: 10.0,
                            ),
                            defaultText(text: 'Dark mode', color: Colors.white),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
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
                  const Center(child: CircularProgressIndicator()),
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
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(EvaIcons.shoppingBag),
                    label: 'Products',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category),
                    label: 'Category',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(EvaIcons.star),
                    label: 'Favorite',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(EvaIcons.search),
                    label: 'Search',
                  ),
                ],
                onTap: (index) {
                  ShopCubit.get(context).changeBottom(index);
                  print(ShopCubit.get(context).currentIndex);
                },
                currentIndex: ShopCubit.get(context).currentIndex,
              ),
            ),
            body: BuildCondition(
              condition: ShopCubit.get(context).homeModel != null,
              builder: (context) => ShopCubit.get(context)
                  .screens[ShopCubit.get(context).currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ));
      },
    );
  }
}
