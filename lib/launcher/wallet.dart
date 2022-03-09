import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

_walletConnect() async {
  SessionStatus? session;

  final connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: const PeerMeta(
      name: 'WalletConnect',
      description: 'WalletConnect Developer App',
      url: 'https://walletconnect.org',
      icons: ['https://walletconnect.org/walletconnect-logo.png'],
    ),
  );

  // Subscribe to events
  connector.on(
      'connect', (session) => print('connect session: ' + session.toString()));
  connector.on('session_update',
      (payload) => print('session_update payload: ' + payload.toString()));
  connector.on('disconnect',
      (session) => print('disconnect session: ' + session.toString()));

  // Create a new session
  if (!connector.connected) {
    session = await connector.createSession(
        chainId: 43113,
        onDisplayUri: (uri) async => {
              print('uri: ' + uri.toString()),
              if (await canLaunch(uri))
                {await launch(uri)}
              else
                {throw 'Could not launch $uri'}
            });
  }

  print('session.accounts: ' + session!.accounts[0].toString());
  // return session.accounts[0].toString();
  return session;
}

// Future<String> launchWallet() async {
Future<SessionStatus> launchWallet() async {
  return await _walletConnect();
}
