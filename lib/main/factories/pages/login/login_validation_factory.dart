import 'package:meta/meta.dart';

import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../../validation/protocols/protocols.dart';

Validation createLoginValidation() =>
    ValidationComposite(createLoginValidationsList());

@visibleForTesting
List<FieldValidation> createLoginValidationsList() => [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ];
