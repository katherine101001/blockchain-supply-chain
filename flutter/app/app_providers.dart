// Global BLoC / DI
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/home/application/home_bloc.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../core/services/shared_preferences_service.dart';

import '../features/product/domain/repositories/product_repository.dart';
import '../features/product/data/datasources/product_remote_data_source.dart';
import '../features/product/data/repositories/product_repository_impl.dart';

import '../features/blockchain_explorer/application/bloc/explorer_bloc.dart';
import '../features/blockchain_explorer/data/repositories/explorer_repository_impl.dart';
import '../features/blockchain_explorer/domain/repositories/explorer_repository.dart';

import '../design_system/theme/theme_cubit.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeRepository>(
          create: (context) => HomeRepositoryImpl(
            sharedPreferencesService: SharedPreferencesService(),
          ),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            remoteDataSource: ProductRemoteDataSourceImpl(),
          ),
        ),
        RepositoryProvider<ExplorerRepository>(
          create: (context) => ExplorerRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
          BlocProvider<HomeBloc>(
            create: (context) =>
                HomeBloc(repository: context.read<HomeRepository>())
                  ..add(HomeLoadEvent()),
          ),
          BlocProvider<ExplorerBloc>(
            create: (context) =>
                ExplorerBloc(context.read<ExplorerRepository>()),
          ),
        ],
        child: child,
      ),
    );
  }
}
