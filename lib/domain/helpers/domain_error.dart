import 'package:fordev/domain/helpers/helpers.dart';

enum DomainError {
  unexpected,
  invalidCredentials
}

extension DomainErrorProperties on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials: return 'Credenciais inválidas.';
      default: return 'Erro inesperado.';
    }
  }
}