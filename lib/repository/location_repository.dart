import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepository {
  Position? _position;
  Position? get position => _position;

  String? _cityName;
  String? get cityName => _cityName;

  Future<Either<String, Position>> getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Left("location permission denied");
      }
      if (permission == LocationPermission.deniedForever) {
        return Left(
            "location permission denied forever, unable to get location");
      }
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return Right(_position!);
  }

  Future<String> getCityName({required Position position}) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    _cityName = placemark[0].locality;
    return _cityName ?? "error fetching city name";
  }
}
