//
//  ViewController.swift
//  FrameLoopiOSExample
//
//  Created by Sungcheol Kim on 2024/03/26.
//

import UIKit
import FrameLoop

class ViewController: UIViewController {
  private let frameLoop = FrameLoop()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    frameLoop.onFrameUpdate = { actualFPS, deltaTime in
      print("\(actualFPS), \(deltaTime)")
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    frameLoop.start()
    // or
    // frameLoop.start(on: .main, mode: .common)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    frameLoop.stop()
  }
}

