import 'package:geolocator/geolocator.dart';

abstract class LocalizationHelper {
  static double _longitude;
  static double _latitude;

  static Future<double> get longitude async {
    if (_longitude == null) {
      await updateData();
    }
    return _longitude;
  }

  static Future<double> get latitude async {
    if (_latitude == null) {
      await updateData();
    }
    return _latitude;
  }

  static updateData() async {
    Position position;
    try {
      position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      throw Exception('Cannot establish location exception');
    }
    _longitude = position.longitude;
    _latitude = position.latitude;
  }
}
