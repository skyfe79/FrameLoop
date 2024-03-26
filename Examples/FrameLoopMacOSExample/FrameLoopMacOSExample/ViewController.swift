//
//  ViewController.swift
//  FrameLoopMacOSExample
//
//  Created by Sungcheol Kim on 2024/03/26.
//

import Cocoa
import FrameLoop

class ViewController: NSViewController {
  private let frameLoop = FrameLoop()
  override func viewDidLoad() {
    super.viewDidLoad()
    frameLoop.preferredFramesPerSecond = 10
    frameLoop.onFrameUpdate = { actualFPS, deltaTime in
      print("\(actualFPS), \(deltaTime)")
    }
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    frameLoop.start()
  }
  
  override func viewDidDisappear() {
    super.viewDidDisappear()
    frameLoop.stop()
  }
}

