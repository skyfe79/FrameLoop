#if os(macOS)
  @testable import FrameLoop
  import XCTest

  final class MacDisplayLinkTests: XCTestCase {
    var macDisplayLink: MacDisplayLink!
    var frameUpdater: FrameUpdater!

    override func setUp() {
      super.setUp()
      frameUpdater = FrameUpdater()
      macDisplayLink = MacDisplayLink(frameUpdater: frameUpdater)
    }

    override func tearDown() {
      macDisplayLink = nil
      frameUpdater = nil
      super.tearDown()
    }

    func testIsRunningInitiallyFalse() {
      XCTAssertFalse(macDisplayLink.isRunning, "Expected isRunning to be false initially")
    }

    func testStartAndStopChangesIsRunning() {
      macDisplayLink.start()
      XCTAssertTrue(macDisplayLink.isRunning, "Expected isRunning to be true after start")
      macDisplayLink.stop()
      XCTAssertFalse(macDisplayLink.isRunning, "Expected isRunning to be false after stop")
    }

    func testPreferredFramesPerSecond() {
      let expectedFPS = 30
      macDisplayLink.preferredFramesPerSecond = expectedFPS
      XCTAssertEqual(macDisplayLink.preferredFramesPerSecond, expectedFPS, "Expected preferredFramesPerSecond to be set to \(expectedFPS)")
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

      macDisplayLink.start()
      waitForExpectations(timeout: 2) { _ in
        self.macDisplayLink.stop()
        XCTAssertTrue(callbackFired, "Expected frame update callback to be fired")
      }
    }
  }
#endif
