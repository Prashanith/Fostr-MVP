import 'package:flutter/material.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class IndexProvider extends StatelessWidget {
  final Widget child;
  const IndexProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider.init(),
        ),
      ],
      child: child,
    );
  }
}
