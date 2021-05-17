import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noirspeak/data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      home: MyHomePage(title: 'Noirspeak'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map _defintion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        leading: Image(fit: BoxFit.scaleDown,
          image: AssetImage('icon_image.png'),
        ),

        title: Text(
          widget.title,
          style: GoogleFonts.oldenburg(),
        ),
      ),
      body: Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.all(25),
          child: Center(
              child: Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Explain words and phrases from the era of classic film noir'),

                      TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            autofocus: true,
                            autocorrect: true,
                            style: DefaultTextStyle.of(context).style.copyWith(
                                color: Colors.white70,

                                decoration: TextDecoration.none),
                            decoration:
                                InputDecoration(
                                    border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search,size: 48),
                                    hintText: 'Search for a word or term',
                                    hintStyle: TextStyle(fontWeight: FontWeight.w100,color: Colors.white10),
                                )),
                        suggestionsCallback: (pattern) async {
                          if (pattern.isEmpty) {
                            return [];
                          }

                          return noirscape_terms.where((element) {
                            var name = element['name'];
                            return name.startsWith(pattern);
                          });
                        },
                        hideOnEmpty: true,
                        getImmediateSuggestions: false,
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion['name']),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          print(suggestion);
                          setState(() {
                            _defintion = suggestion;
                          });
                        },
                      ),
                      _defintion == null
                          ? Container()
                          : Container(
                              height: MediaQuery.of(context).size.height / 2,
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    _defintion['name'],
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                  Text(
                                    "1. " + _defintion['meaning'],
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  Text(
                                    '"' + _defintion['example'] + '"',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              ),
                            )
                    ],
                  )),
            ],
          ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
