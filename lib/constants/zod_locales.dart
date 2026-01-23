import 'package:zod_validation/zod_validation.dart';

class ZodLocaleDE implements ILocaleZod {
  @override
  String get email => 'Ungültige E-Mail';

  @override
  String get emails => 'Ungültige E-Mails';

  @override
  String get equals => 'Die Werte stimmen nicht überein';

  @override
  String get phone => 'Ungültige Telefonnummer';

  @override
  String type<T>() => 'Ungültiger Wert';

  @override
  String min(int v) => 'Mindestens $v Zeichen';

  @override
  String max(int v) => 'Maximal $v Zeichen';

  @override
  String get cnpj => 'Ungültige CNPJ';

  @override
  String get cpf => 'Ungültige CPF';

  @override
  String get cpfCnpj => 'Ungültige CPF/CNPJ';

  @override
  String get isDate => 'Ungültiges Datum';

  @override
  String get isMoney => 'Ungültiger Geldbetrag';

  @override
  String get required => 'Erforderlich';

  @override
  String get password => 'Ungültiges Passwort';

  @override
  String get custom => 'Ungültiger Wert';
}

// Create EN

class ZodLocaleEN implements ILocaleZod {
  @override
  String get email => 'Invalid email';

  @override
  String get emails => 'Invalid emails';

  @override
  String get equals => 'Values do not match';

  @override
  String get phone => 'Invalid phone number';

  @override
  String type<T>() => 'Invalid value';

  @override
  String min(int v) => 'Minimum $v characters';

  @override
  String max(int v) => 'Maximum $v characters';

  @override
  String get cnpj => 'Invalid CNPJ';

  @override
  String get cpf => 'Invalid CPF';

  @override
  String get cpfCnpj => 'Invalid CPF/CNPJ';

  @override
  String get isDate => 'Invalid date';

  @override
  String get isMoney => 'Invalid money amount';

  @override
  String get required => 'Required';

  @override
  String get password => 'Invalid password';

  @override
  String get custom => 'Invalid value';
}
