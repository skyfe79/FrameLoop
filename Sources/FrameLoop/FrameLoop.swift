import CoreVideo
import Foundation
import QuartzCore

/// Defines a callback type for frame updates, providing frames per second and delta time.
public typealias FrameUpdateHandler = (_ fps: Double, _ deltaTime: Double) -> Void

/// Manages the invocation of frame update callbacks.
public final class FrameUpdater {
  /// The callback to be invoked on frame updates.
  internal var onFrameUpdate: FrameUpdateHandler?

  /// Invokes the `onFrame` callback with the provided fps and deltaTime.
  @objc func update(fps: Double, deltaTime: Double) {
    onFrameUpdate?(fps, deltaTime)
  }

  /// Initializes a new `FrameUpdater`.
  internal init() {}
}

/// Coordinates frame updates using a display link, allowing clients to register for frame update callbacks.
public final class FrameLoop {
  /// The underlying display link used for synchronizing frame updates.
  private var displayLink: DisplayLink

  /// The object responsible for managing frame update callbacks.
  private var frameUpdater: FrameUpdater

  /// Registers or retrieves a frame update callback.
  public var onFrameUpdate: FrameUpdateHandler? {
    set {
      frameUpdater.onFrameUpdate = newValue
    }
    get {
      return frameUpdater.onFrameUpdate
    }
  }

  /// Indicates whether the frame loop is currently running.
  public var isRunning: Bool {
    return displayLink.isRunning
  }

  /// Gets or sets the preferred frame rate for the display link.
  public var preferredFramesPerSecond: Int {
    set {
      displayLink.preferredFramesPerSecond = newValue
    }
    get {
      return displayLink.preferredFramesPerSecond
    }
  }

  /// Initializes a new `FrameLoop` with the specified frame update callback.
  ///
  /// This initializer creates a new `FrameUpdater` instance and configures the underlying display link based on the current operating system.
  ///
  /// - Parameter onFrameUpdate: The callback to be invoked on frame updates.
  public init(onFrameUpdate: FrameUpdateHandler? = nil) {
    frameUpdater = FrameUpdater()
    #if os(macOS)
      displayLink = MacDisplayLink(frameUpdater: frameUpdater)
    #else
      displayLink = iOSDisplayLink(frameUpdater: frameUpdater)
    #endif
    self.onFrameUpdate = onFrameUpdate
  }

  #if os(macOS)
  /// Starts the frame loop, causing it to begin issuing frame update callbacks.
  public func start() {
    displayLink.start()
  }
  #else
  /// Starts the display link on the specified run loop and mode. If no run loop and mode are specified, it uses the main run loop and common mode by default.
  /// - Parameters:
  ///   - runLoop: The run loop on which to start the display link. Defaults to `RunLoop.main`.
  ///   - mode: The mode for the run loop. Defaults to `.common`.
  public func start(on runLoop: RunLoop = .main, mode: RunLoop.Mode = .common) {
    displayLink.start(on: runLoop, mode: mode)
  }
  #endif

  /// Stops the frame loop, preventing any further frame update callbacks from being issued.
  public func stop() {
    displayLink.stop()
  }
}
