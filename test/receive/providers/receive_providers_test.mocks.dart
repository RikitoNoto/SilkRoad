// Mocks generated by Mockito 5.4.2 from annotations
// in silkroad/test/receive/providers/receive_providers_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter/material.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:silkroad/receive/entity/receive_item.dart' as _i5;
import 'package:silkroad/receive/repository/receive_repository.dart' as _i3;

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

class _FakeIconData_0 extends _i1.SmartFake implements _i2.IconData {
  _FakeIconData_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ReceiveRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockReceiveRepository extends _i1.Mock implements _i3.ReceiveRepository {
  MockReceiveRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i5.ReceiveItem> listen(String? connectionPoint) =>
      (super.noSuchMethod(
        Invocation.method(
          #listen,
          [connectionPoint],
        ),
        returnValue: _i4.Stream<_i5.ReceiveItem>.empty(),
      ) as _i4.Stream<_i5.ReceiveItem>);
  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [ReceiveItem].
///
/// See the documentation for Mockito's code generation for more information.
class MockReceiveItem extends _i1.Mock implements _i5.ReceiveItem {
  MockReceiveItem() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.IconData get iconData => (super.noSuchMethod(
        Invocation.getter(#iconData),
        returnValue: _FakeIconData_0(
          this,
          Invocation.getter(#iconData),
        ),
      ) as _i2.IconData);
  @override
  set iconData(_i2.IconData? _iconData) => super.noSuchMethod(
        Invocation.setter(
          #iconData,
          _iconData,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: '',
      ) as String);
  @override
  int get size => (super.noSuchMethod(
        Invocation.getter(#size),
        returnValue: 0,
      ) as int);
  @override
  set size(int? _size) => super.noSuchMethod(
        Invocation.setter(
          #size,
          _size,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get sizeStr => (super.noSuchMethod(
        Invocation.getter(#sizeStr),
        returnValue: '',
      ) as String);
  @override
  set sizeStr(String? _sizeStr) => super.noSuchMethod(
        Invocation.setter(
          #sizeStr,
          _sizeStr,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get sender => (super.noSuchMethod(
        Invocation.getter(#sender),
        returnValue: '',
      ) as String);
  @override
  String get tempPath => (super.noSuchMethod(
        Invocation.getter(#tempPath),
        returnValue: '',
      ) as String);
}
