import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/catalog/presentation/blocs/catalog_bloc.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  /// Route path for this page
  static const String routePath = '/catalog';

  /// Factory method that creates the page wrapped with necessary BlocProviders
  static Widget create() {
    return BlocProvider(
      create: (context) => sl<CatalogBloc>()..add(LoadCatalogsEvent()),
      child: const CatalogPage(),
    );
  }

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Catalog Page'),
    );
  }
}
