import Foundation

struct FileRights: OptionSet {
    let rawValue: mode_t
    
    init(rawValue: mode_t) {
        self.rawValue = rawValue
    }
}
