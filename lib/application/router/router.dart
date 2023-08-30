
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/application/builders/master_builder.dart';
import 'package:kliknss77/ui/views/startup/splash_screen.dart';

class AppRouter extends InterceptorsWrapper {

  dynamic userID, buildLogin;
  
  Map<String, dynamic> routes = {
    '/startup': (_) => SplashScreen(),
    '/page': (_) { 
      var datas  = DataBuilder(( _['query']['url'] ?? ""),).getDataState().getDataWidgets();
      return datas['data']?['data']?['url'] != "${_['query']['url']}" ?
      MasterBuilder(url: _['query']['url'],shimmer: _['query']['shimmer'],): datas['widgets'];
    },
  };

  Route<dynamic>? onGenerateRoute(RouteSettings settings, [String? lbasePath]) {
    Map? match;
    Function? fn;

    for (var path in routes.keys) {
        Map? curMatch = isMatch(settings.name!, path);
        if (curMatch != null) {
          match = curMatch;
          fn = routes[path];
        }
      }

    // userID = SharedPrefs().get(SharedPreferencesKeys.customerId);
    
    if (match != null) {
       return MaterialPageRoute(
            builder: (_) => fn!(match), settings: settings);
    } 

    return null;
  }



  Map? isMatch(String url, pattern) {
    bool matched = false;
    var uri = Uri.parse(url);
    var urlSegments = pattern.substring(1).split('/');
    Map params = {};
    if (uri.pathSegments.isNotEmpty &&
        urlSegments.length == uri.pathSegments.length) {
      bool segmentMatch = true;
      for (var i = 0; i < urlSegments.length; i++) {
        String segment = urlSegments[i];
        if (segment.indexOf(':') == 0) {
          String key = segment.substring(1);
          params[key] = uri.pathSegments[i];
        } else {
          if (uri.pathSegments[i] != urlSegments[i]) {
            segmentMatch = false;
            break;
          }
        }
      }

      matched = segmentMatch;
    } else if (url == pattern) {
      matched = true;
    }

    if (matched) {
      String routeName =
          url.contains('?') ? url.substring(0, url.indexOf('?')) : url;

      return {
        'params': params,
        'query': uri.queryParameters,
        'name': routeName
      };
    }
    return null;
  }
}
