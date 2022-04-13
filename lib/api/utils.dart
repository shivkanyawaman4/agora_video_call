import '../main.dart';

class Utils{
    static void notificationRouter(String route, int situation) {
    // 1. Background
    // 2. App is in the background but running in tasks
    // 3. User is interacting with app
    final routeData = route.split("+");
  //   if (routeData.length == 1 && routeData[0] != homeRoute) {
  //     navigatorKey.currentState?.pushNamed(homeRoute, arguments: {"index": 2});
  //     navigatorKey.currentState?.pushNamed(routeData[0]);
  //   } else if (routeData.length == 1 && routeData[0] == homeRoute) {
  //     navigatorKey.currentState
  //         ?.pushNamed(routeData[0], arguments: {"index": 2});
  //   } else if (routeData[0] == withdrawDepositRoute) {
  //     navigatorKey.currentState?.pushNamed(homeRoute, arguments: {"index": 2});
  //     navigatorKey.currentState
  //         ?.pushNamed(routeData[0], arguments: {"index": routeData[1]});
  //   } else if (routeData.length == 2) {
  //     if (routeData[0] == homeRoute) {
  //       if (int.parse(routeData[1]) > 4 || int.parse(routeData[1]) < 0) {
  //         routeData[1] = "2";
  //       }
  //     }
      navigatorKey.currentState
          ?.pushNamed('/video_call', arguments: {"index": routeData[1]});
  //   }
  }
}
