public enum ExtensionStatus: Identifiable, CaseIterable, Hashable {
    case installed
    case uninstalled
    case wait_approve
    case wait_uninstall
    
    public var id: String {
        switch (self) {
        case .installed:
            "installed"
        case .uninstalled:
            "uninstalled"
        case .wait_approve:
            "wait_approve"
        case .wait_uninstall:
            "wait_uninstall"
        }
    }
    
    public var displayName: String {
        switch (self) {
        case .installed:
            "Installed"
        case .uninstalled:
            "Uninstalled"
        case .wait_approve:
            "Wait Approve"
        case .wait_uninstall:
            "wait_uninstall"
        }
    }
    
    public var iconName: String {
        switch self {
        case .installed:
            "checkmark.circle"
        case .uninstalled:
            "xmark.circle"
        case .wait_approve:
            "checkmark.circle.trianglebadge.exclamationmark"
        case .wait_uninstall:
            "checkmark.circle.trianglebadge.exclamationmark"
        }
    }
    
    public var tooltip: String {
        switch self {
        case .installed:
            "Installed"
        case .uninstalled:
            "Not installed"
        case .wait_approve:
            "Waiting for approve"
        case .wait_uninstall:
            "Wait for uninstall"
        }
    }
    
    public static func == (lhs: ExtensionStatus, rhs: ExtensionStatus) -> Bool {
        lhs.id == rhs.id
    }
}
