import 'package:equatable/equatable.dart';

enum FormValueStatus { undefined, inProgress, valid, invalid }

/// Класс для работы со значениями в формах.
///
/// Класс иммутабельный. Все функции, меняющие значения, возвращают новый
/// объект.
///
/// Состояния значения (напрямую значением [status] можно не пользоваться):
/// [isUndefined] - значение не определено. Внутреннее значение [rawValue]
///   устанавливается в `null`. Если при этом тип значения [T] non-nullable, то
///   вызов свойства [value] приведёт к ошибке. Устанавливается через
///   [FormValue.undefined].
/// [isInProgress] - значение находится в процессе редактирования (обычное
///   состояние для формы). Устанавливается через конструктор по умолчанию.
/// [isValid] - значение проверено и оно валидно. Устанавливается через
///   функцию [validate]. Проверка осуществляется через переопределяемую функцию
///   [validator].
/// [isInvalid] - значение проверено и оно невалидно. В этом случае может
///   содержать текст ошибки [error]. Устанавливается через функцию [validate].
///
/// Дополнительно есть поле [isModified]. При создании объекта всегда равно
/// `false`. Устанавливается автоматически в `true` в функции [setValue], если
/// значение было изменено. Сбрасывается в `false` через функцию [commit].
class FormValue<T, E> extends Equatable {
  const FormValue._(
    this.rawValue,
    this.status, {
    this.isModified = false,
    this.error,
  });

  const FormValue(T value)
      : this._(
          value,
          FormValueStatus.inProgress,
        );

  const FormValue.undefined([T? initialValue])
      : this._(
          initialValue,
          FormValueStatus.undefined,
        );

  final T? rawValue;
  final FormValueStatus status;
  final bool isModified;
  final E? error;

  T get value => rawValue as T;

  @override
  List<Object?> get props => [value, isModified, status, error];

  @override
  String toString({bool value = true, bool info = true}) => <String>[
        if (value) '$rawValue',
        if (info) ...[
          status.toString().replaceFirst(RegExp(r'.*\.'), ''),
          if (isModified) 'modified',
          if (error != null) '$error',
        ],
      ].join(', ');

  bool get isUndefined => status == FormValueStatus.undefined;
  bool get isInProgress => status == FormValueStatus.inProgress;
  bool get isValid => status == FormValueStatus.valid;
  bool get isInvalid => status == FormValueStatus.invalid;

  FormValue<T, E> setValue(T value) => FormValue._(
        value,
        FormValueStatus.inProgress,
        isModified: isModified || value != this.value,
        error: error,
      );

  FormValue<T, E> toValid() => FormValue._(
        value,
        FormValueStatus.valid,
        isModified: isModified,
      );

  FormValue<T, E> toInvalid(E error) => FormValue._(
        value,
        FormValueStatus.invalid,
        isModified: isModified,
        error: error,
      );

  FormValue<T, E> validate(E? Function(T value) validator) {
    final error = validator(value);

    return FormValue._(
      value,
      error == null ? FormValueStatus.valid : FormValueStatus.invalid,
      isModified: isModified,
      error: error,
    );
  }

  FormValue<T, E> commit() => FormValue._(
        value,
        status,
        isModified: false,
        error: error,
      );
}
