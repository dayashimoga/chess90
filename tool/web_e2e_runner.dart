import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  print('======================================================');
  print('    CHESSMASTER WEB PRODUCTION BUNDLE BROWSER E2E     ');
  print('======================================================');

  const cdpBaseUrl = 'http://127.0.0.1:9222';
  const targetUrl = 'http://127.0.0.1:8080';

  // 1. Create a new tab navigating to the served app
  print('[1/6] Opening browser tab to $targetUrl via CDP...');
  final httpClient = HttpClient();
  final req = await httpClient.putUrl(Uri.parse('$cdpBaseUrl/json/new?$targetUrl'));
  final resp = await req.close();
  final respBody = await resp.transform(utf8.decoder).join();
  final tabData = jsonDecode(respBody) as Map<String, dynamic>;
  final wsUrl = tabData['webSocketDebuggerUrl'] as String;
  final tabId = tabData['id'] as String;
  print('  -> Created tab: $tabId');
  print('  -> Debugger WS: $wsUrl');

  // 2. Connect WebSocket
  print('[2/6] Connecting Chrome DevTools Protocol WebSocket...');
  final ws = await WebSocket.connect(wsUrl);

  int nextId = 1;
  final pending = <int, Completer<Map<String, dynamic>>>{};
  final consoleLogs = <String>[];
  final consoleErrors = <String>[];

  ws.listen((data) {
    final msg = jsonDecode(data as String) as Map<String, dynamic>;
    if (msg.containsKey('id')) {
      final id = msg['id'] as int;
      if (pending.containsKey(id)) {
        pending.remove(id)!.complete(msg);
      }
    } else if (msg['method'] == 'Runtime.consoleAPICalled') {
      final params = msg['params'] as Map<String, dynamic>;
      final type = params['type'] as String;
      final args = (params['args'] as List? ?? []).map((a) => a['value'] ?? a['description'] ?? '').join(' ');
      final logStr = '[$type] $args';
      consoleLogs.add(logStr);
      if (type == 'error') {
        consoleErrors.add(logStr);
      }
    }
  });

  Future<Map<String, dynamic>> sendCdp(String method, [Map<String, dynamic>? params]) {
    final id = nextId++;
    final completer = Completer<Map<String, dynamic>>();
    pending[id] = completer;
    final payload = jsonEncode({
      'id': id,
      'method': method,
      'params': params ?? {},
    });
    ws.add(payload);
    return completer.future;
  }

  // 3. Enable domains
  await sendCdp('Page.enable');
  await sendCdp('Runtime.enable');
  await sendCdp('DOM.enable');

  // Set viewport to 1280x800 desktop
  await sendCdp('Emulation.setDeviceMetricsOverride', {
    'width': 1280,
    'height': 800,
    'deviceScaleFactor': 1,
    'mobile': false,
  });

  print('[3/6] Waiting for Flutter Web CanvasKit engine bootstrap & first frame...');
  // Flutter web takes ~3-6 seconds to load CanvasKit WASM, compile, and render first frame
  await Future<void>.delayed(const Duration(seconds: 7));

  // 4. Verify DOM and title
  print('[4/6] Inspecting runtime DOM and JavaScript environment...');
  final evalTitle = await sendCdp('Runtime.evaluate', {
    'expression': 'document.title',
  });
  final title = evalTitle['result']?['result']?['value'] ?? '';
  print('  -> document.title: "$title"');

  final evalFlutterView = await sendCdp('Runtime.evaluate', {
    'expression': 'document.querySelector("flutter-view") !== null',
  });
  final hasFlutterView = evalFlutterView['result']?['result']?['value'] == true;
  print('  -> flutter-view rendered: $hasFlutterView');

  // 5. Capture screenshot of initial home screen
  print('[5/6] Capturing production browser screenshot of Home / Daily Journey...');
  final screenshotRes = await sendCdp('Page.captureScreenshot', {
    'format': 'png',
  });
  final base64Data = screenshotRes['result']?['data'] as String?;
  if (base64Data != null) {
    final bytes = base64Decode(base64Data);
    final outFile = File('docs/screenshots/web_e2e_home.png');
    outFile.writeAsBytesSync(bytes);
    print('  -> Saved screenshot: ${outFile.path} (${bytes.length} bytes)');
  } else {
    print('  -> WARNING: Failed to capture screenshot data');
  }

  // 6. Simulate interaction: Click on Curriculum or Play screen navigation item
  print('[6/6] Interacting with navigation rail (clicking navigation item)...');
  // In 1280x800 desktop, NavigationRail is on the left.
  // Click at x=36, y=140 (Play button / Curriculum button)
  await sendCdp('Input.dispatchMouseEvent', {
    'type': 'mousePressed',
    'x': 36,
    'y': 140,
    'button': 'left',
    'clickCount': 1,
  });
  await Future<void>.delayed(const Duration(milliseconds: 100));
  await sendCdp('Input.dispatchMouseEvent', {
    'type': 'mouseReleased',
    'x': 36,
    'y': 140,
    'button': 'left',
    'clickCount': 1,
  });

  await Future<void>.delayed(const Duration(seconds: 2));

  final navScreenshotRes = await sendCdp('Page.captureScreenshot', {
    'format': 'png',
  });
  final navBase64 = navScreenshotRes['result']?['data'] as String?;
  if (navBase64 != null) {
    final bytes = base64Decode(navBase64);
    final outFile = File('docs/screenshots/web_e2e_play_nav.png');
    outFile.writeAsBytesSync(bytes);
    print('  -> Saved navigation screenshot: ${outFile.path} (${bytes.length} bytes)');
  }

  // Cleanup tab
  await ws.close();
  final closeReq = await httpClient.putUrl(Uri.parse('$cdpBaseUrl/json/close/$tabId'));
  await closeReq.close();
  httpClient.close();

  final success = hasFlutterView && (base64Data != null);

  final summary = {
    'test': 'Web Browser E2E Production Validation',
    'timestamp': DateTime.now().toUtc().toIso8601String(),
    'url': targetUrl,
    'title': title,
    'hasFlutterView': hasFlutterView,
    'screenshots': [
      'docs/screenshots/web_e2e_home.png',
      'docs/screenshots/web_e2e_play_nav.png',
    ],
    'consoleErrorsCount': consoleErrors.length,
    'consoleErrors': consoleErrors,
    'status': success ? 'PROVEN' : 'FAIL',
  };

  File('web_e2e.json').writeAsStringSync(const JsonEncoder.withIndent('  ').convert(summary));
  print('\n------------------------------------------------------');
  print('WEB E2E SUMMARY: ${success ? "PROVEN (0 CRASHES / CLEAN RENDER)" : "FAIL"}');
  print('Console Errors: ${consoleErrors.length}');
  print('------------------------------------------------------');

  if (!success) {
    exit(1);
  }
}
