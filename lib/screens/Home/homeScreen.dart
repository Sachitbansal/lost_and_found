import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../../controllers/responsive.dart';
import 'components/header.dart';
import 'components/recentFoundItems.dart';
import 'components/recentLostItems.dart';
import 'components/category.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      context.watch<MenuAppController>().topBlocks[context.watch<MenuAppController>().pageIndex],
                      const SizedBox(height: defaultPadding),
                      if (Responsive.isDesktop(context))
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: RecentLostItems()),
                            SizedBox(width: defaultPadding),
                            Expanded(child: RecentFoundItems()),
                          ],
                        ),
                      if(!Responsive.isDesktop(context))
                        const Column(
                          children: [
                            RecentLostItems(),
                            SizedBox(height: defaultPadding),
                            RecentFoundItems(),
                          ],
                        ),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        const StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}