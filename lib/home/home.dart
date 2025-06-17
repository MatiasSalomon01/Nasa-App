import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: 700),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 16 / 9,
              // mainAxisExtent: 10,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 100,
            ),
            itemCount: MenuItem.data.length,
            itemBuilder: (context, index) {
              var item = MenuItem.data[index];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, item.screen),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item.subTitle,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final String subTitle;
  final String screen;

  MenuItem({required this.title, required this.subTitle, required this.screen});

  static List<MenuItem> data = [
    MenuItem(
      title: 'ADOP',
      subTitle: 'Astronomy Picture of the Day',
      screen: '/adop',
    ),
    MenuItem(
      title: 'ADOP',
      subTitle: 'Astronomy Picture of the Day',
      screen: '/adop',
    ),
    MenuItem(
      title: 'ADOP',
      subTitle: 'Astronomy Picture of the Day',
      screen: '/adop',
    ),
    MenuItem(
      title: 'ADOP',
      subTitle: 'Astronomy Picture of the Day',
      screen: '/adop',
    ),
  ];
}
