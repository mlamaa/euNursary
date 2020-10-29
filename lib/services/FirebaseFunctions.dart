import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFuncitons {
  static Future notifyParents() async {
    CloudFunctions.instance
        .getHttpsCallable(
          functionName: 'sendNotification',
        )
        .call()
        .then((value) => print(value));
  }
}
