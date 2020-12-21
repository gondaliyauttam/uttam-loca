import 'package:location/location.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:loca_bird/src/models/food.dart';
import 'package:loca_bird/src/models/location_type.dart';
import 'package:loca_bird/src/models/restaurantdata.dart';
import 'package:loca_bird/src/models/review.dart';
import 'package:loca_bird/src/repository/food_repository.dart';
import 'package:loca_bird/src/repository/restaurant_repository.dart';
import 'package:loca_bird/src/repository/settings_repository.dart';
import 'package:loca_bird/src/repository/settings_repository.dart'
as sett;

class HomeController extends ControllerMVC {
//  List<Category> categories = <Category>[];
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Restaurant> locationRestaurants = <Restaurant>[];
  List<Review> recentReviews = <Review>[];
  List<Food> trendingFoods = <Food>[];
  List<LocationType> locationType = <LocationType>[];
  bool loaded = true;

  HomeController() {
    // listenForCategories();
    listenForlocationtype();
    listenForTopRestaurants();
    listenForRecentReviews();
    listenForTrendingFoods();
  }

  /*void listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {}, onDone: () {});
  }*/

  void listenForTopRestaurants() async {
    getCurrentLocation().then((LocationData _locationData) async {
      print(_locationData.latitude.toString() +
          " " +
          _locationData.longitude.toString());
      final Stream<Restaurant> stream =
          await getNearRestaurants(_locationData, _locationData);
      stream.listen((Restaurant _restaurant) {
        setState(() => topRestaurants.add(_restaurant));
      }, onError: (a) {}, onDone: () {});
    });
  }

  void listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForTrendingFoods() async {
    final Stream<Food> stream = await getTrendingFoods();
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForlocationtype() async {
    final Stream<LocationType> stream = await getLocationType();
    stream.listen((LocationType _locationType) {
      setState(() => locationType.add(_locationType));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void getLocationTypeRestaurant(String id) {
    List<int> selecteditem = new List<int>();
    selecteditem.add(int.parse(id));
    getCurrentLocation().then((LocationData _locationData) async {
      print(_locationData.latitude.toString() +
          " " +
          _locationData.longitude.toString());
      final Stream<Restaurant> stream =
          await getMapRestaurants(_locationData, selecteditem);
      stream.listen((Restaurant _restaurant) {
        setState(() => locationRestaurants.add(_restaurant));
      }, onError: (a) {
        locationRestaurants = <Restaurant>[];
      }, onDone: () {
        setState(() {
          loaded = false;
        });
      });
    });
  }

  Future<void> refreshHome() async {
    topRestaurants = <Restaurant>[];
    recentReviews = <Review>[];
    trendingFoods = <Food>[];
    locationType = <LocationType>[];
    listenForlocationtype();
    listenForTopRestaurants();
    listenForRecentReviews();
    listenForTrendingFoods();
  }
}
