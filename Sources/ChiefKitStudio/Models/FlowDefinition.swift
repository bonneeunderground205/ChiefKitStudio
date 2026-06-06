import Foundation

struct FlowDefinition: Codable, Hashable {
    var title: String
    var pages: [FlowPage]

    static func decode(_ text: String) -> Result<FlowDefinition, Error> {
        Result {
            let data = Data(text.utf8)
            return try JSONDecoder().decode(FlowDefinition.self, from: data)
        }
    }

    static let fallback = FlowDefinition(
        title: "Welcome Flow",
        pages: [
            FlowPage(
                id: "intro",
                title: "Build faster",
                body: "Compose onboarding screens from JSON and render them natively.",
                style: "hero",
                actions: ["Continue"]
            )
        ]
    )
}

struct FlowPage: Codable, Identifiable, Hashable {
    var id: String
    var title: String
    var body: String
    var style: String
    var actions: [String]
}
