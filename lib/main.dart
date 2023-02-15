import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countProvider);
    print(count);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncValue Sample'),
      ),
      body: count.when(
        data: (data) {
          // if (count.isLoading) {
          //   return const Center(
          //     child: Text('ロード中です'),
          //   );
          // }
          if (count.isRefreshing) {
            return const Center(
              child: Text('リフレッシュ中です'),
            );
          }
          return Center(
            child: Text(
              data.toString(),
            ),
          );
        },
        error: (error, stackTrace) {
          if (count.isRefreshing) {
            return const Center(
              child: Text('リフレッシュ中です'),
            );
          }
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.refresh(countProvider),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

final countProvider = FutureProvider<int>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  throw Exception('エラーが発生しました😳');
  return 1;
});
