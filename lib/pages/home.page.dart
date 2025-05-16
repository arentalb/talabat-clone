import 'package:flutter/material.dart';
import 'package:talabat/utils/data/stores.data.dart';
import 'package:talabat/sliders/image.slider.dart';
import 'package:talabat/sliders/storeDetail.slider.dart';
import 'package:talabat/widgets/big.card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          style: TextStyle(color: Colors.white),
          "TALABAT",
        ),
        backgroundColor: const Color.fromARGB(255, 249, 109, 33),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageSlider(),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Trend Stores",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Trend stores you can order from ",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: storesData
                            .where((store) => store.isTrend == true)
                            .map(
                              (store) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: BigCard(
                                  title: store.storeName,
                                  subtitle: store.categories.join(', '),
                                  imagePath: store.storeImageUrl,
                                  onTap: () => Navigator.push(
                                    context,
                                    _navigateToStore(store.storeId),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "All Stores",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "All stores you can order from ",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: storesData
                            .map(
                              (store) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: BigCard(
                                  title: store.storeName,
                                  subtitle: "${store.categories.join(', ')}",
                                  imagePath: store.storeImageUrl,
                                  onTap: () => Navigator.push(
                                    context,
                                    _navigateToStore(store.storeId),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _navigateToStore(int storeId) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          StoreDetailSlider(storeId: storeId),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
