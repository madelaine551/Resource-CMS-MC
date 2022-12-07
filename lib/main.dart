/// -----------------------------------
///          External Packages
/// -----------------------------------

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resource_cms/models/data.dart';
import 'package:resource_cms/models/resource.dart';
import 'package:resource_cms/models/tag.dart';
import 'package:resource_cms/services/datasources/folder_datasource.dart';
import 'package:resource_cms/services/datasources/resource_datasource.dart';
import 'package:resource_cms/services/datasources/tag_datasource.dart';
import 'package:resource_cms/services/datasources/mongodb_folder_datasource.dart';
import 'package:resource_cms/services/datasources/mongodb_resource_datasource.dart';
import 'package:resource_cms/services/datasources/mongodb_tag_datasource.dart';
import 'package:resource_cms/widgets/folder_widget.dart';
import 'package:resource_cms/widgets/resource_widget.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterAppAuth appAuth = FlutterAppAuth();
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

/// -----------------------------------
///           Auth0 Variables
/// -----------------------------------

const domain = 'login.microsoftonline.com/consumers/v2.0';
const getUser = 'graph.microsoft.com/v1.0/me';
const clientId = '13bd3f67-8277-46cc-8fc9-621f3127aa9d';

const redirectUri = 'com.auth0.flutterdemo://login-callback';
const issuer = 'https://$domain';
final List<String> _scopes = <String>[
  'openid',
  'profile',
  'email',
  'User.Read',
];

/// -----------------------------------
///            Login Widget
/// -----------------------------------

class Login extends StatelessWidget {
  final loginAction;
  final String loginError;

  const Login(Key? key, this.loginAction, this.loginError) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            loginAction();
          },
          child: const Text('Login'),
        ),
        Text(loginError),
      ],
    );
  }
}

/// -----------------------------------
///             Main App
/// -----------------------------------

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<FolderDatasource>(MongodbFolderDatasource());
  GetIt.I.registerSingleton<ResourceDatasource>(MongodbResourceDatasource());
  GetIt.I.registerSingleton<TagDatasource>(MongodbTagDatasource());

  runApp(ChangeNotifierProvider(
      create: (context) => Data(), child: const RecourceCMSApp()));
}

/// -----------------------------------
///          Main App State
/// -----------------------------------

class RecourceCMSApp extends StatelessWidget {
  const RecourceCMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resource CMS App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}

/// -----------------------------------
///             Main Page
/// -----------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

/// -----------------------------------
///          Main Page State
/// -----------------------------------

class _HomePageState extends State<HomePage> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage = '';
  bool expanded = false;
  bool showHomePage = true;
  bool showAddPage = false;
  Icon addAndCancelIcon = const Icon(Icons.add);

  /// -----------------------------------
  ///       Build Main Page State
  /// -----------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        toolbarHeight:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width / 3
                : 21,

        // Header Logo
        title: Column(children: [
          OrientationBuilder(builder: (context, orientation) {
            bool visible =
                MediaQuery.of(context).orientation == Orientation.portrait;
            return Visibility(
                visible: visible,
                maintainSize: visible,
                maintainAnimation: visible,
                maintainState: visible,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 10,
                      0,
                      MediaQuery.of(context).size.width / 10,
                      0),
                  child: Image.asset('assets/nm-tafe-logo.jfif',
                      fit: BoxFit.fitHeight),
                ));
          }),
        ]),

        // Search Bar
        bottom: PreferredSize(
          preferredSize: const Size.fromRadius(40.0),
          child: isLoggedIn ? getSearchBar() : const Text(''),
        ),
      ),

      // Main Body
      body: isBusy // If the user is busy display progress indicator
          ? const Center(child: CircularProgressIndicator())
          : !isLoggedIn // If the user is logged in display main content
              ? Center(child: Login(null, loginAction, errorMessage))
              : Stack(
                  children: [
                    Visibility(
                      visible: showHomePage,
                      child: Container(
                        color: const Color.fromARGB(1, 217, 217, 217),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Consumer<Data>(
                                builder: (context, model, child) {
                              return RefreshIndicator(
                                  onRefresh: model.refresh,
                                  child: !model.connected
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : ListView.builder(
                                          itemCount: (model.resources.length +
                                              model.folders.length),
                                          itemBuilder:
                                              (BuildContext context, int i) {
                                            if (i >= model.resources.length) {
                                              return FolderWidget(
                                                  folder: model.folders[i -
                                                      model.resources.length]);
                                            } else {
                                              return ResourceWidget(
                                                  resource: model.resources[i]);
                                            }
                                          },
                                        ));
                            })),
                      ),
                    ),
                    Visibility(
                      visible: showAddPage,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  offset: Offset(2, 4),
                                )
                              ],
                              color: Color.fromRGBO(67, 67, 67, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: isLoggedIn
            ? <Widget>[
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.arrow_back),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.bookmark),
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      showHomePage = !showHomePage;
                      showAddPage = !showAddPage;
                      if (showHomePage) {
                        addAndCancelIcon = const Icon(Icons.add);
                      } else {
                        addAndCancelIcon = const Icon(Icons.cancel);
                      }
                    });
                  },
                  child: addAndCancelIcon,
                ),
              ]
            : [],
      ),
    );
  }

  /// -----------------------------------
  ///           Parse ID Token
  /// -----------------------------------

  Map<String, dynamic> parseIdToken(String? idToken) {
    final parts = idToken!.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  /// -----------------------------------
  ///          Get User Details
  /// -----------------------------------

  Future<Map> getUserDetails(accessToken) async {
    final Uri url = Uri.parse("https://$getUser");
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  /// -----------------------------------
  ///               Login
  /// -----------------------------------

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUri,
          issuer: issuer,
          scopes: _scopes,
        ),
      );

      final profile = await getUserDetails(result!.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
      });
    } catch (e, s) {
      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = 'Error Logging in, Try again.';
      });
    }
  }

  /// -----------------------------------
  ///              Logout
  /// -----------------------------------

  void logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  /// -----------------------------------
  ///         Search Bar Widget
  /// -----------------------------------

  Widget getSearchBar() {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: TextField(
          decoration: InputDecoration(
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.filter,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              hintText: 'Search for file...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
              )),
        ),
      ),
    );
  }
}
