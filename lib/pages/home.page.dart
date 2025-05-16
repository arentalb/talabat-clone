import 'package:flutter/material.dart';
import 'package:talabat/models/store.model.dart';
import 'package:talabat/pages/store_detail.page.dart';
import 'package:talabat/services/store.service.dart';
import 'package:talabat/widgets/image.slider.dart';
import 'package:talabat/widgets/big.card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StoreService _storeService = StoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TALABAT",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 109, 33),
      ),
      body: StreamBuilder<List<Store>>(
        stream: _storeService.getStores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final stores = snapshot.data!;
          final trendStores = stores.where((s) => s.isTrend).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageSlider(),
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Trend Stores",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text("Trend stores you can order from",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: trendStores.map((store) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: BigCard(
                            title: store.storeName,
                            subtitle: store.categories.join(', '),
                            imagePath: store.storeImageUrl,
                            onTap: () => Navigator.push(
                              context,
                              _navigateToStore(store.id),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("All Stores",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text("All stores you can order from",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: stores.map((store) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: BigCard(
                            title: store.storeName,
                            subtitle: store.categories.join(', '),
                            imagePath: store.storeImageUrl,
                            onTap: () => Navigator.push(
                              context,
                              _navigateToStore(store.id),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Route _navigateToStore(String storeId) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          StoreDetailPage(storeId: storeId),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
