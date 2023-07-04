import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:path/path.dart' as p;
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:silkroad/comm/comm.dart';
import 'package:silkroad/option/option_manager.dart';
import 'package:silkroad/send/providers/send_provider.dart';
import 'package:silkroad/send/repository/send_repository.dart';
import 'package:silkroad/option/params.dart';

import 'send_providers_test.mocks.dart';

late SendProvider kProvider;
late MockFile kFileMock;
late MockTcp kTcpMock;
late MockSocket kSocketMock;
late Message? kSendData;
late Map<String, Object> kParamMap;

CommunicationIF<Socket> _buildSpy(){
  return kTcpMock;
}

Future setParam(String key , Object value) async{
  kParamMap[key] = value;
  SharedPreferences.setMockInitialValues(kParamMap);
  await OptionManager.initialize();
}

@GenerateNiceMocks([MockSpec<SendRepository>()])
@GenerateMocks([Socket])
@GenerateMocks([Tcp])
@GenerateMocks([File])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(()async{
    kSendData = null;
    kFileMock = MockFile();
    kTcpMock = MockTcp();
    kSocketMock = MockSocket();
    kProvider = SendProvider(platform: const LocalPlatform(), builder: ()=>MockSendRepository());
    kProvider.file = kFileMock;
    kParamMap = <String, Object>{};
    await setParam(Params.port.toString(), 32099);
    await setParam(Params.name.toString(), '');
  });
  tearDown(()async{
  });
  ipTest();
  fileSetTest();
  sendMessageTest();
  fileNameTest();
}

void fileSetTest(){
  group('file set test', () {
    test('should be able to set file and get file path', () {
      kProvider.file = File('');
      expect(kProvider.filePath, '');
    });

    test('should be change file path [A]', () {
      kProvider.file = File('A');
      expect(kProvider.filePath, 'A');
    });

    test('should be change file path [file]', () {
      kProvider.file = File('file');
      expect(kProvider.filePath, 'file');
    });
  });
}

void fileNameTest(){
  group('file name test', () {
    test('should be get file name [No select] when no file set', () {
      kProvider.file = null;
      expect(kProvider.fileName, 'No select');
    });

    test('should be get file name [temp.c] when set file temp/temp.c', () {
      when(kFileMock.path).thenAnswer((_) => p.join('temp', 'temp.c'));
      expect(kProvider.fileName, 'temp.c');
    });
  });
}

void setIpAddressToProvider(String ip, {SendProvider? provider}){
  provider ??= kProvider;
  ip.split('.').asMap().forEach((int i, String octet) {
    provider?.setOctet(i, int.parse(octet));
  });
}

void ipTest(){

  group('ip address test', () {
    test('should be get ip address default 0.0.0.0', () {
      expect(kProvider.ip, '0.0.0.0');
    });

    test('should be able to set octet 1 to 255', () {
      kProvider.setOctet(0, 255);
      expect(kProvider.ip, '255.0.0.0');
    });

    test('should be able to set octet 2 to 255', () {
      kProvider.setOctet(1, 255);
      expect(kProvider.ip, '0.255.0.0');
    });

    test('should be able to set octet 3 to 255', () {
      kProvider.setOctet(2, 255);
      expect(kProvider.ip, '0.0.255.0');
    });

    test('should be able to set octet 4 to 255', () {
      kProvider.setOctet(3, 255);
      expect(kProvider.ip, '0.0.0.255');
    });

    test('should be able to set all octets to 255', () {
      setIpAddressToProvider('255.255.255.255');
      expect(kProvider.ip, '255.255.255.255');
    });
  });
}

Future setupSendMocks({String fileName='name', bool isFileExist=true, Uint8List? data, Result sendResult=Result.success, bool connectionResult=true, String? sender}) async{
  when(kFileMock.exists()).thenAnswer((_) => Future.value(isFileExist));
  when(kFileMock.path).thenAnswer((_) => p.join(fileName));
  when(kFileMock.readAsBytes()).thenAnswer((_) => Future.value(data ?? Uint8List(0)));
  when(kTcpMock.connect(any)).thenAnswer((_)=>Future.value(connectionResult ? kSocketMock : null));
  when(kTcpMock.send(any, any)).thenAnswer((Invocation invocation) {
    kSendData = invocation.positionalArguments[1];
    return Future.value(sendResult);
  });
  when(kTcpMock.close()).thenAnswer((_)=>Future.value(null));
  await setParam(Params.name.toString(), sender ?? '');
}

void checkCalledSend({
  String expectIp='0.0.0.0',
  int expectPort=32099,
  Message? data,
  bool checkNever=false,
  bool checkNeverConnect=false,
  bool checkNeverSend=false,
  bool checkNeverClose=false,
}){
  if(checkNever) checkNeverConnect = checkNeverSend = checkNeverClose = checkNever;

  if(!checkNeverConnect) {
    verify(kTcpMock.connect('$expectIp:$expectPort'));
  }
  else{
    verifyNever(kTcpMock.connect(any));
  }

  if(!checkNeverSend){
    verify(kTcpMock.send(kSocketMock, any));
    if(data != null){
      expect(kSendData?.data, data.data);
    }
  }else{
    verifyNever(kTcpMock.send(any, any));
  }

  if(!checkNeverClose){
    verify(kTcpMock.close());
  }else{
    verifyNever(kTcpMock.close());
  }
}

SendProvider constructProvider({
  Platform? platform,
  SendRepository? repository,
  File? file,
}){
  SendProvider provider = SendProvider(
    platform: platform ?? const LocalPlatform(),
    builder: (){
      return repository ?? MockSendRepository();
    },
  );
  if(file != null) provider.file = file;
  return provider;
}

void sendMessageTest(){
  MockSendRepository setupConnectAndSend({
    String connectionId = "",
  }){
    MockSendRepository mockRepo = MockSendRepository();
    // when(mockRepo.connect(any)).thenAnswer((_) => Future.value(connectionId));
    when(mockRepo.send(any, any)).thenAnswer((_) => Future.value(null));
    return mockRepo;
  }

  MockFile createFileMock({
    bool isExist = true,
    String path = "",
    String data = "",
  }){
    MockFile mockFile = MockFile();
    when(mockFile.exists()).thenAnswer((_) => Future.value(isExist));
    when(mockFile.path).thenAnswer((_) => p.join(path));
    when(mockFile.readAsBytes()).thenAnswer((_) => Future.value(Uint8List.fromList(utf8.encode(data))));
    return mockFile;
  }

  group('send test', () {
    test('should be call a send method', () async{
      MockSendRepository mockRepo = MockSendRepository();
      MockFile mockFile = createFileMock();

      SendProvider provider = constructProvider(repository: mockRepo, file: mockFile);
      await setParam(Params.port.toString(), 32100);
      setIpAddressToProvider("1.1.1.1", provider: provider);
      SendResult result = await provider.send();

      verify(mockRepo.send("1.1.1.1:32100", any));
      expect(result, SendResult.success);
    });

    checkVerifyNever({
      MockFile? file,
      MockSendRepository? repository,
      required SendResult result,
    }) async {
      MockSendRepository mockRepo = repository ?? MockSendRepository();
      MockFile mockFile = file ?? createFileMock();
      SendProvider provider = constructProvider(repository: mockRepo, file: mockFile);
      SendResult result = await provider.send();

      verifyNever(mockRepo.send(any, any));
      expect(result, result);
    }

    test('should be do not call a send method when a file does not set', () async{
      MockSendRepository mockRepo = MockSendRepository();
      SendProvider provider = constructProvider(repository: mockRepo);
      SendResult result = await provider.send();

      verifyNever(mockRepo.send(any, any));
      expect(result, SendResult.lostFile);
    });

    test('should be do not call a send method when a file does not exist', () async{
      checkVerifyNever(file: createFileMock(isExist: false), result: SendResult.lostFile);
    });
  });

  group('close test', () {
    test('should be to call the close method when the send method return a success', () async{
      MockSendRepository mockRepo = setupConnectAndSend();
      MockFile mockFile = createFileMock();
      SendProvider provider = constructProvider(repository: mockRepo, file: mockFile);
      await provider.send();

      verify(mockRepo.close());
    });

    test('should be to call the close method when the send method throw exception', () async{
      MockSendRepository mockRepo = setupConnectAndSend();
      MockFile mockFile = createFileMock();
      SendProvider provider = constructProvider(repository: mockRepo, file: mockFile);
      when(mockRepo.send(any, any)).thenAnswer((_) => throw const OSError());
      await provider.send();

      verify(mockRepo.close());
    });
  });

  group('send file test', () {
    test('should be to call the close method when the send method return a success', () async{
      MockSendRepository mockRepo = setupConnectAndSend();
      MockFile mockFile = createFileMock(path: "file.file", data: "data");
      SendProvider provider = constructProvider(repository: mockRepo, file: mockFile);
      await provider.send();

      verify(mockRepo.send(any, <String, String>{
        "title": "file.file",
        "data": "100,97,116,97",
      }));
    });

    test('should be to call the close method when the send method return a success', () async{
      MockSendRepository mockRepo = setupConnectAndSend();
      MockFile mockFile = createFileMock(path: "file.file1", data: "data1");
      SendProvider provider = constructProvider(repository: mockRepo, file: mockFile);
      await provider.send();

      verify(mockRepo.send(any, <String, String>{
        "title": "file.file1",
        "data": "100,97,116,97,49",
      }));
    });

    test('should be parse to the base name', () async{
      MockSendRepository mockRepo = setupConnectAndSend();
      MockFile mockFile = createFileMock(path: "path/file.file1", data: "data1");
      SendProvider provider = constructProvider(repository: mockRepo, file: mockFile);
      await provider.send();

      verify(mockRepo.send(any, <String, String>{
        "title": "file.file1",
        "data": "100,97,116,97,49",
      }));
    });
  });
}
