<h1 align="center">
  <img src="https://github.com/JGeek00/my-server-status-app/raw/master/assets/other/banner.png" />
</h1>

<h5 align="center">
  My Server Status allows you to monitor your server from your mobile phone.
</h5>

<br>
<p>
❗️ <b>IMPORTANT</b> ❗️
<br>
This application gets the information from an external API. You must deploy the API to your server to use this application. Check <a href="https://github.com/JGeek00/my-server-status-api">this repository</a> to learn more.
<br>
<br>
This application is intended to monitor your own machine. Don not try to use it with an AWS server or similar.
</p>

<br>

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.jgeek00.my_server_status" target="_blank" rel="noopener noreferrer">
    <img src="/assets/other/get_google_play.png" width="300px">
  </a>
  <a href="https://github.com/JGeek00/my-server-status-app/releases" target="_blank" rel="noopener noreferrer">
    <img src="/assets/other/get-github.png" width="300px">
  </a>
</p>

<br>

## Features
<p>▶️ Monitor the CPU usage, CPU temperature, memory usage, storage and network from your device.</p>
<p>▶️ Monitor multiple servers from the same device.</p>
<p>▶️ User interface following the Material 3 guidelines.</p>
<p>▶️ Dynamic theme (requires Android 12+).</p>
<p>▶️ Monochrome icon available.</p>
<p>▶️ Respects the user's privacy.</p>
<p>And much more to come!</p>

<br>

## Privacy policy
You can check the privacy policy [here](https://github.com/JGeek00/my-server-status-app/wiki/Privacy-policy).

<br>

## Generate production build
<ul>
  <li>
    <b>macOS</b>
    <ol>  
      <li>flutter clean</li>
      <li>flutter pub get</li>
      <li>flutter build macos --release</li>
      <li>Open macos/Runner.xcworkspace on Xcode</li>
      <li>Make sure all the pods have the minimum deployment version at 10.14</li>
      <li>Select Runner > Targets Runner</li>
      <li>Make sure the Version and Build numbers are correct</li>
      <li>Click on Product menu and on Archive</li>
      <li>Select the first on the list and click on Distribute app, select Copy App and click on Next</li>
    </ol>
  </li>
  <li>
    <b>Linux</b>
    <ul>
      <b>Prerequisites</b>
      <ol>
        <li>Install rps by running <code>dart pub global activate rps --version 0.7.0-dev.6</code></li>
      </ol>
      <b>Build</b>
      <ol>
        <li>Open debian.yaml file inside debian/ and update the version number</li>
        <li>run <code>rps build linux</code></li>
        <li>The .tar.gz is at build/linux/x64/release/bundle</li>
        <li>The .deb package is at debian/packages</li>
      </ol>
    </ul>
  </li>
  <li>
    <b>Windows</b>
    <ol>
      <li>flutter clean</li>
      <li>flutter pub get</li>
      <li>flutter build windows</li>
      <li>Open Inno Setup Compiler application and load the script</li>
      <li>The script is located at windows/innosetup_build_installer.iss</li>
      <li>Update the version number and save the changes</li>
      <li>Click on the Compile button</li>
      <li>The installer will be generated at build/windows/my_server_status_installer.exe</li>
    </ol>
  </li>
</ul>

<br>

## Third party libraries
- [provider](https://pub.dev/packages/provider)
- [sqflite](https://pub.dev/packages/sqflite)
- [http](https://pub.dev/packages/http)
- [expandable](https://pub.dev/packages/expandable)
- [package info plus](https://pub.dev/packages/package_info_plus)
- [flutter phoenix](https://pub.dev/packages/flutter_phoenix)
- [flutter displaymode](https://pub.dev/packages/flutter_displaymode)
- [flutter launcher icons](https://pub.dev/packages/flutter_launcher_icons)
- [flutter native splash](https://pub.dev/packages/flutter_native_splash)
- [intl](https://pub.dev/packages/intl)
- [animations](https://pub.dev/packages/animations)
- [dynamic color](https://pub.dev/packages/dynamic_color)
- [device info](https://pub.dev/packages/device_info)
- [flutter web browser](https://pub.dev/packages/flutter_web_browser)
- [flutter svg](https://pub.dev/packages/flutter_svg)
- [percent indicator](https://pub.dev/packages/percent_indicator)
- [url launcher](https://pub.dev/packages/url_launcher)


<br>
<br>
<br>
<br>
<b>Created by JGeek00</b>