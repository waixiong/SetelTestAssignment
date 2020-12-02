import 'package:Setel_Test_Assignment/util/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../viewmodel/google_map_model.dart';
import 'package:stacked/stacked.dart';

class GoogleMapPage extends StatelessWidget {
  const GoogleMapPage();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GoogleMapModel>.reactive(
        viewModelBuilder: () => GoogleMapModel(),
        onModelReady: (model) {
          //
        },
        builder: (context, model, __) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text('Pin Location'),
              actions: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () => model.saveLocationData(context),
                    child: Icon(Icons.save),
                  ),
                )
              ],
            ),
            body: Stack(
              children: <Widget>[
                model.position == null
                    ? SizedBox()
                    : model.isBusy
                        ? Center(
                          child: SizedBox(
                            height: 48, width: 48,
                            child: CircularProgressIndicator(),
                          ),
                        )
                        : Container(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: GoogleMap(
                              tiltGesturesEnabled: false,
                              mapType: MapType.normal,
                              compassEnabled: false,
                              markers: Set.from(model.allMarkers),
                              initialCameraPosition: CameraPosition(
                                target: position2LatLng(model.position),
                                zoom: 17.0,
                              ),
                              onMapCreated:
                                  (GoogleMapController controller) {
                                model.setMapController(controller);
                              },
                            ),
                          ),
              ],
            ),
          );
        });
  }
}
