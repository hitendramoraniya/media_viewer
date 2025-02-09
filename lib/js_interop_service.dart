@JS()
library js_interop;

import 'package:js/js.dart';

@JS()
external _toggleFullScreen();

@JS()
external _enterFullScreen();

@JS()
external _exitFullScreen();

class JsInteropService {

  toggleFullScreen() {
    _toggleFullScreen();
  }

  enterFullScreen() {
    _enterFullScreen();
  }

  exitFullScreen() {
    _exitFullScreen();
  }
}
