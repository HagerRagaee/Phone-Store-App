import 'package:flutter/material.dart';
import 'package:phone_store/presentation/pages/home_page.dart';

class AppRoute {
  Route? generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
    }
    return null;
  }
}
