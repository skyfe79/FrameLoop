

#if !os(macOS)
  extension DisplayLink {
    func start(on runLoop: RunLoop = RunLoop.main, mode: RunLoop.Mode = .common) {
      start(on: runLoop, mode: mode)
    }
  }

  @testable import FrameLoop
  import XCTest

  final class iOSDisplayLinkTests: XCTestCase {
    var iosDisplayLink: iOSDisplayLink!
    var frameUpdater: FrameUpdater!

    override func setUp() {
      super.setUp()
      frameUpdater = FrameUpdater()
      iosDisplayLink = iOSDisplayLink(frameUpdater: frameUpdater)
    }

    override func tearDown() {
      iosDisplayLink = nil
      frameUpdater = nil
      super.tearDown()
    }

    func testIsRunningInitiallyFalse() {
      XCTAssertFalse(iosDisplayLink.isRunning, "Expected isRunning to be false initially")
    }

    func testStartAndStopChangesIsRunning() {
      iosDisplayLink.start()
      XCTAssertTrue(iosDisplayLink.isRunning, "Expected isRunning to be true after start")
      iosDisplayLink.stop()
      XCTAssertFalse(iosDisplayLink.isRunning, "Expected isRunning to be false after stop")
    }

    func testPreferredFramesPerSecond() {
      let expectedFPS = 30
      iosDisplayLink.preferredFramesPerSecond = expectedFPS
      XCTAssertEqual(iosDisplayLink.preferredFramesPerSecond, expectedFPS, "Expected preferredFramesPerSecond to be set to \(expectedFPS)")
    }

    func testFrameUpdateCallback() {
      let expectation = self.expectation(description: "FrameUpdateCallback")
      var callbackFired = false

      frameUpdater.onFrameUpdate = { fps, deltaTime in
        XCTAssertGreaterThan(fps, 0, "Expected fps to be greater than 0")
        XCTAssertGreaterThan(deltaTime, 0, "Expected deltaTime to be greater than 0")
        callbackFired = true
        print("callbackFired: \(callbackFired)")
        expectation.fulfill()
      }

      iosDisplayLink.start()
      waitForExpectations(timeout: 2) { _ in
        self.iosDisplayLink.stop()
        XCTAssertTrue(callbackFired, "Expected frame update callback to be fired")
      }
    }
  }
#endif
