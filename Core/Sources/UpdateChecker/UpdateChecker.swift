import Logger
import Preferences
import Sparkle

<<<<<<< HEAD
public protocol UpdateCheckerProtocol {
    func checkForUpdates()
    func getAutomaticallyChecksForUpdates() -> Bool
    func setAutomaticallyChecksForUpdates(_ value: Bool)
}

public protocol UpdateCheckerDelegate: AnyObject {
    func prepareForRelaunch(finish: @escaping () -> Void)
}

public final class NoopUpdateChecker: UpdateCheckerProtocol {
    public init() {}
    public func checkForUpdates() {}
    public func getAutomaticallyChecksForUpdates() -> Bool { false }
    public func setAutomaticallyChecksForUpdates(_ value: Bool) {}
}

public final class UpdateChecker: UpdateCheckerProtocol {
    let updater: SPUUpdater
    let delegate = UpdaterDelegate()

    public init(hostBundle: Bundle, checkerDelegate: UpdateCheckerDelegate) {
        updater = SPUUpdater(
            hostBundle: hostBundle,
            applicationBundle: Bundle.main,
            userDriver: SPUStandardUserDriver(hostBundle: hostBundle, delegate: nil),
            delegate: delegate
        )
        delegate.updateCheckerDelegate = checkerDelegate
=======
public final class UpdateChecker {
    let updater: SPUUpdater
    let hostBundleFound: Bool
    let delegate = UpdaterDelegate()

    public init(hostBundle: Bundle?) {
        if hostBundle == nil {
            hostBundleFound = false
            Logger.updateChecker.error("Host bundle not found")
        } else {
            hostBundleFound = true
        }
        updater = SPUUpdater(
            hostBundle: hostBundle ?? Bundle.main,
            applicationBundle: Bundle.main,
            userDriver: SPUStandardUserDriver(hostBundle: hostBundle ?? Bundle.main, delegate: nil),
            delegate: delegate
        )
>>>>>>> 4a8ae39... Pre-release 0.22.73
        do {
            try updater.start()
        } catch {
            Logger.updateChecker.error(error.localizedDescription)
        }
    }

<<<<<<< HEAD
    public convenience init?(hostBundle: Bundle?, checkerDelegate: UpdateCheckerDelegate) {
        guard let hostBundle = hostBundle else { return nil }
        self.init(hostBundle: hostBundle, checkerDelegate: checkerDelegate)
    }

=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    public func checkForUpdates() {
        updater.checkForUpdates()
    }

<<<<<<< HEAD
    public func getAutomaticallyChecksForUpdates() -> Bool {
        updater.automaticallyChecksForUpdates
    }

    public func setAutomaticallyChecksForUpdates(_ value: Bool) {
        updater.automaticallyChecksForUpdates = value
=======
    public var automaticallyChecksForUpdates: Bool {
        get { updater.automaticallyChecksForUpdates }
        set { updater.automaticallyChecksForUpdates = newValue }
>>>>>>> 4a8ae39... Pre-release 0.22.73
    }
}

class UpdaterDelegate: NSObject, SPUUpdaterDelegate {
<<<<<<< HEAD
    weak var updateCheckerDelegate: UpdateCheckerDelegate?

    func updater(
        _ updater: SPUUpdater,
        shouldPostponeRelaunchForUpdate item: SUAppcastItem,
        untilInvokingBlock installHandler: @escaping () -> Void) -> Bool {
        if let updateCheckerDelegate {
            updateCheckerDelegate.prepareForRelaunch(finish: installHandler)
            return true
        }
        return false
    }

=======
>>>>>>> 4a8ae39... Pre-release 0.22.73
    func allowedChannels(for updater: SPUUpdater) -> Set<String> {
        if UserDefaults.shared.value(for: \.installPrereleases) {
            Set(["prerelease"])
        } else {
            []
        }
    }
}

