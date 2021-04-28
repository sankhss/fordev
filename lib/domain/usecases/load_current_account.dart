import '../entities/entities.dart';

abstract class LoadCurrentAccount {
  Future<Account> load();
}