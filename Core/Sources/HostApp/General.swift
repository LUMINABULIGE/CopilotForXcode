import Client
import ComposableArchitecture
import Foundation
import LaunchAgentManager
<<<<<<< HEAD
import Status
import SwiftUI
import XPCShared
import Logger

@Reducer
public struct General {
    @ObservableState
    public struct State: Equatable {
        var xpcServiceVersion: String?
        var xpcCLSVersion: String?
        var isAccessibilityPermissionGranted: ObservedAXStatus = .unknown
        var isExtensionPermissionGranted: ExtensionPermissionStatus = .unknown
        var xpcServiceAuthStatus: AuthStatus = .init(status: .unknown)
        var isReloading = false
    }

    public enum Action: Equatable {
=======
import SwiftUI
import XPCShared

@Reducer
struct General {
    @ObservableState
    struct State: Equatable {
        var xpcServiceVersion: String?
        var isAccessibilityPermissionGranted: Bool?
        var isReloading = false
    }

    enum Action: Equatable {
>>>>>>> 4a8ae39... Pre-release 0.22.73
        case appear
        case setupLaunchAgentIfNeeded
        case openExtensionManager
        case reloadStatus
<<<<<<< HEAD
        case finishReloading(
            xpcServiceVersion: String,
            xpcCLSVersion: String?,
            axStatus: ObservedAXStatus,
            extensionStatus: ExtensionPermissionStatus,
            authStatus: AuthStatus
        )
        case failedReloading
        case retryReloading
=======
        case finishReloading(xpcServiceVersion: String, permissionGranted: Bool)
        case failedReloading
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }

    @Dependency(\.toast) var toast
    
    struct ReloadStatusCancellableId: Hashable {}
    
<<<<<<< HEAD
    public var body: some ReducerOf<Self> {
=======
    var body: some ReducerOf<Self> {
>>>>>>> 4a8ae39... Pre-release 0.22.73
        Reduce { state, action in
            switch action {
            case .appear:
                return .run { send in
<<<<<<< HEAD
                    await send(.setupLaunchAgentIfNeeded)
                    for await _ in DistributedNotificationCenter.default().notifications(named: .serviceStatusDidChange) {
                        await send(.reloadStatus)
                    }
=======
                    Task {
                        for await _ in DistributedNotificationCenter.default().notifications(named: NSNotification.Name("com.apple.accessibility.api")) {
                            await send(.reloadStatus)
                        }
                    }
                    await send(.setupLaunchAgentIfNeeded)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }

            case .setupLaunchAgentIfNeeded:
                return .run { send in
                    #if DEBUG
                    // do not auto install on debug build
<<<<<<< HEAD
                    await send(.reloadStatus)
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                    #else
                    Task {
                        do {
                            try await LaunchAgentManager()
                                .setupLaunchAgentForTheFirstTimeIfNeeded()
                        } catch {
<<<<<<< HEAD
                            Logger.ui.error("Failed to setup launch agent. \(error.localizedDescription)")
                            toast("Operation failed: permission denied. This may be due to missing background permissions.", .error)
                        }
                        await send(.reloadStatus)
                    }
                    #endif
=======
                            toast(error.localizedDescription, .error)
                        }
                    }
                    #endif
                    await send(.reloadStatus)
>>>>>>> 4a8ae39... Pre-release 0.22.73
                }

            case .openExtensionManager:
                return .run { send in
                    let service = try getService()
                    do {
                        _ = try await service
                            .send(requestBody: ExtensionServiceRequests.OpenExtensionManager())
                    } catch {
<<<<<<< HEAD
                        Logger.ui.error("Failed to open extension manager. \(error.localizedDescription)")
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                        toast(error.localizedDescription, .error)
                        await send(.failedReloading)
                    }
                }

            case .reloadStatus:
<<<<<<< HEAD
                guard !state.isReloading else { return .none }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                state.isReloading = true
                return .run { send in
                    let service = try getService()
                    do {
                        let isCommunicationReady = try await service.launchIfNeeded()
                        if isCommunicationReady {
                            let xpcServiceVersion = try await service.getXPCServiceVersion().version
                            let isAccessibilityPermissionGranted = try await service
                                .getXPCServiceAccessibilityPermission()
<<<<<<< HEAD
                            let isExtensionPermissionGranted = try await service.getXPCServiceExtensionPermission()
                            let xpcServiceAuthStatus = try await service.getXPCServiceAuthStatus() ?? .init(status: .unknown)
                            let xpcCLSVersion = try await service.getXPCCLSVersion()
                            await send(.finishReloading(
                                xpcServiceVersion: xpcServiceVersion,
                                xpcCLSVersion: xpcCLSVersion,
                                axStatus: isAccessibilityPermissionGranted,
                                extensionStatus: isExtensionPermissionGranted,
                                authStatus: xpcServiceAuthStatus
=======
                            await send(.finishReloading(
                                xpcServiceVersion: xpcServiceVersion,
                                permissionGranted: isAccessibilityPermissionGranted
>>>>>>> 4a8ae39... Pre-release 0.22.73
                            ))
                        } else {
                            toast("Launching service app.", .info)
                            try await Task.sleep(nanoseconds: 5_000_000_000)
<<<<<<< HEAD
                            await send(.retryReloading)
                        }
                    } catch let error as XPCCommunicationBridgeError {
                        Logger.ui.error("Failed to reach communication bridge. \(error.localizedDescription)")
                        toast(
                            "Unable to connect to the communication bridge. The helper application didn't respond. This may be due to missing background permissions.",
=======
                            await send(.reloadStatus)
                        }
                    } catch let error as XPCCommunicationBridgeError {
                        toast(
                            "Failed to reach communication bridge. \(error.localizedDescription)",
>>>>>>> 4a8ae39... Pre-release 0.22.73
                            .error
                        )
                        await send(.failedReloading)
                    } catch {
<<<<<<< HEAD
                        Logger.ui.error("Failed to reload status. \(error.localizedDescription)")
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
                        toast(error.localizedDescription, .error)
                        await send(.failedReloading)
                    }
                }.cancellable(id: ReloadStatusCancellableId(), cancelInFlight: true)

<<<<<<< HEAD
            case let .finishReloading(version, clsVersion, axStatus, extensionStatus, authStatus):
                state.xpcServiceVersion = version
                state.isAccessibilityPermissionGranted = axStatus
                state.isExtensionPermissionGranted = extensionStatus
                state.xpcServiceAuthStatus = authStatus
                state.xpcCLSVersion = clsVersion
=======
            case let .finishReloading(version, granted):
                state.xpcServiceVersion = version
                state.isAccessibilityPermissionGranted = granted
>>>>>>> 4a8ae39... Pre-release 0.22.73
                state.isReloading = false
                return .none

            case .failedReloading:
                state.isReloading = false
                return .none
<<<<<<< HEAD

            case .retryReloading:
                state.isReloading = false
                return .run { send in
                    await send(.reloadStatus)
                }
=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
            }
        }
    }
}

