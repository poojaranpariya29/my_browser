import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:my_browser/provider.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'modalclass.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final webKey = GlobalKey();
  TextEditingController searchController = TextEditingController();
  PullToRefreshController? refreshController;

  int? index = 0;

  @override
  void initState() {
    final providerVar = Provider.of<mirrorWallProvider>(context, listen: false);

    refreshController = PullToRefreshController(onRefresh: () async {
      await providerVar.webViewController!.reload();
    });
  }

  @override
  void dispose() {
    final providerVar = Provider.of<mirrorWallProvider>(context, listen: false);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerVar = Provider.of<mirrorWallProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('My Browser'),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return providerVar.bookMarkList.isNotEmpty
                              ? Container(
                                  child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () {
                                            providerVar.bookMarkUrl(index);
                                            Navigator.of(context).pop();
                                          },
                                          title: Text(
                                            "${providerVar.bookMarkList[index].bookmarktitle}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          subtitle: Text(
                                              "${providerVar.bookMarkList[index].bookmark}"),
                                          trailing: IconButton(
                                              onPressed: () {
                                                providerVar
                                                    .deleteBookMark(index);
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(Icons.close)),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: 10,
                                        );
                                      },
                                      itemCount:
                                          providerVar.bookMarkList.length),
                                )
                              : Center(
                                  child: Text("No any bookmark yet...."),
                                );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.bookmark,
                          size: 25,
                        ),
                        Text(
                          'All Bookmarks',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    )),
                PopupMenuItem<String>(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.screen_search_desktop_outlined,
                            size: 25,
                          )),
                      Text(
                        'Search Engine',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Center(child: Text('Search Engine')),
                              content: Container(
                                height: 250,
                                width: 150,
                                child: Center(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RadioListTile(
                                            value: SearchEngine.Google,
                                            groupValue: providerVar.Engine,
                                            onChanged: (value) {
                                              providerVar.changeEngine(value);
                                              Navigator.of(context).pop();
                                              providerVar.webViewController!
                                                  .loadUrl(
                                                      urlRequest: URLRequest(
                                                          url: WebUri(
                                                              'https://www.google.com/')));
                                            },
                                            title: Text('Google')),
                                        RadioListTile(
                                            value: SearchEngine.Yahoo,
                                            groupValue: providerVar.Engine,
                                            onChanged: (value) {
                                              providerVar.changeEngine(value);
                                              Navigator.of(context).pop();
                                              providerVar.webViewController!
                                                  .loadUrl(
                                                      urlRequest: URLRequest(
                                                          url: WebUri(
                                                              'https://in.search.yahoo.com/')));
                                            },
                                            title: Text('Yahoo')),
                                        RadioListTile(
                                            value: SearchEngine.Bing,
                                            groupValue: providerVar.Engine,
                                            onChanged: (value) {
                                              providerVar.changeEngine(value);
                                              Navigator.of(context).pop();
                                              providerVar.webViewController!
                                                  .loadUrl(
                                                      urlRequest: URLRequest(
                                                          url: WebUri(
                                                              'https://www.bing.com/')));
                                            },
                                            title: Text('Bing')),
                                        RadioListTile(
                                            value: SearchEngine.DuckDuckGo,
                                            groupValue: providerVar.Engine,
                                            onChanged: (value) {
                                              providerVar.changeEngine(value);
                                              providerVar.webViewController!
                                                  .loadUrl(
                                                      urlRequest: URLRequest(
                                                          url: WebUri(
                                                              'https://duckduckgo.com/')));
                                              Navigator.of(context).pop();
                                            },
                                            title: Text('DuckDuckGo')),
                                      ]),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              pullToRefreshController: refreshController,
              onLoadStop: (controller, url) {
                refreshController?.endRefreshing();
              },
              key: webKey,
              initialUrlRequest:
                  URLRequest(url: WebUri('https://www.google.com')),
              onWebViewCreated: (value) {
                providerVar.webViewController = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        providerVar.webViewController!.loadUrl(
                            urlRequest: URLRequest(
                                url: (providerVar.Engine == SearchEngine.Google)
                                    ? WebUri(
                                        'https://www.google.com/search?q=${searchController.text}')
                                    : (providerVar.Engine == SearchEngine.Yahoo)
                                        ? WebUri(
                                            'https://in.search.yahoo.com/search?q=${searchController.text}')
                                        : (providerVar.Engine ==
                                                SearchEngine.Bing)
                                            ? WebUri(
                                                'https://www.bing.com/search?q=${searchController.text}')
                                            : WebUri(
                                                'https://duckduckgo.com/${searchController.text}')));
                        searchController.clear();
                      },
                      icon: Icon(Icons.search)),
                  hintText: 'Search or type web address',
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(style: BorderStyle.solid, width: 2))),
              controller: searchController,
              onFieldSubmitted: (value) {
                providerVar.webViewController!.loadUrl(
                    urlRequest: URLRequest(
                        url: (providerVar.Engine == SearchEngine.Google)
                            ? WebUri(
                                'https://www.google.com/search?q=${searchController.text}')
                            : (providerVar.Engine == SearchEngine.Yahoo)
                                ? WebUri(
                                    'https://in.search.yahoo.com/search?q=${searchController.text}')
                                : (providerVar.Engine == SearchEngine.Bing)
                                    ? WebUri(
                                        'https://www.bing.com/search?q=${searchController.text}')
                                    : WebUri(
                                        'https://duckduckgo.com/${searchController.text}')));
                searchController.clear();
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    (providerVar.Engine == SearchEngine.Google)
                        ? providerVar.webViewController!.loadUrl(
                            urlRequest: URLRequest(
                                url: WebUri('https://www.google.com/')))
                        : (providerVar.Engine == SearchEngine.Yahoo)
                            ? providerVar.webViewController!.loadUrl(
                                urlRequest: URLRequest(
                                    url:
                                        WebUri('https://in.search.yahoo.com/')))
                            : (providerVar.Engine == SearchEngine.Bing)
                                ? providerVar.webViewController!.loadUrl(
                                    urlRequest: URLRequest(
                                        url: WebUri('https://www.bing.com/')))
                                : providerVar.webViewController!.loadUrl(
                                    urlRequest: URLRequest(
                                        url:
                                            WebUri('https://duckduckgo.com/')));
                  },
                  icon: Icon(
                    Icons.home,
                    size: 27,
                  )),
              IconButton(
                  onPressed: () async {
                    if (providerVar.webViewController != null) {
                      BookmarkModel DATA = BookmarkModel(
                          bookmarktitle:
                              await providerVar.webViewController!.getTitle(),
                          bookmark:
                              await providerVar.webViewController!.getUrl());
                      providerVar.bookMarkADD(DATA);
                    }
                  },
                  icon: Icon(Icons.bookmark_add_outlined, size: 27)),
              IconButton(
                  onPressed: () {
                    providerVar.webViewController!.goBack();
                  },
                  icon: Icon(Icons.arrow_back_ios_new, size: 27)),
              IconButton(
                  onPressed: () {
                    providerVar.webViewController!.reload();
                  },
                  icon: Icon(Icons.refresh, size: 27)),
              IconButton(
                  onPressed: () {
                    providerVar.webViewController!.goForward();
                  },
                  icon: Icon(Icons.arrow_forward_ios, size: 27)),
            ],
          )
        ],
      ),
    );
  }
}
