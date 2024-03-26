#if os(macOS)
  import CoreVideo
  import Foundation

  /// A class that manages a display link on macOS, synchronizing drawing to the refresh rate of the display.
  public class MacDisplayLink: DisplayLink {
    /// The Core Video display link used for screen updates.
    private var displayLink: CVDisplayLink?

    /// The timestamp of the last screen update.
    private var lastUpdateTime: CFTimeInterval = 0

    /// A Boolean value indicating whether the display link is currently running.
    public var isRunning: Bool {
      guard let dl = displayLink else { return false }
      return CVDisplayLinkIsRunning(dl)
    }

    /// A weak reference to the object that will receive frame update callbacks.
    private weak var frameUpdater: FrameUpdater?

    /// The preferred frames per second for the display link. Adjusts the display link's output callback rate.
    public var preferredFramesPerSecond: Int = 60 {
      didSet {
        configureDisplayLink()
      }
    }

    /// The minimum time interval between screen refreshes, calculated based on the preferred frames per second.
    private var minTimeInterval: CFTimeInterval = 0

    /// Initializes a new MacDisplayLink with the specified frame updater.
    /// - Parameter frameUpdater: The frame updater to be called with each screen refresh.
    public required init(frameUpdater: FrameUpdater) {
      self.frameUpdater = frameUpdater
      let result = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
      if result != kCVReturnSuccess || displayLink == nil {
        fatalError("Unable to create CVDisplayLink")
      }
      configureDisplayLink()
    }

    /// Configures the display link with an output handler to process screen updates.
    private func configureDisplayLink() {
      guard let dl = displayLink else { return }
      minTimeInterval = 1.0 / Double(preferredFramesPerSecond)
      CVDisplayLinkSetOutputHandler(dl) { [weak self] displayLink, inNow, inOutputTime, _, _ -> CVReturn in
        self?.handleDisplayLink(displayLink, inNow: inNow, inOutputTime: inOutputTime)
        return kCVReturnSuccess
      }
    }

    /// Starts the display link if it is not already running.
    public func start() {
      guard !isRunning, let dl = displayLink else { return }
      CVDisplayLinkStart(dl)
    }

    /// Stops the display link if it is currently running.
    public func stop() {
      guard isRunning, let dl = displayLink else { return }
      CVDisplayLinkStop(dl)
    }

    /// Handles the display link's screen refresh callback, calculating the delta time and actual frames per second.
    /// - Parameters:
    ///   - _: The CVDisplayLink that triggered the callback.
    ///   - inNow: The current timestamp (unused).
    ///   - inOutputTime: The timestamp of the output frame.
    public func handleDisplayLink(_: CVDisplayLink, inNow _: UnsafePointer<CVTimeStamp>, inOutputTime: UnsafePointer<CVTimeStamp>) {
      let currentTime = CVTimeStampToSeconds(inOutputTime)
      let deltaTime = currentTime - lastUpdateTime
      if deltaTime >= minTimeInterval {
        lastUpdateTime = currentTime
        let actualFPS: Double = deltaTime > 0 ? 1.0 / deltaTime : 0
        frameUpdater?.update(fps: actualFPS, deltaTime: deltaTime)
      }
    }

    /// Converts a CVTimeStamp to seconds.
    /// - Parameter timeStamp: The CVTimeStamp to convert.
    /// - Returns: The time in seconds.
    private func CVTimeStampToSeconds(_ timeStamp: UnsafePointer<CVTimeStamp>) -> CFTimeInterval {
      return CFTimeInterval(timeStamp.pointee.videoTime) / CFTimeInterval(timeStamp.pointee.videoTimeScale)
    }

    /// Stops and releases the display link when the object is deinitialized.
    deinit {
      if let dl = displayLink {
        CVDisplayLinkStop(dl)
      }
      // ARC will automatically release the display link when it is no longer referenced.
      displayLink = nil
    }
  }

#endif
