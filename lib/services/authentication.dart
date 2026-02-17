// import the io version
import 'package:openid_client/openid_client_io.dart';
// use url launcher package 
import 'dart:io';


Future<Credential>authenticate(Uri uri, String clientId, List<String> scopes) async {         
    // create the client
  var issuer = await Issuer.discover(uri);
  var client = Client(issuer, clientId);
    
  Future<void> urlLauncher(String url) async => await Process.run('wslview', [url]);

    // create an authenticator
  final authenticator = Authenticator(client, scopes: scopes, urlLancher: urlLauncher);
    
    // starts the authentication
  return await authenticator.authorize();
}