import 'package:fordev/main/builders/builders.dart';
import 'package:meta/meta.dart';

import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../../validation/protocols/protocols.dart';

Validation createLoginValidation() =>
    ValidationComposite(createLoginValidationsList());

@visibleForTesting
List<FieldValidation> createLoginValidationsList() => [
      ...ValidationBuilder.field('email').email().required().build(),
      ...ValidationBuilder.field('password').required().build(),
    ];
