public enum FilterStatus: Identifiable, CaseIterable, Hashable {
    case started
    case stopped
    case pending
    
    public var id: String {
        switch (self) {
        case .started:
            "started"
        case .stopped:
            "stopped"
        case .pending:
            "pending"
        }
    }
    
    public var displayName: String {
        switch (self) {
        case .started:
            "Started"
        case .stopped:
            "Stopped"
        case .pending:
            "Wait pending"
        }
    }
    
    public var iconName: String {
        switch self {
        case .started:
            "checkmark.circle"
        case .stopped:
            "xmark.circle"
        case .pending:
            "checkmark.circle.trianglebadge.exclamationmark"
        }
    }
    
    public var tooltip: String {
        switch self {
        case .started:
            "Started"
        case .stopped:
            "Stopped"
        case .pending:
            "Pending"
        }
    }
    
    public static func == (lhs: FilterStatus, rhs: FilterStatus) -> Bool {
        lhs.id == rhs.id
    }
}
