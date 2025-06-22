import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nasa_app/home/adop/adop_provider.dart';
import 'package:nasa_app/widgets/dynamic_shimmer.dart';
import 'package:provider/provider.dart';

class ADOPScreen extends StatefulWidget {
  const ADOPScreen({super.key});

  @override
  State<ADOPScreen> createState() => _ADOPScreenState();
}

class _ADOPScreenState extends State<ADOPScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var provider = context.read<ADOPProvider>();
      if (provider.adop == null) {
        provider.getPicture();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ADOPProvider>(
      builder: (context, provider, child) {
        bool isLoading = provider.isLoading || provider.adop == null;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Astronomy Picture of the Day ${provider.date ?? ''}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: isLoading
                          ? DynamicShimmer()
                          : GestureDetector(
                              onTap: () {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) {
                                    return CachedNetworkImage(
                                      imageUrl: provider.adop!.url,
                                    );
                                  },
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: provider.adop!.url,
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    isLoading
                        ? DynamicShimmer(height: 20)
                        : Text(
                            provider.adop!.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    SizedBox(height: 10),
                    isLoading
                        ? DynamicShimmer(height: 400)
                        : Text(
                            provider.adop!.explanation,
                            textAlign: TextAlign.justify,
                          ),
                    SizedBox(height: 20),
                    isLoading
                        ? DynamicShimmer(height: 14, width: 100)
                        : Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Author: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: provider.adop!.copyright ?? 'NASA',
                                ),
                              ],
                            ),
                          ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var date = await showDatePicker(
                context: context,
                firstDate: DateTime(1995, 6, 16),
                lastDate: DateTime.now(),
              );

              if (date != null) {
                context.read<ADOPProvider>().getPicture(
                  date: date.toString().split(' ').first,
                );
              }
            },
            child: Icon(Icons.calendar_month),
          ),
        );
      },
    );
  }
}
