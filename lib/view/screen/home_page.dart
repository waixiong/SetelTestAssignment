import 'package:Setel_Test_Assignment/view/widget/configCard.dart';
import 'package:Setel_Test_Assignment/viewmodel/home_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ViewModelBuilder<HomePageViewModel>.reactive(
        viewModelBuilder: () => HomePageViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: ConfigCard(
                  'Current Wi-Fi', model.ssid != null
                      ? model.ssid
                      : 'No Wi-Fi',
                  trailingWidget: GestureDetector(
                    onTap: model.changeWifi,
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(Icons.wifi),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: ConfigCard(
                  'Geo Position', 
                  model.position != null
                      ? '${model.position.latitude}, ${model.position.longitude}'
                      : 'Unknown Position',
                  trailingWidget: GestureDetector(
                    onTap: model.changeGeoPosition,
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(Icons.location_on),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: ConfigCard(
                  'Radius', 
                  '${model.radius} meters',
                  trailingWidget: GestureDetector(
                    onTap: () => model.changeRadius(context),
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(Icons.radio_button_on),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: RaisedButton(
                  onPressed: model.startGeofence,
                  child: Text('Start Geofence '),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}