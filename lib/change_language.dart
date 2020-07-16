import 'package:flutter/material.dart';
import 'package:moving_forward/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:moving_forward/localization.dart';
import 'package:moving_forward/layout.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale ?? Locale("en");
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code'));
    return Null;
  }

  void changeLanguage(Locale type) async {
    print(type);
    print(Locale("es"));
    print(_appLocale);
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    print('hola');
    if (type == Locale("es")) {
      print('esssssssssss');
      _appLocale = Locale("es");
      await prefs.setString('language_code', 'es');
      await prefs.setString('countryCode', 'ES');
    } else if (type == Locale("ar")) {
      print('arrrrrrrrrrr');
      _appLocale = Locale("ar");
      await prefs.setString('language_code', 'ar');
      await prefs.setString('countryCode', 'AR');
    } else if (type == Locale("fr")) {
      _appLocale = Locale("fr");
      await prefs.setString('language_code', 'fr');
      await prefs.setString('countryCode', 'FR');
    } else {
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    print(_appLocale);
    notifyListeners();
  }
}

class AppLang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('languages'),
              style: TextStyle(fontSize: 32),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale('en'));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationPage()));
                  },
                  child: Text('English'),
                ),
                RaisedButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale('es'));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationPage()));
                  },
                  child: Text('Español'),
                ),
                RaisedButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale('fr'));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationPage()));
                  },
                  child: Text('Français'),
                ),
                RaisedButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale('ar'));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationPage()));
                  },
                  child: Text('العربية.'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
