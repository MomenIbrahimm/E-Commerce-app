import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit.dart';
import 'package:shop_app/layout/layout_screen.dart';
import 'package:shop_app/layout/state.dart';
import 'package:shop_app/modules/animation.dart';
import 'package:shop_app/modules/cart_screen.dart';
import 'package:shop_app/share/components/components.dart';

class ProductDetails extends StatelessWidget {
  int currentIndex;

  ProductDetails({super.key, required this.currentIndex});

  var pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var model = ShopCubit.get(context).homeModel;
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {
        if (state is PostCartItemSuccess) {
          if (state.postCartModel.status == true) {
            final successSnackBar = snackBar(
                message: state.postCartModel.message,
                title: 'حسنا!',
                contentType: ContentType.success,
                seconds: 2);
            ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
          } else {
            final errorSnackBar = snackBar(
                message: state.postCartModel.message,
                title: 'حسنا!',
                contentType: ContentType.failure,
                seconds: 2);
            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.deepPurple),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(EvaIcons.arrowIosBackOutline)),
            actions: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(SlideAnimate(page: const CartScreen()));
                      },
                      icon: const Icon(EvaIcons.shoppingCart)))
            ],
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: defaultText(
                                text: model!.data!.products[currentIndex].name,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {
                                ShopCubit.get(context).changeFavourites(
                                    ShopCubit.get(context)
                                        .homeModel!
                                        .data!
                                        .products[currentIndex]
                                        .id);
                              },
                              icon: ShopCubit.get(context).favourites[
                                          ShopCubit.get(context)
                                              .homeModel!
                                              .data!
                                              .products[currentIndex]
                                              .id] ==
                                      true
                                  ? const Icon(
                                      EvaIcons.heart,
                                      color: Colors.deepPurple,
                                    )
                                  : const Icon(
                                      EvaIcons.heartOutline,
                                      color: Colors.deepPurple,
                                    ))
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (model.data!.products[currentIndex].discount != 0)
                        defaultText(
                            text:
                                'OFFER!  £ ${model.data!.products[currentIndex].price} instead of £ ${model.data!.products[currentIndex].oldPrice} ',
                            size: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      if (model.data!.products[currentIndex].discount == 0)
                        Center(
                          child: defaultText(
                              text:
                                  'EGP ${model.data!.products[currentIndex].oldPrice}'),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 20.0),
                        child:
                            Stack(alignment: Alignment.bottomLeft, children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20.0)),
                            width: double.infinity,
                            height: 300,
                            child: CarouselSlider(
                                items: model.data!.products[currentIndex].images
                                    .map((e) {
                                  return Image(
                                    image: NetworkImage(e),
                                    fit: BoxFit.cover,
                                  );
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
                                  autoPlayAnimationDuration:
                                      const Duration(seconds: 3),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.4,
                                  scrollDirection: Axis.horizontal,
                                )),
                          ),
                          if (model.data!.products[currentIndex].discount != 0)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  width: 85.0,
                                  height: 20.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: defaultText(
                                      text: 'discount',
                                      color: Colors.white,
                                    ),
                                  )),
                            )
                        ]),
                      ),
                      AnimatedCrossFade(
                          firstChild: defaultMaterialButton(
                            onPressed: () {
                              ShopCubit.get(context).addCart(
                                  model.data!.products[currentIndex].id);
                            },
                            text: 'أضف الي العربة',
                            high: 50.0,
                            width: 160.0,
                          ),
                          secondChild: defaultMaterialButton(
                            onPressed: () {
                              ShopCubit.get(context).addCart(
                                  model.data!.products[currentIndex].id);
                            },
                            text: 'قم بإزالته من العربة',
                            high: 50.0,
                            width: 160.0,
                          ),
                          crossFadeState: ShopCubit.get(context).listCarts[
                                      model.data!.products[currentIndex].id] ==
                                  false
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(seconds: 1)),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultText(
                          text: model.data!.products[currentIndex].description,
                          size: 14),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
