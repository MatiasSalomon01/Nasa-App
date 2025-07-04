import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nasa_app/home/epic/epic_provider.dart';
import 'package:nasa_app/home/epic/epic_response.dart';
import 'package:nasa_app/widgets/dynamic_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  final double threshold = 30;

  final formato = NumberFormat("#,###", "es_ES");

  @override
  Widget build(BuildContext context) {
    return Consumer<EPICProvider>(
      builder: (context, provider, child) {
        double earthDistance = 0;
        double sunDistance = 0;
        double moonDistance = 0;

        EPICResponse? epic;

        if (provider.epics.isNotEmpty) {
          epic = provider.epics[currentIndex];

          earthDistance = sqrt(
            pow(epic.dscovrJ2000Position.x, 2) +
                pow(epic.dscovrJ2000Position.y, 2) +
                pow(epic.dscovrJ2000Position.z, 2),
          );
          sunDistance = sqrt(
            pow(epic.sunJ2000Position.x, 2) +
                pow(epic.sunJ2000Position.y, 2) +
                pow(epic.sunJ2000Position.z, 2),
          );
          moonDistance = sqrt(
            pow(epic.lunarJ2000Position.x, 2) +
                pow(epic.lunarJ2000Position.y, 2) +
                pow(epic.lunarJ2000Position.z, 2),
          );
        }
        return Scaffold(
          appBar: AppBar(),
          body: Skeletonizer(
            enabled: provider.isLoading,
            child: GestureDetector(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: epic == null
                          ? Placeholder()
                          : CachedNetworkImage(
                              imageUrl: epic.imageUrl,
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              useOldImageOnUrlChange: true,
                              placeholder: (context, url) =>
                                  DynamicShimmer(height: 390),
                            ),
                    ),
                    SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextTheme.of(
                              context,
                            ).bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: 'Distance to Earth: '),
                              TextSpan(
                                text: '${formato.format(earthDistance)} km',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            style: TextTheme.of(
                              context,
                            ).bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: 'Distance to the Moon: '),
                              TextSpan(
                                text: '${formato.format(moonDistance)} km',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            style: TextTheme.of(
                              context,
                            ).bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: 'Sun to Earth: '),
                              TextSpan(
                                text: '${formato.format(sunDistance)} km',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
