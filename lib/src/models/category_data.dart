import 'package:loca_bird/config/app_images.dart';

class CategoryListData {
  String titleTxt;
  bool isSelected;
  String image;

  CategoryListData({
    this.titleTxt = '',
    this.isSelected = false,
    this.image='',
  });

  static List<CategoryListData> popularFList = [
    CategoryListData(
      titleTxt: 'Barber',
      isSelected: false,
      image: barbar,
    ),
    CategoryListData(
      titleTxt: 'Beauty Salon',
      isSelected: false,
      image: beautysalon,
    ),
    CategoryListData(
      titleTxt: 'Cafe',
      isSelected: false,
      image: cafe,
    ),
    CategoryListData(
      titleTxt: 'Cinema',
      isSelected: false,
      image: cinema,
    ),
    CategoryListData(
      titleTxt: 'Coffee Bar',
      isSelected: false,
      image: coffeebar,
    ),
    CategoryListData(
      titleTxt: 'Fast Food',
      isSelected: false,
      image: fastfood,
    ),
    CategoryListData(
      titleTxt: 'Fitness Center',
      isSelected: false,
      image: fitnesscenter,
    ),
    CategoryListData(
      titleTxt: 'Grand Cafe',
      isSelected: false,
      image: grandcafe,
    ),
    CategoryListData(
      titleTxt: 'Lunch Room',
      isSelected: false,
      image: lunchroom,
    ),
    CategoryListData(
      titleTxt: 'Massage Salon',
      isSelected: false,
      image: massagesalon,
    ),
    CategoryListData(
      titleTxt: 'Museum',
      isSelected: false,
      image: museum,
    ),
    CategoryListData(
      titleTxt: 'Nail Studio',
      isSelected: false,
      image: nailstudio
    ),
    CategoryListData(
      titleTxt: 'Party cafe',
      isSelected: false,
      image: partycafe
    ),
    CategoryListData(
      titleTxt: 'Restaurant',
      isSelected: false,
      image: restaurant
    ),
    CategoryListData(
      titleTxt: 'Sauna',
      isSelected: false,
      image: sauna
    ),
    CategoryListData(
      titleTxt: 'Swimming Pool',
      isSelected: false,
      image: swimmingpool
    ),
    CategoryListData(
      titleTxt: 'Wine Bar',
      isSelected: false,
      image: winebar
    ),
  ];
}
