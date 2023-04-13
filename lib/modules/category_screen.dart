import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit.dart';
import 'package:shop_app/layout/state.dart';
import 'package:shop_app/model/category_model.dart';
import 'package:shop_app/share/components/components.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = ShopCubit.get(context).categoryModel;
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BuildCondition(
                condition: ShopCubit.get(context).categoryModel != null,
                builder: (context) => ListView.separated(
                    itemBuilder: (context, index) =>
                        buildCategoryItem(model, index),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: model!.data!.dataModelList.length),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
              )),
        );
      },
    );
  }
}

Widget buildCategoryItem(CategoryModel model, index) {
  return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
    Container(
      width: 150,
      height: 120.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
              image: NetworkImage('${model.data!.dataModelList[index].image}'),
              fit: BoxFit.cover)),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: defaultText(
        text: '${model.data!.dataModelList[index].name}',
        size: 18.0,
      ),
    ),
  ]);
}
