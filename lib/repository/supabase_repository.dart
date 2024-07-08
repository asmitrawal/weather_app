import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  final supabase = Supabase.instance.client;

  Future<Either<String, List<Map<String, dynamic>>>> searchCity(
      {required String query}) async {
    try {
      final res = await supabase
          .from('cities')
          .select()
          .ilike('cityName', '%$query%')
          .limit(15);
      return Right(res);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> findCity(
      {required String query}) async {
    try {
      final res = await supabase
          .from('cities')
          .select()
          .eq('cityName', '$query')
          .single();
      return Right(res);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
