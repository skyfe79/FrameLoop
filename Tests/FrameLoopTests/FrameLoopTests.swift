@testable import FrameLoop
import XCTest

final class FrameLoopTests: XCTestCase {
  var frameLoop: FrameLoop!
  var frameUpdater: FrameUpdater!

  override func setUp() {
    super.setUp()
    frameUpdater = FrameUpdater()
    frameLoop = FrameLoop(frameCallback: frameUpdater.update)
  }

  override func tearDown() {
    frameLoop = nil
    frameUpdater = nil
    super.tearDown()
  }

  func testIsRunningInitiallyFalse() {
    XCTAssertFalse(frameLoop.isRunning, "Expected isRunning to be false initially")
  }

  func testStartAndStopChangesIsRunning() {
    frameLoop.start()
    XCTAssertTrue(frameLoop.isRunning, "Expected isRunning to be true after start")
    frameLoop.stop()
    XCTAssertFalse(frameLoop.isRunning, "Expected isRunning to be false after stop")
  }

  func testPreferredFramesPerSecond() {
    let expectedFPS = 30
    frameLoop.preferredFramesPerSecond = expectedFPS
    XCTAssertEqual(frameLoop.preferredFramesPerSecond, expectedFPS, "Expected preferredFramesPerSecond to be set to \(expectedFPS)")
  }

  func testFrameUpdateCallback() {
    let expectation = self.expectation(description: "FrameUpdateCallback")
    var callbackFired = false

    frameUpdater.onFrame = { fps, deltaTime in
      XCTAssertGreaterThan(fps, 0, "Expected fps to be greater than 0")
      XCTAssertGreaterThan(deltaTime, 0, "Expected deltaTime to be greater than 0")
      callbackFired = true
      expectation.fulfill()
    }

    frameLoop.start()
    waitForExpectations(timeout: 2) { _ in
      self.frameLoop.stop()
      XCTAssertTrue(callbackFired, "Expected frame update callback to be fired")
    }
  }
}
