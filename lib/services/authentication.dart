// import the io version
import 'package:openid_client/openid_client_io.dart';
// use url launcher package 
import 'dart:io';

Future<UserInfo>authenticate(Uri uri, String clientId, List<String> scopes) async {   
    
    // create the client
    var issuer = await Issuer.discover(uri);
    var client = new Client(issuer, clientId);
    
  Future<void> urlLauncher(String url) async {
    await Process.run('wslview', [url]);
  }
    
    // create an authenticator
    var authenticator = Authenticator(client,
        scopes: scopes, urlLancher: urlLauncher);
    
    // starts the authentication
    var c = await authenticator.authorize();
    
    // return the user info
    return await c.getUserInfo();

}