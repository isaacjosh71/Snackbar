
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snack_bar/data/api/api_client.dart';
import 'package:snack_bar/data/controllers/cart_contoller.dart';
import 'package:snack_bar/data/controllers/most_popular_ctlr.dart';
import 'package:snack_bar/data/repository/cart_repo.dart';
import 'package:snack_bar/data/repository/most_popular_repo.dart';
import 'package:snack_bar/helpers/app_const.dart';
import '../data/controllers/recommended_ctlr.dart';
import '../data/repository/recommended_repo.dart';

Future<void> init() async{
  //shared preferences init
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  //api client
  Get.lazyPut(()=> ApiClient(appBaseUrl: AppConstants.BASE_URL));

  //repositories
  Get.lazyPut(() => MostPopularRepo(apiClient: Get.find()));
  Get.lazyPut(() => RecommendedRepo(apiClient: Get.find()));
  Get.lazyPut(()=> CartRepo(sharedPreferences: Get.find()));

  //controllers
  Get.lazyPut(() => MostPopularController(mostPopularRepo: Get.find()));
  Get.lazyPut(() => RecommendedController(recommendedRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
}