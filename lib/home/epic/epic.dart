import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nasa_app/home/epic/epic_provider.dart';
import 'package:nasa_app/widgets/dynamic_shimmer.dart';
import 'package:provider/provider.dart';

class EPICScreen extends StatefulWidget {
  const EPICScreen({super.key});

  @override
  State<EPICScreen> createState() => _EPICScreenState();
}

class _EPICScreenState extends State<EPICScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<EPICProvider>().getAllowedDates();
      context.read<EPICProvider>().getPictures();
    });
  }

  int currentIndex = 0;

  double dragOffset = 0;

  final double threshold = 50;

  final formato = NumberFormat("#,###", "es_ES");

  @override
  Widget build(BuildContext context) {
    return Consumer<EPICProvider>(
      builder: (context, provider, child) {
        var epic = provider.epics[currentIndex];
        var earthDistance = sqrt(
          pow(epic.dscovrJ2000Position.x, 2) +
              pow(epic.dscovrJ2000Position.y, 2) +
              pow(epic.dscovrJ2000Position.z, 2),
        );
        var sunDistance = sqrt(
          pow(epic.sunJ2000Position.x, 2) +
              pow(epic.sunJ2000Position.y, 2) +
              pow(epic.sunJ2000Position.z, 2),
        );
        var moonDistance = sqrt(
          pow(epic.lunarJ2000Position.x, 2) +
              pow(epic.lunarJ2000Position.y, 2) +
              pow(epic.lunarJ2000Position.z, 2),
        );
        return Scaffold(
          appBar: AppBar(),
          body: GestureDetector(
            onHorizontalDragUpdate: (details) {
              dragOffset += details.delta.dx;

              if (dragOffset > threshold) {
                setState(
                  () => currentIndex =
                      (currentIndex + 1 + provider.epics.length) %
                      provider.epics.length,
                );
                dragOffset = 0;
              } else if (dragOffset < -threshold) {
                setState(() {
                  currentIndex = (currentIndex - 1) % provider.epics.length;
                  dragOffset = 0;
                });
              }
            },
            onHorizontalDragEnd: (details) => setState(() => dragOffset = 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: provider.epics.isEmpty || provider.isLoading
                        ? DynamicShimmer(height: 390)
                        : CachedNetworkImage(
                            imageUrl: epic.imageUrl,
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            useOldImageOnUrlChange: true,
                            placeholder: (context, url) =>
                                DynamicShimmer(height: 390),
                          ),
                  ),
                ),

                Text(
                  'Distance to Earth: ${formato.format(earthDistance)} km',
                  style: TextTheme.of(context).titleLarge,
                ),
                Text(
                  'Distance to the Moon: ${formato.format(moonDistance)} km',
                  style: TextTheme.of(context).titleLarge,
                ),
                Text(
                  'Sun to Earth: ${formato.format(sunDistance)} km',
                  style: TextTheme.of(context).titleLarge,
                ),
              ],
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var date = await showDatePicker(
                context: context,
                firstDate: DateTime(2015, 1, 1),
                lastDate: DateTime.now(),
                selectableDayPredicate: (day) =>
                    context.read<EPICProvider>().isAllowedDate(day),
              );

              if (date != null) {
                context.read<EPICProvider>().getPictures(datetime: date);
                setState(() => currentIndex = 0);
              }
            },
            child: Icon(Icons.calendar_month),
          ),
        );
      },
    );
  }
}
