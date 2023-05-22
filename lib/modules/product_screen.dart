import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit.dart';
import 'package:shop_app/layout/state.dart';
import 'package:shop_app/model/home_model.dart';
import 'package:shop_app/modules/product_details.dart';
import '../share/components/components.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = ShopCubit.get(context).homeModel;
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {
        if(state is ChangeFavoriteDataSuccess){
          if(state.favouriteModel.status==false)
            {
            final  errorSnackBar = snackBar(
                  message: state.favouriteModel.message,
                  title: 'Ops!',
                  seconds: 2,
                  contentType: ContentType.failure);
              ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
            }else{
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.6,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(model!.data!.products.length,
                  (index) => buildProductItem(model, index, context)),
            ),
          ),
        );
      },
    );
  }
}

Widget buildProductItem(HomeModel model, index, context) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0), color: Colors.deepPurple[100]),
    child: Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Column(
          children: [
            SizedBox(
              height: 120.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Image(
                    image: NetworkImage('${model.data?.products[index].image}',),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Expanded(
                child: Text(
                  '${model.data?.products[index].name}',
                  style: const TextStyle(
                      fontSize: 14.0, color: Colors.black, height: 1.4),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Text(
                'EGP ${model.data?.products[index].oldPrice}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    decoration: model.data!.products[index].discount == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                    color: Colors.black),
              ),
            ),

            if (model.data!.products[index].discount != 0)
              defaultText(
                  text: '${model.data?.products[index].discount}% discount',
                  fontWeight: FontWeight.bold,
                  size: 15.0,
                  color: Colors.green),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:20.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        ShopCubit.get(context).changeFavourites(model.data!.products[index].id);
                      },
                      icon: ShopCubit.get(context).favourites[model.data!.products[index].id]==true?const Icon(
                        EvaIcons.star,
                        color: Colors.deepPurple,
                        size: 25.0,
                      ):const Icon(
                        EvaIcons.starOutline,
                        color: Colors.deepPurple,
                        size: 25.0,
                      )),

                  const Spacer(),

                  IconButton(
                      onPressed: () {
                        navigateTo(
                            context, ProductDetails(currentIndex: index));
                      },
                      icon: const Icon(
                        EvaIcons.moreHorizontalOutline,
                        size: 20.0,
                      ))
                ],
              ),
            )
          ],
        ),
        if (model.data!.products[index].discount != 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.red,
              ),
              width: 70.0,
              height: 19.0,
              child:
                  defaultText(text: ' discount%', color: Colors.white, size: 15.0),
            ),
          ),
      ],
    ),
  );
}
