import Foundation

/// A protocol that defines the requirements for a display link, which synchronizes drawing to the refresh rate of the display.
public protocol DisplayLink {
  /// Starts the display link.
  #if os(macOS)
  func start()
  #else
  func start(on runLoop: RunLoop, mode: RunLoop.Mode)
  #endif
  
  /// Stops the display link.
  func stop()
  
  /// A Boolean value indicating whether the display link is currently running.
  var isRunning: Bool { get }
  
  /// The preferred frame rate for the display link, in frames per second.
  var preferredFramesPerSecond: Int { get set }
  
  /// Initializes a new display link with the specified frame updater.
  /// - Parameter frameUpdater: The frame updater to be called with each screen refresh.
  init(frameUpdater: FrameUpdater)
}
