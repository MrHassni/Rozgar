import 'package:Rozgar/components/pages/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Rozgar/components/pages/ChildScreen.dart';
import 'package:Rozgar/components/pages/HomeKitchen.dart';
import 'package:Rozgar/components/pages/HomeQari.dart';
import 'package:Rozgar/components/pages/HomeTution.dart';
import 'package:Rozgar/components/pages/JobOperates.dart';
import 'package:Rozgar/components/pages/Maintain.dart';
import 'package:Rozgar/components/pages/SalePurchase.dart';
import 'package:Rozgar/components/pages/TabarukDeal.dart';
import 'package:Rozgar/components/pages/Zayarat.dart';

class Routes{
  static Route <dynamic> generateRouter(RouteSettings settings){
    
switch (settings.name) {
      case '/HomeQari':
        return MaterialPageRoute(builder: (_) => HomeQari());
      case '/HomeTution':
        return MaterialPageRoute(builder: (_) => Hometution());
         case '/Maintenence':
        return MaterialPageRoute(builder: (_) => Maintain());
         case '/HomeKitchen':
        return MaterialPageRoute(builder: (_) => HomeKitchen());
         case '/JobOperates':
        return MaterialPageRoute(builder: (_) => JobOperates());
         case '/TabarukDeal':
        return MaterialPageRoute(builder: (_) => TabarukDeal());
         case '/SalePurchase':
        return MaterialPageRoute(builder: (_) => SalePurchase());
         case '/ZiaratPackege':
        return MaterialPageRoute(builder: (_) => Zayarat());
         case '/vendorScreen':
        return MaterialPageRoute(builder: (_) => ChildScreen());
  
      default:
        return MaterialPageRoute(
    
            builder: (_) => Scaffold(
              
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
     
    
    // other routes
  
  }
}

