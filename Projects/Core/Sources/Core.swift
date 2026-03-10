import Foundation

public enum LogLevel: String, Sendable {
  case info = "INFO"
  case error = "ERROR"
  case debug = "DEBUG"
}

public protocol Logger: Sendable {
  func log(_ message: String, level: LogLevel)
}

public extension Logger {
  func log(_ message: String, level: LogLevel = .info) {
    log(message, level: level)
  }
}

public final class SimpleLogger: Logger {
  public init() {}
  public func log(_ message: String, level: LogLevel) {
    print("[\(level.rawValue)] \(message)")
  }
}
