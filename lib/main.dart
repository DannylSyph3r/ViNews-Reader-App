import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/firebase_options.dart';
import 'package:vinews_news_reader/routes/route_config.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  runApp(const ProviderScope(child: ViNewsApp()));
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  }; // Run the  app
}

class ViNewsApp extends ConsumerStatefulWidget {
  const ViNewsApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViNewsAppState();
}

class _ViNewsAppState extends ConsumerState<ViNewsApp> {

  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(appRouterProvider);
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return Builder(
              builder: ((context) => Builder(
                  builder: (context) => MaterialApp.router(
                        //theme: ref.watch(themeNotifierProvider),
                        theme: ThemeData(
                          fontFamily: 'SFProDisplay',
                        ),
                        title: 'ViNews News Reader App',
                        debugShowCheckedModeBanner: false,
                        routerDelegate: appRouter.routerDelegate,
                        routeInformationProvider:
                            appRouter.routeInformationProvider,
                        routeInformationParser:
                            appRouter.routeInformationParser,
                      ))));
        });
  }
}