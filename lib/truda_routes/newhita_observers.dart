import 'package:flutter/material.dart';
import 'package:truda/truda_utils/newhita_aic_handler.dart';

import '../truda_utils/newhita_log.dart';
import 'newhita_pages.dart';

class NewHitaRouteObservers<R extends Route<dynamic>> extends RouteObserver<R> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    var name = route.settings.name ?? '';
    if (name.isNotEmpty) NewHitaAppPages.history.add(name);

    NewHitaLog.debug('RouteObserver didPush; history:${NewHitaAppPages.history}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    NewHitaAppPages.history.remove(route.settings.name);
    NewHitaLog.debug('RouteObserver didPop; history:${NewHitaAppPages.history}');

    var nowName = '';
    if (NewHitaAppPages.history.isNotEmpty) {
      nowName = NewHitaAppPages.history.first;
    } else {
      return;
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      var index = NewHitaAppPages.history.indexWhere((element) {
        return element == oldRoute?.settings.name;
      });
      var name = newRoute.settings.name ?? '';
      if (name.isNotEmpty) {
        if (index > 0) {
          NewHitaAppPages.history[index] = name;
        } else {
          NewHitaAppPages.history.add(name);
        }
      }
    }
    NewHitaLog.debug('RouteObserver didReplace; history:${NewHitaAppPages.history}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    NewHitaAppPages.history.remove(route.settings.name);

    NewHitaLog.debug('RouteObserver didRemove; history:${NewHitaAppPages.history}');
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
  }
}
