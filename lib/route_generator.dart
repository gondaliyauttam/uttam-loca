import 'package:flutter/material.dart';
import 'package:loca_bird/src/models/route_argument.dart';
import 'package:loca_bird/src/pages/restaurant.dart';
import 'package:loca_bird/src/pages/cart.dart';
import 'package:loca_bird/src/pages/category.dart';
import 'package:loca_bird/src/pages/checkout.dart';
import 'package:loca_bird/src/pages/debug.dart';
import 'package:loca_bird/src/pages/details.dart';
import 'package:loca_bird/src/pages/favorites.dart';
import 'package:loca_bird/src/pages/food.dart';
import 'package:loca_bird/src/pages/help.dart';
import 'package:loca_bird/src/pages/languages.dart';
import 'package:loca_bird/src/pages/login.dart';
import 'package:loca_bird/src/pages/main_page.dart';
import 'package:loca_bird/src/pages/map.dart';
import 'package:loca_bird/src/pages/map_page.dart';
import 'package:loca_bird/src/pages/menu_list.dart';
import 'package:loca_bird/src/pages/notifications.dart';
import 'package:loca_bird/src/pages/order_success.dart';
import 'package:loca_bird/src/pages/pages.dart';
import 'package:loca_bird/src/pages/payment_methods.dart';
import 'package:loca_bird/src/pages/paypal_payment.dart';
import 'package:loca_bird/src/pages/profile.dart';
import 'package:loca_bird/src/pages/question_page.dart';
import 'package:loca_bird/src/pages/settings.dart';
import 'package:loca_bird/src/pages/signup.dart';
import 'package:loca_bird/src/pages/splash_screen.dart';
import 'package:loca_bird/src/pages/tracking.dart';
import 'package:loca_bird/src/pages/walkthrough.dart';
import 'package:loca_bird/src/pages/webview.dart';
import 'package:loca_bird/src/pages/LocationTypeRestaurantList.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Debug':
        return MaterialPageRoute(
            builder: (_) => DebugWidget(routeArgument: args as RouteArgument));
      case '/Walkthrough':
        return MaterialPageRoute(builder: (_) => Walkthrough());
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/SignUp':
        return MaterialPageRoute(
            builder: (_) => SignUpWidget(routeArgument: args as RouteArgument));
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification2':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/Login':
        return MaterialPageRoute(
            builder: (_) => LoginWidget(routeArgument: args as RouteArgument));
      case '/Pages':
        return MaterialPageRoute(
            builder: (_) => PagesTestWidget(currentTab: args));
      case '/Details':
        return MaterialPageRoute(
            builder: (_) =>
                DetailsWidget(routeArgument: args as RouteArgument));
      case '/Map':
        return MaterialPageRoute(
            builder: (_) => MapWidget(routeArgument: args as RouteArgument));
      case '/Menu':
        return MaterialPageRoute(
            builder: (_) => MenuWidget(routeArgument: args as RouteArgument));
      case '/Food':
        return MaterialPageRoute(
            builder: (_) => FoodWidget(routeArgument: args as RouteArgument));
      case '/Category':
        return MaterialPageRoute(
            builder: (_) =>
                CategoryWidget(routeArgument: args as RouteArgument));
      case '/Cart':
        return MaterialPageRoute(
            builder: (_) => CartWidget(routeArgument: args as RouteArgument));
      case '/Tracking':
        return MaterialPageRoute(
            builder: (_) =>
                TrackingWidget(routeArgument: args as RouteArgument));
      case '/PaymentMethod':
        return MaterialPageRoute(builder: (_) => PaymentMethodsWidget());
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/CashOnDelivery':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessWidget(
                routeArgument: RouteArgument(param: 'Cash on Delivery')));
      case '/PayOnPickup':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessWidget(
                routeArgument: RouteArgument(param: 'Pay on Pickup')));
      case '/PayPal':
        return MaterialPageRoute(
            builder: (_) =>
                PayPalPaymentWidget(routeArgument: args as RouteArgument));
      case '/OrderSuccess':
        return MaterialPageRoute(
            builder: (_) =>
                OrderSuccessWidget(routeArgument: args as RouteArgument));
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfileWidget());
      case '/Notifications':
        return MaterialPageRoute(builder: (_) => NotificationsWidget());
      case '/Favorites':
        return MaterialPageRoute(builder: (_) => FavoritesWidget());
      case '/WebView':
        return MaterialPageRoute(
            builder: (_) => WebViews(routeArgument: args as RouteArgument));
      case '/MainPage':
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/QuestionPage':
        return MaterialPageRoute(
            builder: (_) => QuestionPage(routeArgument: args as RouteArgument));
    case '/LocationTypeRestaurantList':
        return MaterialPageRoute(
            builder: (_) => LocationTypeRestaurantList(routeArgument: args as RouteArgument));
      case '/Restaurant':
        return MaterialPageRoute(
            builder: (_) =>
                RestaurantWidget());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) => LoginWidget(routeArgument : new RouteArgument(param: true)));
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
