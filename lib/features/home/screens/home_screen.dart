import 'package:flutter/material.dart';
import 'package:croma_app/shared/widgets/croma_app_bar.dart';
import 'package:croma_app/features/home/widgets/hero_section.dart';
import 'package:croma_app/features/home/widgets/brand_manifesto.dart';
import 'package:croma_app/features/home/widgets/featured_products.dart';
import 'package:croma_app/features/home/widgets/categories_grid.dart';

import 'package:croma_app/features/home/widgets/special_collections.dart';
import 'package:croma_app/features/home/widgets/newsletter_form.dart';

import 'package:croma_app/shared/widgets/croma_drawer.dart';
import 'package:croma_app/shared/widgets/app_footer.dart';
import 'package:croma_app/features/home/widgets/trending_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CromaAppBar(),
      drawer: CromaDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
            TrendingSection(),
            BrandManifesto(),
            FeaturedProducts(),
            SpecialCollections(),
            CategoriesGrid(),
            NewsletterForm(),
            AppFooter(),
          ],
        ),
      ),
    );
  }
}
