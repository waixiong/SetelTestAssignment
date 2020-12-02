import 'package:Setel_Test_Assignment/view/widget/configCard.dart';
import 'package:Setel_Test_Assignment/viewmodel/geofencing_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';

class GeofencingPage extends StatelessWidget {
  final LocationData centerPoint;
  final int radius;
  final String ssid;

  GeofencingPage({this.centerPoint, this.radius, this.ssid});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GeofencingPageViewModel>.reactive(
      viewModelBuilder: () => GeofencingPageViewModel(centerPoint, radius, ssid),
      builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(model.inArea? 'Inside':'Outside'),
            backgroundColor: model.inArea? Colors.green : Colors.red,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: ConfigCard('Connected Wi-Fi', model.ssid, trailingWidget: Icon(Icons.wifi),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Row(
                  children: [
                    Expanded(child: ConfigCard(
                      'Location', 
                      model.location != null
                          ? '${model.location.latitude}, ${model.location.longitude}'
                          : 'Unknown location',
                    )),
                    SizedBox(width: 8,),
                    Expanded(child: ConfigCard('Distance', model.distance.toStringAsFixed(2)+' meters',)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}