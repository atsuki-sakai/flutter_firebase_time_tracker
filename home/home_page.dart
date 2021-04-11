import 'package:flutter/material.dart';
import 'package:flutter_firebase/home/account/account_page.dart';
import 'package:flutter_firebase/home/cupertino_home_scaffold.dart';
import 'package:flutter_firebase/home/jobs/jobs_page.dart';
import 'package:flutter_firebase/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if(tabItem == _currentTab){
      //pop to first route
      // popUntilメソッドで初期画面に遷移させる　routeを全てリセットして戻る
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    }else{
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    //　TIPS -  Willpopで前画面に戻れなくする。androoidの場合必要になる、機体自体にバックボタンがあるため。
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
        child: CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelected: _select,
      widgetBuilders: widgetBuilders,
          navigatorKeys: navigatorKeys,
    ));
  }
}
