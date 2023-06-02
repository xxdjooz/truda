import 'package:flutter/material.dart';
import 'package:truda/truda_utils/truda_aic_handler.dart';

import '../truda_utils/truda_log.dart';
import 'truda_pages.dart';

class TrudaRouteObservers<R extends Route<dynamic>> extends RouteObserver<R> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    var name = route.settings.name ?? '';
    if (name.isNotEmpty) TrudaAppPages.history.add(name);

    TrudaLog.debug('RouteObserver didPush; history:${TrudaAppPages.history}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    TrudaAppPages.history.remove(route.settings.name);
    TrudaLog.debug('RouteObserver didPop; history:${TrudaAppPages.history}');

    var nowName = '';
    if (TrudaAppPages.history.isNotEmpty) {
      nowName = TrudaAppPages.history.first;
    } else {
      return;
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      var index = TrudaAppPages.history.indexWhere((element) {
        return element == oldRoute?.settings.name;
      });
      var name = newRoute.settings.name ?? '';
      if (name.isNotEmpty) {
        if (index > 0) {
          TrudaAppPages.history[index] = name;
        } else {
          TrudaAppPages.history.add(name);
        }
      }
    }
    TrudaLog.debug('RouteObserver didReplace; history:${TrudaAppPages.history}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    TrudaAppPages.history.remove(route.settings.name);

    TrudaLog.debug('RouteObserver didRemove; history:${TrudaAppPages.history}');
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
