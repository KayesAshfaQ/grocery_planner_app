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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CatalogLoaded) {
            final catalogs = state.catalogs;
            if (catalogs.isEmpty) {
              return const Center(child: Text('No catalogs found.'));
            }
            return ListView.builder(
              itemCount: catalogs.length,
              itemBuilder: (context, index) {
                final item = catalogs[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.category?.name ?? 'No Category'),
                  onTap: () {
                    // Handle item tap
                  },
                );
              },
            );
          } else if (state is CatalogError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(
              child: Text('Failed to load catalog'),
            );
          }
        },
      ),
    );
  }
}
