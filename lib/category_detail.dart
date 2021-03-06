import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moving_forward/services/localization.dart';
import 'package:moving_forward/models/category.dart';
import 'package:moving_forward/models/resource.dart';
import 'package:moving_forward/resource_detail.dart';
import 'package:moving_forward/services/db.dart';
import 'package:moving_forward/services/location.dart';
import 'package:moving_forward/state/favorites.dart';
import 'package:moving_forward/theme.dart';
import 'package:moving_forward/search.dart';
import 'package:moving_forward/utils.dart';
import 'package:flutter_matomo/flutter_matomo.dart';
import 'package:provider/provider.dart';

class CategoryDetail extends StatelessWidget {
  final _db = DBService.instance;
  final Category category;

  CategoryDetail({Key key, @required this.category}) : super(key: key) {
    initPage();
  }

  Future<void> initPage() async {
    await FlutterMatomo.trackScreenWithName(
        "CategoryDetail - ${this.category.name}", "Screen opened");
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(Search());
  }

  Container _categoryTitle() {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            child: SvgPicture.asset(
              'assets/images/categories/${category.icon}.svg',
              height: 72,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              category.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Text(
            category.description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          )
        ],
      )
    );
  }

  Card _resourceCard(BuildContext context, Resource resource) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 6,
      shadowColor: Colors.grey[100],
      child: new InkWell(
        onTap: () async {
          await FlutterMatomo.trackEventWithName(
              'CategoryDetail', '${category.name}/${resource.name}', 'Clicked');
          FlutterMatomo.dispatchEvents();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResourceDetailPage(resource: resource)),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (resource.lat != null && resource.long != null)
                      FutureBuilder<int>(
                          future: LocationService.instance
                              .getDistance(resource.lat, resource.long),
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            if (snapshot.data != null) {
                              return Container(
                                alignment: Alignment.topLeft,
                                child: Chip(
                                  backgroundColor: MfColors.primary[100],
                                  label: Text(
                                      "${AppLocalizations.of(context).translate('resource_distance')} ${getFormatedDistance(snapshot.data)}"),
                                ),
                              );
                            } else {
                              return Text('');
                            }
                          }),
                    Consumer<FavoritesState>(
                      builder: (context, favorites, child) {
                        if (favorites.isFavorite(resource.id)) {
                          return Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              color: MfColors.primary,
                              icon: Icon(Icons.bookmark, size: 30.0),
                              onPressed: () async {
                                await FlutterMatomo.trackEventWithName(
                                    'savedResources', 'remove', 'Clicked');
                                FlutterMatomo.dispatchEvents();
                                Provider.of<FavoritesState>(context,
                                        listen: false)
                                    .remove(resource.id);
                              },
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              color: MfColors.dark,
                              icon: Icon(Icons.bookmark_border_outlined,
                                  size: 30.0),
                              onPressed: () async {
                                await FlutterMatomo.trackEventWithName(
                                    'savedResources', 'save', 'Clicked');
                                FlutterMatomo.dispatchEvents();
                                Provider.of<FavoritesState>(context,
                                        listen: false)
                                    .add(resource.id);
                              },
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    resource.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (resource.description != '')
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Text(
                      resource.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                if (resource.address != '')
                  Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: MfColors.gray),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              resource.address,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _resourcesList(BuildContext context, List<Resource> resources) {
    final _resultCategory =
        AppLocalizations.of(context).translate("result_category");
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MfColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border.all(
                color: MfColors.white,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Text('${resources.length} $_resultCategory'),
                    ),
                    FutureBuilder<String>(
                      future: LocationService.instance.fetchCurrentLocality(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.data != null) {
                          return Text(
                              LocationService.instance.locality.toUpperCase());
                        } else {
                          return Text(AppLocalizations.of(context)
                              .translate('loading_location'));
                        }
                      },
                    ),
                  ],
                ),
                /* Text(
                  AppLocalizations.of(context).translate("change_category"),
                  style: TextStyle(
                    color: MfColors.primary[400],
                  ),
                ) */
              ],
            ),
          ),
          Container(
            color: MfColors.white,
            child: Column(
              children: resources
                  .map((resource) => Container(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: _resourceCard(context, resource)))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: MfColors.dark),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.search,
            size: 30,
            color: MfColors.dark,
          ),
          onPressed: () async {
            await FlutterMatomo.trackEvent(context, 'Search', 'Clicked');
            FlutterMatomo.dispatchEvents();
            _showOverlay(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appBar(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              color: Color(int.parse(category.color)),
              child: Column(
                children: [
                  _categoryTitle(),
                  FutureBuilder<List<Resource>>(
                      future: _db.listResourcesByCategory(
                          category.id,
                          LocationService.instance.locationLat,
                          LocationService.instance.locationLong,
                          lang: AppLocalizations.locale.languageCode),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Resource>> snapshot) {
                        if (snapshot.data != null) {
                          return _resourcesList(context, snapshot.data);
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Container(
              height: 100.0,
              child: _appBar(context),
            ),
          )
        ],
      ),
    );
  }
}
