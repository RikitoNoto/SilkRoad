import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:platform/platform.dart';

import 'package:silkroad/global.dart';
import 'package:silkroad/comm/comm.dart';
import 'package:silkroad/parameter.dart';
import 'package:silkroad/send/repository/send_repository.dart';
import 'package:silkroad/i18n/translations.g.dart';
import 'package:silkroad/send/views/sendable_list_item.dart';

import '../../utils/models/animated_list_item_model.dart';

enum SendResult {
  success,
  lostFile,
  connectionFail,
  sendFail,
}

extension SendResultMessage on SendResult {
  String get message {
    switch (this) {
      case SendResult.success:
        return t.send.sendResult.success;

      case SendResult.lostFile:
        return t.send.sendResult.lostFile;

      case SendResult.connectionFail:
        return t.send.sendResult.connectionFail;

      case SendResult.sendFail:
        return t.send.sendResult.sendFail;
    }
  }
}

class SendProvider with ChangeNotifier, IpaddressFetcher {
  SendProvider(
      {this.builder = kSendRepositoryDefault,
      required this.platform,
      GlobalKey<AnimatedListState>? listKey}) {
    fetchIpAddress();
    _sender = builder();
    _listKey = listKey ?? GlobalKey<AnimatedListState>();

    _sendableList = AnimatedListItemModel<String>(
      listKey: _listKey,
      removedItemBuilder: (address, index, context, animation) =>
          SendableListItemRemoving(
        platform: platform,
        index: index,
        animation: animation,
        address: "a",
        sender: "sender",
      ),
    );
  }

  static final String fileNameNoSelect = t.send.fileNone;

  final List<int> _ip = <int>[0, 0, 0, 0];
  final List<String> _addressRange = <String>[];
  File? _file;
  final SimpleFactoryFunc<SendRepository> builder;
  final Platform platform;
  late final SendRepository _sender;

  late final GlobalKey<AnimatedListState> _listKey;
  late final AnimatedListItemModel<String> _sendableList;

  String get filePath => _file?.path ?? '';
  String get ip => _ip.join('.');
  String get fileName {
    File? file = _file;
    return file != null ? p.basename(_file!.path) : fileNameNoSelect;
  }

  int get addressRangeCount => _addressRange.length;
  List<String> get addressRange => _addressRange;

  Future fetchIpAddress() async {
    _addressRange.clear();
    Set<String> addressRangeSet = <String>{};
    for (String address in await fetchIpv4Addresses(platform)) {
      List<String> range = IpAddressUtility.getIpAddressRange(address);
      addressRangeSet.add('${range[0]}~${range[1]}');
    }
    _addressRange.addAll(addressRangeSet.toList());
    notifyListeners();
  }

  Future<SendResult> send() async {
    File? file = _file;
    if (file == null) return SendResult.lostFile;
    if (!(await file.exists())) return SendResult.lostFile;

    // send
    try {
      await _sender.send(
          '$ip:${OptionManager().get(Params.port.toString()) ?? kDefaultPort}',
          <String, String>{
            "title": p.basename(file.path),
            //FIXME: this should not do here what split data to list.(should be do in repository)
            "data": (await file.readAsBytes())
                .map<String>((int value) => value.toString())
                .join(','),
          });
    } catch (e) {
      _sender.close();
      return SendResult.sendFail;
    }
    _sender.close();
    return SendResult.success;
  }

  void setOctet(int octet, int value) {
    _ip[octet] = value;
  }

  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  Future<void> searchSendableDevices() async {}
}
