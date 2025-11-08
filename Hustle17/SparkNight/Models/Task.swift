import Foundation

struct PartyTask: Identifiable, Codable, Equatable {
    let id = UUID()
    var text: String
    var dateCreated: Date
    
    init(text: String) {
        self.text = text
        self.dateCreated = Date()
    }
}

extension PartyTask {
    static let defaultTasks = [
        PartyTask(text: "Sing your favorite song"),
        PartyTask(text: "Tell a funny story"),
        PartyTask(text: "Do a silly dance"),
        PartyTask(text: "Make everyone laugh"),
        PartyTask(text: "Give a toast"),
        PartyTask(text: "Imitate a celebrity"),
        PartyTask(text: "Share an embarrassing moment"),
        PartyTask(text: "Do 10 push-ups")
    ]
}
