import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit.dart';
import 'package:shop_app/layout/state.dart';
import 'package:shop_app/model/get_carts_model.dart';
import '../share/components/components.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {
        if (state is PostCartItemSuccess) {
          if (state.postCartModel.status == true) {
            final successSnackBar = snackBar(
                message: state.postCartModel.message,
                title: 'Done!',
                contentType: ContentType.success,
                seconds: 2);
            ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
          }else{
            final errorSnackBar = snackBar(
                message: state.postCartModel.message,
                title: 'Done!',
                contentType: ContentType.failure,
                seconds: 2);
            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
          }
        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.deepPurple),
            title: const Text(
              'My Cart',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          body: BuildCondition(
            condition: ShopCubit.get(context).getCartsModel != null,
            builder: (context) => Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return buildCartItem(
                            ShopCubit.get(context)
                                .getCartsModel!
                                .data!
                                .cartItems![index],
                            context,index);
                      },
                      itemCount: ShopCubit.get(context)
                          .getCartsModel!
                          .data!
                          .cartItems!
                          .length),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(color: Colors.black,thickness: 1.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultText(text: 'Subtotal: EGP ${(ShopCubit.get(context).getCartsModel!.data!.subTotal).round()}',size: 16.0,fontWeight: FontWeight.bold),
                ),
              ],
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

buildCartItem(CartItems model, context,currentIndex) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        elevation: 2.5,
        shadowColor: Colors.deepPurple,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 150,
            height: 120.0,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage('${model.product!.image}'),
            )),
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

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('£ ${model.product!.oldPrice}',
                          style: TextStyle(
                              decoration: model.product!.discount != 0
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: Colors.black,
                              fontSize: 18.0)),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          ShopCubit.get(context).decreaseCounter();
                        },
                        icon: const Icon(EvaIcons.minusSquare)),
                    Text('${ShopCubit.get(context).counter}'),
                    IconButton(
                        onPressed: () {
                          ShopCubit.get(context).increaseCounter();
                        },
                        icon: const Icon(EvaIcons.plusSquare)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    if (model.product!.discount != 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: defaultText(
                            text: 'EGP ${model.product!.price}',
                            color: Colors.green,
                            size: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    // IconButton(onPressed: (){
                    //     // ShopCubit.get(context).addCart(ShopCubit.get(context).homeModel!.data!.products[currentIndex].id);
                    // }, icon: const Icon(Icons.delete,size: 25.0,))
                  ],
                ),
                const SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: defaultMaterialButton(onPressed: () {}, text: 'check out'),
                ),
              ],
            ),
          )
        ]),
      ),
    ),
  );
}
