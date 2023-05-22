import 'package:buildcondition/buildcondition.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit.dart';
import 'package:shop_app/layout/state.dart';
import 'package:shop_app/model/home_model.dart';
import 'package:shop_app/model/login_model.dart';
import 'package:shop_app/modules/cart_screen.dart';
import 'package:shop_app/modules/product_details.dart';

import 'package:shop_app/share/components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {
        if (state is GetProfileDataSuccess) {
          if (state.userModel.data != null) {
            ShopCubit.get(context).getProfileData();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            child: BuildCondition(
              condition: ShopCubit.get(context).homeModel != null &&
                  ShopCubit.get(context).userModel != null,
              builder: (context) => homeBuilder(
                  ShopCubit.get(context).homeModel!,
                  context,
                  ShopCubit.get(context).userModel!),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }

  Widget homeBuilder(HomeModel model, context, LoginModel loginModel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              defaultText(
                text: 'Hi!',
                size: 20.0,
                fontWeight: FontWeight.w500,
              ),
              const Spacer(),
              CircleAvatar(
                radius: 20.5,
                backgroundColor: Colors.deepPurple,
                child: IconButton(
                    onPressed: () {
                      navigateTo(context, const CartScreen());
                    },
                    icon: const Icon(
                      EvaIcons.shoppingCartOutline,
                      size: 25.0,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          defaultText(
              text: 'Show new Banners',
              size: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            width: double.infinity,
            child: CarouselSlider(
                items: model.data!.banners.map((e) {
                  return Image(
                      image: e.image != null
                          ? NetworkImage(e.image!)
                          : const NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png'));
                }).toList(),
                options: CarouselOptions(
                  height: 180,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.9,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.4,
                  scrollDirection: Axis.horizontal,
                )),
          ),
          const SizedBox(
            height: 20.0,
          ),
          defaultText(
              text: 'Best Selling', size: 20.0, fontWeight: FontWeight.bold),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 380.0,
            child: ListView.separated(
              itemBuilder: (context, index) => Container(
                width: 150,
                height: 220.0,
                color: Colors.grey[200],
                child: Stack(alignment: Alignment.bottomLeft, children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 40.0,
                      ),
                      Image(
                        image: model.data?.products[index].image != null
                            ? NetworkImage(
                                '${model.data?.products[index].image}')
                            : const NetworkImage(''),
                        fit: BoxFit.contain,
                        height: 150,
                        width: 200,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          '${model.data?.products[index].name}',
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 11.5,
                      ),
                      Text(
                        '£ ${model.data?.products[index].oldPrice}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            decoration:
                                model.data!.products[index].discount != 0
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      if (model.data!.products[index].discount != 0)
                        defaultText(
                            text: '£ ${model.data?.products[index].price}',
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            size: 15.0),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  ShopCubit.get(context).changeFavourites(
                                      model.data!.products[index].id);
                                },
                                icon: ShopCubit.get(context).favourites[
                                            model.data!.products[index].id] ==
                                        true
                                    ? const Icon(
                                        EvaIcons.star,
                                        size: 22.5,
                                        color: Colors.deepPurple,
                                      )
                                    : const Icon(
                                        EvaIcons.starOutline,
                                        size: 22.5,
                                        color: Colors.deepPurple,
                                      )),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  navigateTo(
                                      context,
                                      ProductDetails(
                                        currentIndex: index,
                                      ));
                                },
                                icon: const Icon(
                                  EvaIcons.moreVertical,
                                  size: 20.0,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  if (model.data!.products[index].discount != 0)
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15.0)),
                      width: 70.0,
                      height: 18.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: defaultText(
                            text: 'discount%', color: Colors.white, size: 15.0),
                      ),
                    ),
                ]),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                width: 15.0,
              ),
              itemCount: 5,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
