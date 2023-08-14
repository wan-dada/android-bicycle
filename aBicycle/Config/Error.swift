//
//  Error.swift
//  aBicycle
//
//  Created by 1 on 8/8/23.
//

enum AppError: Error, CustomStringConvertible {
    case PathNotFound(message: String?)
    case PathValid
    case CustomPathVaild
    case ExecutionFailed(message: String)
    
    case NotFoundEmulator
    case NotFoundActiveEmulator
    case AvdDataParsingFailed
    
    case FailedToDeleteAvd
    
    case FailedToGetProcessInfo
    case FailedToGetProcessID
    case FailedToKillProcess
    
    var description: String {
        switch self {
        case .PathNotFound:
            return "Path Not Found."
        case .PathValid:
            return "PATH is Valid."
        case .CustomPathVaild:
            return "In the application settings, the custom path is invalid."
        case .ExecutionFailed:
            return "Command execution failed."
        case .AvdDataParsingFailed:
            return "avdmanager list avd: data parsing failed."
        case .NotFoundEmulator:
            return "Not found avd."
        case .NotFoundActiveEmulator:
            return "Not Found Active Emulator."
        case .FailedToDeleteAvd:
            return "Failed to delete the avd."
        case .FailedToGetProcessInfo:
            return "Failed to get process information."
        case .FailedToGetProcessID:
            return "Failed to get process ID."
        case .FailedToKillProcess:
            return "Failed to kill process."
        }
    }
}
