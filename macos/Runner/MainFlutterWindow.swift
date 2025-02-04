// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Cocoa
import FlutterMacOS

func windowOrigin(viewId: Int64) -> CGPoint {
  let screen = NSScreen.screens[2]
  let topLeft = screen.visibleFrame.origin
  let x = CGFloat(viewId) * 300.0 + topLeft.x + 300.0
  let y = CGFloat(viewId) * 200.0 + topLeft.y + 1500.0
  return CGPoint.init(x: x, y: y)
}

class MainFlutterWindow: NSWindow {
  static var engine: FlutterEngine?

  override func awakeFromNib() {
    super.awakeFromNib()
    let flutterViewController = FlutterViewController()
    MainFlutterWindow.engine = flutterViewController.engine;
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    self.setFrameTopLeftPoint(windowOrigin(viewId: 0))
  }
}

class SideFlutterWindow: NSWindow {
  init(engine: FlutterEngine) {
    super.init(contentRect: .init(origin: .zero,
                                  size: .init(width: 400,
                                              height: 400)),
               styleMask: [.titled, .closable, .miniaturizable, .resizable],
               backing: .buffered,
               defer: false)
    let windowFrame = self.frame
    self.contentViewController  = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    self.setFrame(windowFrame, display: true)
    self.makeKeyAndOrderFront(nil)
    self.title = String(format: "Flutter Window #%llu", windowId())

    self.setFrameTopLeftPoint(windowOrigin(viewId: windowId()))
  }

  func windowId() -> Int64 {
    return (self.contentViewController as! FlutterViewController).viewId
  }
}
