import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/api_announcement.dart';

import 'package:my_server_status/services/http_requests.dart';
import 'package:my_server_status/models/app_log.dart';
import 'package:my_server_status/functions/encode_base64.dart';
import 'package:my_server_status/functions/snackbar.dart';
import 'package:my_server_status/models/server.dart';
import 'package:my_server_status/providers/servers_provider.dart';
import 'package:my_server_status/providers/app_config_provider.dart';

enum ConnectionType { http, https}

class AddServerModal extends StatefulWidget {
  final Server? server;
  final bool window;

  const AddServerModal({
    Key? key,
    this.server,
    required this.window
  }) : super(key: key);

  @override
  State<AddServerModal> createState() => _AddServerModalState();
}

class _AddServerModalState extends State<AddServerModal> {
  final uuid = const Uuid();

  final TextEditingController nameController = TextEditingController();
  String? nameError;

  ConnectionType connectionType = ConnectionType.http;

  final TextEditingController ipDomainController = TextEditingController();
  String? ipDomainError;

  final TextEditingController pathController = TextEditingController();
  String? pathError;

  final TextEditingController portController = TextEditingController();
  String? portError;

  final TextEditingController userController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool defaultServer = false;

  bool homeAssistant = false;

  bool allDataValid = false;

  bool isConnecting = false;

  Widget sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24, 
        vertical: 24
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary
        ),
      ),
    );
  }

  Widget textField({
    required String label,
    required TextEditingController controller,
    String? error,
    required IconData icon,
    TextInputType? keyboardType,
    Function(String)? onChanged,
    bool? obscureText,
    String? hintText,
    String? helperText
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          errorText: error,
          hintText: hintText,
          helperText: helperText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10)
            )
          ),
          labelText: label,
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  void checkDataValid() {
    if (
      nameController.text != '' &&
      ipDomainController.text != '' &&
      ipDomainError == null &&
      pathError == null && 
      portError == null && 
      (
        userController.text == "" && passwordController.text == "" ||
        userController.text != "" && passwordController.text == "" ||
        userController.text != "" && passwordController.text != ""
      )
    ) {
      setState(() {
        allDataValid = true;
      });
    }
    else {
      setState(() {
        allDataValid = false;
      });
    }
  }


  void validatePort(String? value) {
    if (value != null && value != '') {
      if (int.tryParse(value) != null && int.parse(value) <= 65535) {
        setState(() {
          portError = null;
        });
      }
      else {
        setState(() {
          portError = AppLocalizations.of(context)!.invalidPort;
        });
      }
    }
    else {
      setState(() {
        portError = null;
      });
    }
    checkDataValid();
  }

  void validateSubroute(String? value) {
    if (value != null && value != '') {
      RegExp subrouteRegexp = RegExp(r'^\/\b([A-Za-z0-9_\-~/]*)[^\/|\.|\:]$');
      if (subrouteRegexp.hasMatch(value) == true) {
        setState(() {
          pathError = null;
        });
      }
      else {
        setState(() {
          pathError = AppLocalizations.of(context)!.invalidPath;
        });
      }
    }
    else {
      setState(() {
        pathError = null;
      });
    }
    checkDataValid();
  }

  void validateAddress(String? value) {
    if (value != null && value != '') {
      RegExp ipAddress = RegExp(r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)(\.(?!$)|$)){4}$');
      RegExp domain = RegExp(r'^([a-z0-9|-]+\.)*[a-z0-9|-]+\.[a-z]+$');
      if (ipAddress.hasMatch(value) == true || domain.hasMatch(value) == true) {
        setState(() {
          ipDomainError = null;
        });
      }
      else {
        setState(() {
          ipDomainError = AppLocalizations.of(context)!.invalidIpDomain;
        });
      }
    }
    else {
      setState(() {
        ipDomainError = AppLocalizations.of(context)!.ipDomainNotEmpty;
      });
    }
    checkDataValid();
  }

  @override
  void initState() {
    if (widget.server != null) {
      nameController.text = widget.server!.name;
      connectionType = widget.server!.connectionMethod == 'https' ? ConnectionType.https : ConnectionType.http;
      ipDomainController.text = widget.server!.domain;
      pathController.text = widget.server!.path ?? '';
      portController.text = widget.server!.port != null ? widget.server!.port.toString() : "";
      userController.text = widget.server!.user ?? "";
      passwordController.text = widget.server!.password ?? "";
      defaultServer = widget.server!.defaultServer;
    }
    checkDataValid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context, listen: false);
    final appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);

    final mediaQuery = MediaQuery.of(context);

    void connect() async {
      Server serverObj = Server(
        id: uuid.v4(),
        name: nameController.text, 
        connectionMethod: connectionType.name, 
        domain: ipDomainController.text, 
        path: pathController.text,
        port: portController.text != '' ? int.parse(portController.text) : null,
        user: userController.text, 
        password: passwordController.text, 
        defaultServer: defaultServer,
        authToken: userController.text != "" && passwordController.text != ""
          ? encodeBase64UserPass(userController.text, passwordController.text)
          : null,
      );
      setState(() => isConnecting = true);

      final result = await login(serverObj);

      if (mounted) {
        setState(() => isConnecting = false);
      }
      else {
        isConnecting = false;
      }

      if (result['result'] == 'success') {
        if (serverObj.user != null && serverObj.password != null) {
          serverObj.authToken = encodeBase64UserPass(serverObj.user!, serverObj.password!);
        }
        final serverCreated = await serversProvider.createServer(serverObj);
        if (serverCreated == null) {
          if (!context.mounted) return;
          Navigator.pop(context);
        }
        else {
          appConfigProvider.addLog(
            AppLog(
              type: 'save_connection_db', 
              dateTime: DateTime.now(),
              message: serverCreated.toString()
            )
          );
          if (!context.mounted) return;
          showSnackbar(
            appConfigProvider: appConfigProvider, 
            label: AppLocalizations.of(context)!.connectionNotCreated, 
            color: Colors.red,
            labelColor: Colors.white
          );
        }
      }
      else if (result['result'] == 'invalid_username_password' && context.mounted) {
        appConfigProvider.addLog(result['log']);
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.invalidUsernamePassword, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
      else if (result['result'] == 'no_connection' && context.mounted) {
        appConfigProvider.addLog(result['log']);
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.cantReachServer, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
      else if (result['result'] == 'ssl_error' && context.mounted) {
        appConfigProvider.addLog(result['log']);
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.sslError, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
      else if (result['result'] == 'server_error' && context.mounted) {
        appConfigProvider.addLog(result['log']);       
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.serverError, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
      else {
        appConfigProvider.addLog(result['log']);
        if (!context.mounted) return;
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.unknownError, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
    }

    void edit() async {
      final Server serverObj = Server(
        id: widget.server!.id,
        name: nameController.text, 
        connectionMethod: connectionType.name, 
        domain: ipDomainController.text, 
        path: pathController.text,
        port: portController.text != '' ? int.parse(portController.text) : null,
        user: userController.text, 
        password: passwordController.text, 
        defaultServer: defaultServer,
        authToken: userController.text != "" && passwordController.text != ""
          ? encodeBase64UserPass(userController.text, passwordController.text)
          : null,
      );
      
      final result = await login(serverObj);

      if (result['result'] == 'success') {
        if (serverObj.user != null && serverObj.password != null) {
          serverObj.authToken = encodeBase64UserPass(serverObj.user!, serverObj.password!);
        }
        final serverSaved = await serversProvider.editServer(serverObj);
        if (serverSaved == null) {
          if (!context.mounted) return;
          Navigator.pop(context);
        }
        else {
          appConfigProvider.addLog(
            AppLog(
              type: 'edit_connection_db', 
              dateTime: DateTime.now(),
              message: serverSaved.toString()
            )
          );
          if (!context.mounted) return;
          showSnackbar(
            appConfigProvider: appConfigProvider, 
            label: AppLocalizations.of(context)!.connectionNotCreated, 
            color: Colors.red,
            labelColor: Colors.white
          );
        }
      }
      else if (result['result'] == 'invalid_username_password' && context.mounted) {
        appConfigProvider.addLog(result['log']);
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.invalidUsernamePassword, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
      else if (result['result'] == 'no_connection' && context.mounted) {
        appConfigProvider.addLog(result['log']);
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.cantReachServer, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
      else if (result['result'] == 'ssl_error' && context.mounted) {
        appConfigProvider.addLog(result['log']);
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.sslError, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
      else if (result['result'] == 'server_error' && context.mounted) {
        appConfigProvider.addLog(result['log']);
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.serverError, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
      else {
        appConfigProvider.addLog(result['log']);
        if (!context.mounted) return;
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.unknownError, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
    }

    void openApiAnnouncementModal() {
      showDialog(
        context: context, 
        builder: (context) => ApiAnnouncementModal(
          onConfirm: () => {}   // do nothing
        )
      );
    }

    List<Widget> widgetsList() {
      return [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary
            )
          ),
          child: Text(
            "${connectionType.name}://${ipDomainController.text}${portController.text != '' ? ':${portController.text}' : ""}${pathController.text}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
        sectionLabel(AppLocalizations.of(context)!.general),
        textField(
          label: AppLocalizations.of(context)!.name, 
          controller: nameController, 
          icon: Icons.badge_rounded,
          error: nameError,
          onChanged: (value) {
            if (value != '') {
              setState(() => nameError = null);
            }
            else {
              setState(() => nameError = AppLocalizations.of(context)!.nameNotEmpty);
            } 
            checkDataValid();
          }
        ),
        sectionLabel(AppLocalizations.of(context)!.connection),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SegmentedButton<ConnectionType>(
            segments: const [
              ButtonSegment(
                value: ConnectionType.http,
                label: Text("HTTP")
              ),
              ButtonSegment(
                value: ConnectionType.https,
                label: Text("HTTPS")
              ),
            ], 
            selected: <ConnectionType>{connectionType},
            onSelectionChanged: (value) => setState(() => connectionType = value.first),
          ),
        ),
        const SizedBox(height: 30),
        textField(
          label: AppLocalizations.of(context)!.ipDomain, 
          controller: ipDomainController, 
          icon: Icons.link_rounded,
          error: ipDomainError,
          keyboardType: TextInputType.url,
          onChanged: validateAddress
        ),
        const SizedBox(height: 20),
        textField(
          label: AppLocalizations.of(context)!.path, 
          controller: pathController, 
          icon: Icons.route_rounded,
          error: pathError,
          onChanged: validateSubroute,
          hintText: AppLocalizations.of(context)!.examplePath,
          helperText: AppLocalizations.of(context)!.helperPath,
        ),
        const SizedBox(height: 20),
        textField(
          label: AppLocalizations.of(context)!.port, 
          controller: portController, 
          icon: Icons.numbers_rounded,
          error: portError,
          keyboardType: TextInputType.number,
          onChanged: validatePort
        ),
        sectionLabel(AppLocalizations.of(context)!.authentication),
        textField(
          label: AppLocalizations.of(context)!.username, 
          controller: userController, 
          icon: Icons.person_rounded,
        ),
        const SizedBox(height: 20),
        textField(
          label: AppLocalizations.of(context)!.password, 
          controller: passwordController, 
          icon: Icons.lock_rounded,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true
        ),
        sectionLabel(AppLocalizations.of(context)!.other),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.server == null
              ? () => setState(() => defaultServer = !defaultServer)
              : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.defaultServer,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Switch(
                    value: defaultServer, 
                    onChanged: widget.server == null 
                      ? (value) => setState(() => defaultServer = value)
                      : null,
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ];
    }

    if (widget.window == true) {
      return Dialog(
        child: SizedBox(
          width: 400,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context), 
                          icon: const Icon(Icons.clear_rounded)
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.createConnection,
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: widget.server == null 
                        ? AppLocalizations.of(context)!.connect
                        : AppLocalizations.of(context)!.save,
                      onPressed: allDataValid == true 
                        ? widget.server == null 
                          ? () => connect()
                          : () => edit()
                        : null,
                      icon: Icon(
                        widget.server == null
                          ? Icons.login_rounded
                          : Icons.save_rounded
                      )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: widgetsList()
                ),
              )
            ],
          ),
        ),
      );
    }
    else {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.createConnection),
              actions: [
                IconButton(
                  onPressed: openApiAnnouncementModal, 
                  icon: const Icon(Icons.warning_amber_rounded)
                ),
                IconButton(
                  tooltip: widget.server == null 
                    ? AppLocalizations.of(context)!.connect
                    : AppLocalizations.of(context)!.save,
                  onPressed: allDataValid == true 
                    ? widget.server == null 
                      ? () => connect()
                      : () => edit()
                    : null,
                  icon: Icon(
                    widget.server == null
                      ? Icons.login_rounded
                      : Icons.save_rounded
                  )
                ),
                const SizedBox(width: 10)
              ],
              toolbarHeight: 70,
            ),
            body: ListView(
              children: widgetsList(),
            )
          ),
          AnimatedOpacity(
            opacity: isConnecting == true ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: IgnorePointer(
              ignoring: isConnecting == true ? false : true,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                  width: mediaQuery.size.width,
                  height: mediaQuery.size.height,
                  color: const Color.fromRGBO(0, 0, 0, 0.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        AppLocalizations.of(context)!.connecting,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 26
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }
  }
}