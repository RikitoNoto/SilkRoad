// Mocks generated by Mockito 5.4.0 from annotations
// in silkroad/test/utils/platform_saver_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mockito/mockito.dart' as _i1;
import 'package:platform/src/interface/local_platform.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeUri_0 extends _i1.SmartFake implements Uri {
  _FakeUri_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [LocalPlatform].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalPlatform extends _i1.Mock implements _i2.LocalPlatform {
  MockLocalPlatform() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get numberOfProcessors => (super.noSuchMethod(
        Invocation.getter(#numberOfProcessors),
        returnValue: 0,
      ) as int);
  @override
  String get pathSeparator => (super.noSuchMethod(
        Invocation.getter(#pathSeparator),
        returnValue: '',
      ) as String);
  @override
  String get operatingSystem => (super.noSuchMethod(
        Invocation.getter(#operatingSystem),
        returnValue: '',
      ) as String);
  @override
  String get operatingSystemVersion => (super.noSuchMethod(
        Invocation.getter(#operatingSystemVersion),
        returnValue: '',
      ) as String);
  @override
  String get localHostname => (super.noSuchMethod(
        Invocation.getter(#localHostname),
        returnValue: '',
      ) as String);
  @override
  Map<String, String> get environment => (super.noSuchMethod(
        Invocation.getter(#environment),
        returnValue: <String, String>{},
      ) as Map<String, String>);
  @override
  String get executable => (super.noSuchMethod(
        Invocation.getter(#executable),
        returnValue: '',
      ) as String);
  @override
  String get resolvedExecutable => (super.noSuchMethod(
        Invocation.getter(#resolvedExecutable),
        returnValue: '',
      ) as String);
  @override
  Uri get script => (super.noSuchMethod(
        Invocation.getter(#script),
        returnValue: _FakeUri_0(
          this,
          Invocation.getter(#script),
        ),
      ) as Uri);
  @override
  List<String> get executableArguments => (super.noSuchMethod(
        Invocation.getter(#executableArguments),
        returnValue: <String>[],
      ) as List<String>);
  @override
  String get version => (super.noSuchMethod(
        Invocation.getter(#version),
        returnValue: '',
      ) as String);
  @override
  bool get stdinSupportsAnsi => (super.noSuchMethod(
        Invocation.getter(#stdinSupportsAnsi),
        returnValue: false,
      ) as bool);
  @override
  bool get stdoutSupportsAnsi => (super.noSuchMethod(
        Invocation.getter(#stdoutSupportsAnsi),
        returnValue: false,
      ) as bool);
  @override
  String get localeName => (super.noSuchMethod(
        Invocation.getter(#localeName),
        returnValue: '',
      ) as String);
  @override
  bool get isLinux => (super.noSuchMethod(
        Invocation.getter(#isLinux),
        returnValue: false,
      ) as bool);
  @override
  bool get isMacOS => (super.noSuchMethod(
        Invocation.getter(#isMacOS),
        returnValue: false,
      ) as bool);
  @override
  bool get isWindows => (super.noSuchMethod(
        Invocation.getter(#isWindows),
        returnValue: false,
      ) as bool);
  @override
  bool get isAndroid => (super.noSuchMethod(
        Invocation.getter(#isAndroid),
        returnValue: false,
      ) as bool);
  @override
  bool get isIOS => (super.noSuchMethod(
        Invocation.getter(#isIOS),
        returnValue: false,
      ) as bool);
  @override
  bool get isFuchsia => (super.noSuchMethod(
        Invocation.getter(#isFuchsia),
        returnValue: false,
      ) as bool);
  @override
  String toJson() => (super.noSuchMethod(
        Invocation.method(
          #toJson,
          [],
        ),
        returnValue: '',
      ) as String);
}
