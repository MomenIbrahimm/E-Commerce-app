import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/layout/cubit.dart';
import 'package:shop_app/layout/state.dart';
import 'package:shop_app/model/favorite/get_favorite_model.dart';
import 'package:shop_app/modules/product_details.dart';
import 'package:shop_app/share/components/components.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {
        if (state is ChangeFavoriteDataSuccess) {
          if (state.favouriteModel.status == false) {
            final errorSnackBar = snackBar(
                message: state.favouriteModel.message,
                title: 'Ops!',
                seconds: 2,
                contentType: ContentType.failure);
            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
          } else {
            final successSnackBar = snackBar(
                message: state.favouriteModel.message,
                contentType: ContentType.success,
                seconds: 1,
                title: 'Done!');
            ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: BuildCondition(
            condition: ShopCubit.get(context).favoriteModel != null,
            builder: (context) => ListView.builder(
              itemBuilder: (context, index) {
                return buildFavoriteItem(
                    ShopCubit.get(context).favoriteModel!.data!.data![index], context,index);
              },
              itemCount:
                  ShopCubit.get(context).favoriteModel!.data!.data!.length,
            ),
            fallback: (context) =>
                 Center(child: LottieBuilder.asset('assets/loader.json')),
          ),
        );
      },
    );
  }
}

buildFavoriteItem(model, context ,int index) {
  return SizedBox(
    width: double.infinity,
    height: 160.0,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Card(
            elevation: 2.5,
            shadowColor: Colors.deepPurple,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 150,
                height: 120.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            '${model.product!.image}'),)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${model.product!.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                          'EGP ${model.product!.oldPrice!}',
                          style: TextStyle(
                              decoration:
                                  model.product!.discount !=
                                          0
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                              color: Colors.black,
                              fontSize: 18.0)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (model.product!.discount != 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: defaultText(
                            text:
                                'discount ${model.product!.discount!}%',
                            color: Colors.green,
                            size: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              ShopCubit.get(context).changeFavourites(
                                  model.product!.id!);
                            },
                            icon: ShopCubit.get(context).favourites[
                                        model.product!.id] ==
                                    true
                                ? const Icon(
                                    EvaIcons.star,
                                    color: Colors.deepPurple,
                                    size: 22.5,
                                  )
                                : const Icon(
                                    EvaIcons.starOutline,
                                    color: Colors.deepPurple,
                                    size: 22.5,
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
                  ],
                ),
              )
            ]),
          ),
          if (model.product!.discount != 0)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.redAccent,
                ),
                height: 15,
                width: 60,
                child: defaultText(
                    text: ' SALE %', color: Colors.white, size: 15.0),
              ),
            )
        ],
      ),
    ),
  );
}
