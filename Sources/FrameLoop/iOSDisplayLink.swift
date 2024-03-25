#if os(iOS)
  import Foundation
  import QuartzCore
  import UIKit

  /// A class that manages a display link on iOS, synchronizing drawing to the refresh rate of the display.
  public class iOSDisplayLink: DisplayLink {
    /// The underlying CADisplayLink used for screen updates.
    private var displayLink: CADisplayLink?

    /// The timestamp of the last screen update.
    private var lastUpdateTime: TimeInterval = 0

    /// A Boolean value indicating whether the display link is currently running.
    /// We should make this because the CADisplayLink's isPaused default is false
    private var running: Bool = false

    /// A weak reference to the object that will receive frame update callbacks.
    private weak var frameUpdater: FrameUpdater?

    /// The preferred frames per second for the display link. Adjusts the display link's frame rate range on iOS 15 and later, or preferredFramesPerSecond otherwise.
    public var preferredFramesPerSecond: Int = UIScreen.main.maximumFramesPerSecond {
      didSet {
        if #available(iOS 15.0, *) {
          displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 10, maximum: 120, preferred: Float(preferredFramesPerSecond))
        } else {
          displayLink?.preferredFramesPerSecond = preferredFramesPerSecond
        }
      }
    }

    /// A Boolean value indicating whether the display link is currently running.
    public var isRunning: Bool {
      guard let dl = displayLink else { return false }
      return running
    }

    /// Initializes a new iOSDisplayLink with the specified frame updater.
    /// - Parameter frameUpdater: The frame updater to be called with each screen refresh.
    public required init(frameUpdater: FrameUpdater) {
      self.frameUpdater = frameUpdater
      setupDisplayLink()
    }

    /// Sets up the CADisplayLink and assigns it to the `displayLink` property.
    private func setupDisplayLink() {
      displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
      displayLink?.preferredFramesPerSecond = preferredFramesPerSecond
    }

    /// Handles the display link's screen refresh callback, calculating the delta time and actual frames per second.
    /// - Parameter link: The CADisplayLink that triggered the callback.
    @objc private func handleDisplayLink(_ link: CADisplayLink) {
      let currentTime = link.timestamp
      let deltaTime = currentTime - lastUpdateTime
      lastUpdateTime = currentTime
      let actualFPS: Double = deltaTime > 0 ? 1.0 / deltaTime : 0
      frameUpdater?.update(fps: actualFPS, deltaTime: deltaTime)
    }

    /// Starts the display link if it is not already running.
    public func start() {
      guard !isRunning else { return }
      if displayLink == nil {
        setupDisplayLink()
      }
      running = true
      displayLink?.add(to: .main, forMode: .common)
    }

    /// Stops the display link and cleans up resources.
    public func stop() {
      displayLink?.invalidate()
      displayLink = nil
      running = false
    }

    /// Ensures the display link is stopped when the iOSDisplayLink is deinitialized.
    deinit {
      stop()
    }
  }
#endif
