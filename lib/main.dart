import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tusk_app/common/app_color.dart';
import 'package:tusk_app/common/app_route.dart';
import 'package:tusk_app/data/models/user.dart';
import 'package:tusk_app/presentation/user/user_cubit.dart';
import 'package:d_session/d_session.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => UserCubit())],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true).copyWith(
          primaryColor: AppColor.primary,
          colorScheme: ColorScheme.light(
              primary: AppColor.primary, secondary: AppColor.secondary),
          scaffoldBackgroundColor: AppColor.scaffold,
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(
            surfaceTintColor: AppColor.primary,
            backgroundColor: AppColor.primary,
            foregroundColor: Colors.white,
            titleTextStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          popupMenuTheme: const PopupMenuThemeData(
              color: Colors.white, surfaceTintColor: Colors.white),
          dialogTheme: const DialogTheme(
              surfaceTintColor: Colors.white, backgroundColor: Colors.white),
        ),
        initialRoute: AppRoute.home,
        routes: {
          AppRoute.home: (context) {
            return FutureBuilder(
              future: DSession.getUser(),
              builder: (context, snapshot) {
                if (snapshot.data == null) return const Scaffold();
                User user = User.fromJson(Map.from(snapshot.data!));
                context.read<UserCubit>().update(user);
                if (user.role == "Admin")
                  return const MyHomePage(title: "Ini Admin");
                return const MyHomePage(title: "Hello");
              },
            );
          },
          AppRoute.addEmployee: (context) => const Scaffold(),
          AppRoute.addTask: (context) => const Scaffold(),
          AppRoute.detailTask: (context) => const Scaffold(),
          AppRoute.listTask: (context) => const Scaffold(),
          AppRoute.login: (context) => const Scaffold(),
          AppRoute.monitorEmployee: (context) => const Scaffold(),
          AppRoute.profile: (context) => const Scaffold(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}
