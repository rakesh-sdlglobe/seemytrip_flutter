import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../controllers/view_train_routes_controller.dart';

class ViewTrainRoutes extends StatelessWidget {

  ViewTrainRoutes({required this.trainNumber, required this.fromStation, required this.toStation}) {
    viewRouteController.fetchTrainSchedule(trainNumber);
  }
  final String trainNumber;
  final String fromStation;
  final String toStation;
  final ViewTrainRoutesController viewRouteController = Get.put(ViewTrainRoutesController());


  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Obx(() => Text(
              viewRouteController.trainSchedule['trainName'] ?? 'Train Routes',
              style: TextStyle(color: Colors.white),
            )),
        centerTitle: true,
        backgroundColor: AppColors.redCA0,
        foregroundColor: AppColors.white,
        elevation: 1,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Divider(thickness: 1, color: Colors.grey.shade300),
          Obx(() {
            if (viewRouteController.trainSchedule.isEmpty) {
              return Text('Running Days: N/A', style: TextStyle(fontSize: 16));
            }
            return Text(
              "Running Days: ${viewRouteController.trainSchedule['trainRunsOnMon'] == 'Y' ? 'M ' : ''}"
              "${viewRouteController.trainSchedule['trainRunsOnTue'] == 'Y' ? 'T ' : ''}"
              "${viewRouteController.trainSchedule['trainRunsOnWed'] == 'Y' ? 'W ' : ''}"
              "${viewRouteController.trainSchedule['trainRunsOnThu'] == 'Y' ? 'T ' : ''}"
              "${viewRouteController.trainSchedule['trainRunsOnFri'] == 'Y' ? 'F ' : ''}"
              "${viewRouteController.trainSchedule['trainRunsOnSat'] == 'Y' ? 'S ' : ''}"
              "${viewRouteController.trainSchedule['trainRunsOnSun'] == 'Y' ? 'S ' : ''}",
              style: TextStyle(fontSize: 16),
            );
          }),
          Divider(thickness: 1, color: Colors.grey.shade300),
          Expanded(
            child: Obx(() {
              if (viewRouteController.isLoading.value) {
                return Center(child: LoadingAnimationWidget.fourRotatingDots(color: AppColors.white, size: 20));
              }
              if (viewRouteController.trainSchedule.isEmpty) {
                return Center(child: Text('No data available'));
              }

              final stationList = viewRouteController.trainSchedule['stationList'];

              return Timeline.tileBuilder(
                theme: TimelineThemeData(
                  nodePosition: 0.1,
                  connectorTheme: ConnectorThemeData(
                    thickness: 2.0,
                    color: Colors.grey.shade400,
                  ),
                ),
                builder: TimelineTileBuilder.connected(
                  connectionDirection: ConnectionDirection.before,
                  itemCount: stationList.length,
                  contentsBuilder: (_, int index) {
                    final stop = stationList[index];
                    final bool isFirst = stop['stationName'] == fromStation;
                    final bool isLast = stop['stationName'] == toStation;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Card(
                        color: isFirst
                            ? AppColors.redCA0.withOpacity(0.1)
                            : isLast
                                ? AppColors.blueCA0.withOpacity(0.1)
                                : Colors.white,
                        elevation: 2,
                        margin: EdgeInsets.fromLTRB(8, 0, 12, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                stop['stationName']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isFirst || isLast ? 16 : 14,
                                  color: isFirst
                                      ? AppColors.redCA0
                                      : isLast
                                          ? AppColors.blueCA0
                                          : Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Arr: ${stop['arrivalTime']}", style: TextStyle(fontSize: 12)),
                                  Text("Dep: ${stop['departureTime']}", style: TextStyle(fontSize: 12)),
                                  Text("Halt: ${stop['haltTime']} min", style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Distance: ${stop['distance']} km", style: TextStyle(fontSize: 12)),
                                  Text("Day: ${stop['dayCount']}", style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  indicatorBuilder: (_, int index) {
                    final stop = stationList[index];
                    final bool isFirst = stop['stationName'] == fromStation;
                    final bool isLast = stop['stationName'] == toStation;

                    return DotIndicator(
                      size: 24,
                      color: isFirst ? Colors.red : isLast ? Colors.blue : Colors.grey,
                      child: Icon(
                        isFirst || isLast ? Icons.train : Icons.circle,
                        color: Colors.white,
                        size: 16,
                      ),
                    );
                  },
                  connectorBuilder: (_, int index, __) => SolidLineConnector(),
                ),
              );
            }),
          ),
        ],
      ),
    );
}
