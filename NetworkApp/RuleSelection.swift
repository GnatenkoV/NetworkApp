//
//  RuleSelection.swift
//  NetworkApp
//
//  Created by user on 01.11.2024.
//

public enum RuleSelection: Identifiable, CaseIterable, Hashable {
    case all
    case enabled
    case disabled
    
    public var id: String {
        switch (self) {
        case .all:
            "all"
        case .enabled:
            "enabled"
        case .disabled:
            "disabled"
        }
    }
    
    public var displayName: String {
        switch (self) {
        case .all:
            "All"
        case .enabled:
            "Enabled"
        case .disabled:
            "Disabled"
        }
    }
    
    public var iconName: String {
        switch self {
        case .all:
            "star"
        case .enabled:
            "togglepower"
        case .disabled:
            "poweroff"
        }
    }
    
    public static var allCases: [RuleSelection] {
        [.all, .enabled, .disabled]
    }
    
    public static func == (lhs: RuleSelection, rhs: RuleSelection) -> Bool {
        lhs.id == rhs.id
    }
}
