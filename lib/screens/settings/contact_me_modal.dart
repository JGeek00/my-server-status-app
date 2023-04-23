import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/functions/open_url.dart';
import 'package:my_server_status/constants/app_icons.dart';
import 'package:my_server_status/constants/urls.dart';

class ContactMeModal extends StatefulWidget {
  const ContactMeModal({Key? key}) : super(key: key);

  @override
  State<ContactMeModal> createState() => _ContactMeModalState();
}

class _ContactMeModalState extends State<ContactMeModal> {
  final expandableController = ExpandableController();

  void _sendEmail() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries.map((MapEntry<String, String> e) => 
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Urls.issueEmail,
      query: encodeQueryParameters(<String, String>{
        'subject': 'My Server Status',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(0),
      title: Column(
        children: [
          Icon(
            Icons.contact_page_rounded,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              AppLocalizations.of(context)!.contact,
              style: const TextStyle(
                fontSize: 24
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: width > 400 ? 400 : width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => openUrl(Urls.gitHub),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10, 
                    horizontal: 20
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        MyServerStatusIcons.github,
                        size: 25,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "GitHub",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.openIssueGitHub,
              
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            ExpandableNotifier(
              controller: expandableController,
              child: Expandable(
                collapsed: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => expandableController.toggle(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10, 
                        horizontal: 20
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.email_rounded,
                            size: 24,
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                AppLocalizations.of(context)!.writeEmail,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                expanded: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => expandableController.toggle(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10, 
                        horizontal: 20
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.email_rounded,
                                size: 24,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Email",
                                    style: TextStyle(
                                      fontSize: 16
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    AppLocalizations.of(context)!.writeEmail,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary
                              )
                            ),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.writeEmailDetails,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: _sendEmail, 
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(0),
                                        backgroundColor: MaterialStateProperty.all(
                                          Theme.of(context).colorScheme.primary
                                        ),
                                        foregroundColor: MaterialStateProperty.all(
                                          Theme.of(context).dialogBackgroundColor
                                        ),
                                        overlayColor: MaterialStateProperty.all(
                                          Theme.of(context).dialogBackgroundColor.withOpacity(0.1)
                                        ),
                                        
                                      ),
                                      child: Text(AppLocalizations.of(context)!.contactEmail)
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: Text(AppLocalizations.of(context)!.close)
        )
      ],
    );
  }
}