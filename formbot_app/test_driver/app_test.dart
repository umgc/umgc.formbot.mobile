


import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main(){
  testAll();
}

Future<void> testAll() async {
  group('',(){
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    tearDownAll((){
      if(driver!=null){
        driver.close();
      }
    });
    var app = find.byValueKey('app');
     var loginButton = find.byValueKey('login_btn');
     var helpButton = find.byValueKey('help_btn');
      var helpBackButton = find.byValueKey('help_back_btn');
     var homepageKey = find.byValueKey('home');
     var drawerKey = find.byTooltip('Open navigation menu');
     var homeFromDrawer = find.byValueKey('drawerHome');
     var beginConversationTile = find.byValueKey('begin_conversation_tile');
     var beginConversation = find.byValueKey('begin_conversation');
     var chatPage = find.byValueKey('chat_page');
     var msgTxtField = find.byValueKey('msgTextfield');
     var msgSendBtn = find.byValueKey('msgSendBtn');
     var templateDropdown = find.byValueKey('templateDropdown');
     var vaccinationMenuItem = find.text('Vaccination Record');
     var proceedBtn = find.byValueKey('proceedBtn');
    //  test ("Login Test",() async {

    //   await driver.waitForAbsent(homepageKey);
    //   await Future.delayed(Duration(seconds: 2));
    //   await driver.tap(loginButton);
    //   await driver.waitFor(homepageKey);
    //   await driver.waitUntilNoTransientCallbacks();

    //   // assert(homepageKey!=null);

    //  });

    test ("Help Test",() async {

      await driver.waitForAbsent(homepageKey);
      print("tapping help button");
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(helpButton);
      // await driver.waitFor(homepageKey);
      // await driver.waitUntilNoTransientCallbacks();
      print("tapping back button on help");
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(helpBackButton);
      
      print("closing in 2 seconds");
      await Future.delayed(Duration(seconds: 2));
      print('open drawer');
      await driver.tap(drawerKey);
      await Future.delayed(Duration(seconds: 2));

      print('opening home from drawer');
      await driver.tap(homeFromDrawer);
      await Future.delayed(Duration(seconds: 2));

       print('opening begin conversation tile');
      await driver.waitForAbsent(chatPage);
      await driver.tap(beginConversation);
      await driver.waitFor(chatPage);
      await driver.waitUntilNoTransientCallbacks();
      await Future.delayed(Duration(seconds: 2));
  

      print('selcting template menu item');
      await driver.tap(templateDropdown);
      await Future.delayed(Duration(seconds: 2));
      
      print('selcting vaccination value');
      await driver.tap(vaccinationMenuItem);
      await Future.delayed(Duration(seconds: 2));

       print('proceeding');
      await driver.tap(proceedBtn);
      await Future.delayed(Duration(seconds: 2));

       print('tap textfield');
      await driver.tap(msgTxtField);
      await Future.delayed(Duration(seconds: 1));
      await driver.enterText("Hello, this is an integration test by Arnaud");
       await Future.delayed(Duration(seconds: 1));

       print('sending text');
       await driver.tap(msgSendBtn);

       print('closing test');
         await Future.delayed(Duration(seconds: 5));
         


      
      
      // print('opening begin conversation page');
      // await driver.tap(beginConversation);
      // await Future.delayed(Duration(seconds: 2));
      // await driver.scroll(app, -300, 0, Duration(milliseconds: 300));
      //  await Future.delayed(Duration(seconds: 10));
      // assert(homepageKey!=null);
     });

     

  });
}