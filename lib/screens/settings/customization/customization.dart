import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/settings/customization/theme_mode_button.dart';
import 'package:my_server_status/widgets/custom_switch_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/constants/colors.dart';
import 'package:my_server_status/functions/generate_color_translation.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/screens/settings/customization/color_item.dart';

class Customization extends StatelessWidget {
  const Customization({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    return CustomizationWidget(
      appConfigProvider: appConfigProvider
    );
  }
}

class CustomizationWidget extends StatefulWidget {
  final AppConfigProvider appConfigProvider;

  const CustomizationWidget({
    Key? key,
    required this.appConfigProvider,
  }) : super(key: key);

  @override
  State<CustomizationWidget> createState() => _CustomizationWidgetState();
}

class _CustomizationWidgetState extends State<CustomizationWidget> {
  int selectedTheme = 0;
  bool dynamicColor = true;
  int selectedColor = 0;
  bool useThemeColorInsteadGreenRed = false;

  @override
  void initState() {
    selectedTheme = widget.appConfigProvider.selectedThemeNumber;
    dynamicColor = widget.appConfigProvider.useDynamicColor;
    selectedColor = widget.appConfigProvider.staticColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.customization),
      ),
      body: ListView(
        children: [
          SectionLabel(
            label: AppLocalizations.of(context)!.theme,
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 5),
          ),
          Column(
            children: [
              CustomSwitchListTile(
                value: selectedTheme == 0 ? true : false, 
                onChanged: (value) {
                  selectedTheme = value == true ? 0 : 1;
                  appConfigProvider.setSelectedTheme(value == true ? 0 : 1);
                },
                title: AppLocalizations.of(context)!.systemDefined, 
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ThemeModeButton(
                    icon: Icons.light_mode, 
                    value: 1, 
                    selected: selectedTheme, 
                    label: AppLocalizations.of(context)!.light, 
                    onChanged: (value) {
                      selectedTheme = value;
                      appConfigProvider.setSelectedTheme(value);
                    },
                    disabled: selectedTheme == 0 ? true : false,
                  ),
                  ThemeModeButton(
                    icon: Icons.dark_mode, 
                    value: 2, 
                    selected: selectedTheme, 
                    label: AppLocalizations.of(context)!.dark, 
                    onChanged: (value) {
                      selectedTheme = value;
                      appConfigProvider.setSelectedTheme(value);
                    },
                    disabled: selectedTheme == 0 ? true : false,
                  ),
                ],
              ),
            ],
          ),
          SectionLabel(
            label: AppLocalizations.of(context)!.color,
            padding: const EdgeInsets.only(top: 45, left: 16, right: 16, bottom: 5),
          ),
          if (appConfigProvider.androidDeviceInfo != null && appConfigProvider.androidDeviceInfo!.version.sdkInt >= 31) CustomSwitchListTile(
            value: dynamicColor, 
            onChanged: (value) {
              setState(() => dynamicColor = value);
              appConfigProvider.setUseDynamicColor(value);
            }, 
            title: AppLocalizations.of(context)!.useDynamicTheme, 
          ),
          if (!(appConfigProvider.androidDeviceInfo != null && appConfigProvider.androidDeviceInfo!.version.sdkInt >= 31)) const SizedBox(height: 20),
          if (dynamicColor == false) ...[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Row(
                      children: [
                        const SizedBox(width: 8),
                        ColorItem(
                          color: colors[index], 
                          numericValue: index, 
                          selectedValue: selectedColor,
                          onChanged: (value) {
                            setState(() => selectedColor = value);
                            appConfigProvider.setStaticColor(value);
                          }
                        ),
                      ],
                    );
                  }
                  else if (index == colors.length-1) {
                    return Row(
                      children: [
                        ColorItem(
                          color: colors[index], 
                          numericValue: index, 
                          selectedValue: selectedColor,
                          onChanged: (value) {
                            setState(() => selectedColor = value);
                            appConfigProvider.setStaticColor(value);
                          }
                        ),
                        const SizedBox(width: 8)
                      ],
                    );
                  }
                  else {
                    return ColorItem(
                      color: colors[index], 
                      numericValue: index, 
                      selectedValue: selectedColor,
                      onChanged: (value) {
                        setState(() => selectedColor = value);
                        appConfigProvider.setStaticColor(value);
                      }
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                top: 10
              ),
              child: Text(
                colorTranslation(context, selectedColor),
                style: TextStyle(
                  color: Theme.of(context).listTileTheme.iconColor,
                  fontSize: 16
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}