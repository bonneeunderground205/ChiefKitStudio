import Foundation

struct TimelineEvent: Identifiable, Hashable {
    let id = UUID()
    let action: String
    let state: String
    let timestamp: Date

    var timeText: String {
        timestamp.formatted(date: .omitted, time: .standard)
    }
}
