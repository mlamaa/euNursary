import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFuncitons{
  static final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'sendNotification',
);
  static Future notifyParents() async{
    dynamic resp = await callable.call();
    print(resp);
  }
}