import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:my_server_status/models/docker_information.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:my_server_status/models/app_log.dart';
import 'package:my_server_status/models/current_status.dart';
import 'package:my_server_status/models/general_info.dart';
import 'package:my_server_status/models/server.dart';
import 'package:my_server_status/models/system_specs_info.dart';

Future<Map<String, dynamic>> apiRequest({
  required Server server, 
  required String method, 
  required String urlPath, 
  dynamic body,
  required String type,
  bool? overrideTimeout,
}) async {
  final String connectionString = "${server.connectionMethod}://${server.domain}${server.port != null ? ':${server.port}' : ""}${server.path ?? ""}$urlPath";
  try {
    HttpClient httpClient = HttpClient();
    if (method == 'get') {
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(connectionString));
      if (server.authToken != null) {
        request.headers.set('Authorization', server.authToken!);
      }
      HttpClientResponse response = overrideTimeout == true 
        ? await request.close()
        : await request.close().timeout(const Duration(seconds: 10));
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      if (response.statusCode == 200) {
        return {
          'hasResponse': true,
          'error': false,
          'statusCode': response.statusCode,
          'body': reply
        };
      }
      else {
        return {
          'hasResponse': true,
          'error': true,
          'statusCode': response.statusCode,
          'body': reply
        };
      }    
    }
    else if (method == 'post') {
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(connectionString));
      if (server.authToken != null) {
        request.headers.set('Authorization', server.authToken!);
      }
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(body)));
      HttpClientResponse response = overrideTimeout == true 
        ? await request.close()
        : await request.close().timeout(const Duration(seconds: 10));
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      if (response.statusCode == 200) {
        return {
          'hasResponse': true,
          'error': false,
          'statusCode': response.statusCode,
          'body': reply
        };
      }
      else {
        return {
          'hasResponse': true,
          'error': true,
          'statusCode': response.statusCode,
          'body': reply
        };
      }    
    }
    else {
      throw Exception('Method is required');
    }
  } on SocketException {
    return {
      'result': 'no_connection', 
      'message': 'SocketException',
      'log': AppLog(
        type: type, 
        dateTime: DateTime.now(), 
        message: 'SocketException'
      )
    };
  } on TimeoutException {
    return {
      'result': 'no_connection', 
      'message': 'TimeoutException',
      'log': AppLog(
        type: type, 
        dateTime: DateTime.now(), 
        message: 'TimeoutException'
      )
    };
  } on HandshakeException {
    return {
      'result': 'ssl_error', 
      'message': 'HandshakeException',
      'log': AppLog(
        type: type, 
        dateTime: DateTime.now(), 
        message: 'HandshakeException'
      )
    };
  } catch (e) {
    Sentry.captureException(e);
    return {
      'result': 'error', 
      'message': e.toString(),
      'log': AppLog(
        type: type, 
        dateTime: DateTime.now(), 
        message: e.toString()
      )
    };
  }
}

Future<http.Response> getRequest(Server server, String urlPath) {
  final String connectionString = "${server.connectionMethod}://${server.domain}${server.port != null ? ':${server.port}' : ""}${server.path ?? ""}$urlPath";
  return http.get(Uri.parse(connectionString), headers: {
    if (server.authToken != null) 'Authorization': server.authToken!
  });
}

Future login(Server server) async {
  final result = await apiRequest(
    server: server,
    method: 'get',
    urlPath: '/v1/check-credentials', 
    type: 'login'
  );

  if (result['hasResponse'] == true) {
    if (result['statusCode'] == 200) {
      return {'result': 'success'};
    }
    else if (result['statusCode'] == 401) {
      return {
        'result': 'invalid_username_password',
        'log': AppLog(
          type: 'login', 
          dateTime: DateTime.now(), 
          message: 'invalid_username_password',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
    else if (result['statusCode'] == 500) {
      return {
        'result': 'server_error',
        'log': AppLog(
          type: 'login', 
          dateTime: DateTime.now(), 
          message: 'server_error',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
    else {
      return {
        'result': 'error',
        'log': AppLog(
          type: 'login', 
          dateTime: DateTime.now(), 
          message: 'error_code_not_expected',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
  }
  else {
    return result;
  }
}

Future getHardwareInfo({required Server server, required bool overrideTimeout}) async {
  final result = await apiRequest(
    server: server,
    method: 'get',
    urlPath: '/v1/general-info', 
    type: 'general_info',
    overrideTimeout: overrideTimeout
  );

  if (result['hasResponse'] == true) {
    if (result['statusCode'] == 200) {
      try {
        return {
          'result': 'success',
          'data': GeneralInfo.fromJson(jsonDecode(result['body']))
        };
      } catch (e) {
        Sentry.captureException(e);
        return {
          'result': 'error',
          'log': AppLog(
            type: 'general_info', 
            dateTime: DateTime.now(), 
            message: 'error_code_not_expected',
            statusCode: result['statusCode'].toString(),
            resBody: result['body']
          )
        };
      }
    }
    else if (result['statusCode'] == 401) {
      return {
        'result': 'invalid_username_password',
        'log': AppLog(
          type: 'general_info', 
          dateTime: DateTime.now(), 
          message: 'invalid_username_password',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
    else if (result['statusCode'] == 500) {
      return {
        'result': 'server_error',
        'log': AppLog(
          type: 'general_info', 
          dateTime: DateTime.now(), 
          message: 'server_error',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
    else {
      return {
        'result': 'error',
        'log': AppLog(
          type: 'general_info', 
          dateTime: DateTime.now(), 
          message: 'error_code_not_expected',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
  }
  else {
    return result;
  }
}

Future getSystemInformation({required Server server, required bool overrideTimeout}) async {
  final result = await Future.wait([
    apiRequest(server: server, method: 'get', urlPath: '/v1/system', type: 'get_system_information', overrideTimeout: overrideTimeout),
    apiRequest(server: server, method: 'get', urlPath: '/v1/cpu', type: 'get_system_information', overrideTimeout: overrideTimeout),
    apiRequest(server: server, method: 'get', urlPath: '/v1/memory', type: 'get_system_information', overrideTimeout: overrideTimeout),
    apiRequest(server: server, method: 'get', urlPath: '/v1/storage', type: 'get_system_information', overrideTimeout: overrideTimeout),
    apiRequest(server: server, method: 'get', urlPath: '/v1/network', type: 'get_system_information', overrideTimeout: overrideTimeout),
    apiRequest(server: server, method: 'get', urlPath: '/v1/os', type: 'get_system_information', overrideTimeout: overrideTimeout),
  ]);

  if (
    result[0]['hasResponse'] == true &&
    result[1]['hasResponse'] == true &&
    result[2]['hasResponse'] == true &&
    result[3]['hasResponse'] == true &&
    result[4]['hasResponse'] == true &&
    result[5]['hasResponse'] == true 
  ) {
    if (
      result[0]['statusCode'] == 200 &&
      result[1]['statusCode'] == 200 &&
      result[2]['statusCode'] == 200 &&
      result[3]['statusCode'] == 200 &&
      result[4]['statusCode'] == 200 &&
      result[5]['statusCode'] == 200
    ) {
      try {
        final Map<String, dynamic> mappedData = {
          'systemInfo': jsonDecode(result[0]['body']),
          'cpuInfo': jsonDecode(result[1]['body']),
          'memoryInfo': jsonDecode(result[2]['body']),
          'storageInfo': jsonDecode(result[3]['body']),
          'networkInfo': jsonDecode(result[4]['body']),
          'osInfo': jsonDecode(result[5]['body']),
        };
        return {
          'result': 'success',
          'data': SystemSpecsInformationData.fromJson(mappedData)
        };
      } catch (e) {
        Sentry.captureException(e);
        return {
          'result': 'error',
          'log': AppLog(
            type: 'get_system_information', 
            dateTime: DateTime.now(), 
            message: 'no_response',
            statusCode: result.map((res) => res['statusCode'] ?? 'null').toString(),
            resBody: result.map((res) => res['body'] ?? 'null').toString()
          )
        };
      }
    }
    else {
      return {
        'result': 'error',
        'log': AppLog(
          type: 'get_system_information', 
          dateTime: DateTime.now(), 
          message: 'error_code_not_expected',
          statusCode: result.map((res) => res['statusCode']).toString(),
          resBody: result.map((res) => res['body']).toString()
        )
      };
    }
  }
  else {
    return {
      'result': 'error',
      'log': AppLog(
        type: 'get_system_information', 
        dateTime: DateTime.now(), 
        message: 'no_response',
        statusCode: result.map((res) => res['statusCode'] ?? 'null').toString(),
        resBody: result.map((res) => res['body'] ?? 'null').toString()
      )
    };
  }
}

Future getCurrentStatus({required Server server, required bool overrideTimeout}) async {
  final result = await apiRequest(
    server: server,
    method: 'get',
    urlPath: '/v1/status', 
    type: 'status',
    overrideTimeout: overrideTimeout
  );

  if (result['hasResponse'] == true) {
    if (result['statusCode'] == 200) {
      try {
        return {
          'result': 'success',
          'data': CurrentStatus.fromJson(jsonDecode(result['body']))
        };
      } catch (e) {
        Sentry.captureException(e);
        return {
          'result': 'error',
          'log': AppLog(
            type: 'status', 
            dateTime: DateTime.now(), 
            message: 'error_code_not_expected',
            statusCode: result['statusCode'].toString(),
            resBody: result['body']
          )
        };
      }
    }
    else if (result['statusCode'] == 401) {
      return {
        'result': 'invalid_username_password',
        'log': AppLog(
          type: 'status', 
          dateTime: DateTime.now(), 
          message: 'invalid_username_password',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
    else if (result['statusCode'] == 500) {
      return {
        'result': 'server_error',
        'log': AppLog(
          type: 'stauts', 
          dateTime: DateTime.now(), 
          message: 'server_error',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
    else {
      return {
        'result': 'error',
        'log': AppLog(
          type: 'status', 
          dateTime: DateTime.now(), 
          message: 'error_code_not_expected',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
  }
  else {
    return result;
  }
}

Future getApiVersion({required Server server}) async {
  final result = await apiRequest(
    server: server,
    method: 'get',
    urlPath: '/v1/api-version', 
    type: 'api-version',
  );

  if (result['hasResponse'] == true) {
    if (result['statusCode'] == 200) {
      return {
        'result': 'success',
        'data': result['body']
      };
    }
    else if (result['statusCode'] == 401) {
      return {
        'result': 'invalid_username_password',
        'log': AppLog(
          type: 'api-version', 
          dateTime: DateTime.now(), 
          message: 'invalid_username_password',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
    else if (result['statusCode'] == 500) {
      return {
        'result': 'server_error',
        'log': AppLog(
          type: 'api-version', 
          dateTime: DateTime.now(), 
          message: 'server_error',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
    else {
      return {
        'result': 'error',
        'log': AppLog(
          type: 'api-version', 
          dateTime: DateTime.now(), 
          message: 'error_code_not_expected',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
  }
  else {
    return result;
  }
}

Future<bool> requestPowerOff({
  required Server server
}) async {
  try {
    final result = await http.get(
      Uri.parse("${server.connectionMethod}://${server.domain}${server.port != null ? ':${server.port}' : ""}${server.path ?? ""}/v1/shutdown"),
      headers: {
        'Authorization': server.authToken!
      }
    );

    if (result.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  } 
  catch (e) {
    // The server powers off before the API can send the response back to the client
    if (e.toString() == 'Connection closed before full header was received') {
      return true;
    }
    else {
      return false;
    }
  }
}

Future<bool> requestReboot({
  required Server server
}) async {
  try {
    final result = await http.get(
      Uri.parse("${server.connectionMethod}://${server.domain}${server.port != null ? ':${server.port}' : ""}${server.path ?? ""}/v1/reboot"),
      headers: {
        'Authorization': server.authToken!
      }
    );

    if (result.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  } 
  catch (e) {
    // The server reboots before the API can send the response back to the client
    if (e.toString() == 'Connection closed before full header was received') {
      return true;
    }
    else {
      return false;
    }
  }
}

Future getDockerInfo({required Server server}) async {
  final result = await apiRequest(
    server: server,
    method: 'get',
    urlPath: '/v1/docker/information', 
    type: 'status',
  );

  if (result['hasResponse'] == true) {
    if (result['statusCode'] == 200) {
      try {
        return {
          'result': 'success',
          'data': DockerInformation.fromJson(jsonDecode(result['body']))
        };
      } catch (e) {
        Sentry.captureException(e);
        return {
          'result': 'error',
          'log': AppLog(
            type: 'docker_information', 
            dateTime: DateTime.now(), 
            message: 'error_code_not_expected',
            statusCode: result['statusCode'].toString(),
            resBody: result['body']
          )
        };
      }
    }
    else if (result['statusCode'] == 401) {
      return {
        'result': 'invalid_username_password',
        'log': AppLog(
          type: 'docker_information', 
          dateTime: DateTime.now(), 
          message: 'invalid_username_password',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
    else if (result['statusCode'] == 500) {
      return {
        'result': 'server_error',
        'log': AppLog(
          type: 'docker_information', 
          dateTime: DateTime.now(), 
          message: 'server_error',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
    else {
      return {
        'result': 'error',
        'log': AppLog(
          type: 'docker_information', 
          dateTime: DateTime.now(), 
          message: 'error_code_not_expected',
          statusCode: result['statusCode'].toString(),
          resBody: result['body']
        )
      };
    }
  }
  else {
    return result;
  }
}