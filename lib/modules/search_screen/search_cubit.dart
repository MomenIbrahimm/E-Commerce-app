import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/model/search_model.dart';
import 'package:shop_app/modules/search_screen/search_state.dart';
import 'package:shop_app/share/network/end_points.dart';
import 'package:shop_app/share/network/remote/dio_helper.dart';
import 'package:shop_app/share/style/const.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(InitialSearchState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void getSearch(String? text) {
    emit(SearchLoadingState());
    DioHelper.postData(
        url: SEARCH,
        token: token,
        data:
        {
          'text' : text,
        })
        .then((value) {
          searchModel = SearchModel.fromJson(value.data);
          emit(SearchSuccessState());
    })
        .catchError((error) {
          emit(SearchErrorState());
          print(error.toString());
    });
  }
}
