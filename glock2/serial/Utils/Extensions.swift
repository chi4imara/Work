import SwiftUI

extension Series {
    static let sampleData: [Series] = [
        Series(
            title: "Breaking Bad",
            description: "A high school chemistry teacher turned methamphetamine producer partners with a former student to secure his family's financial future.",
            category: .drama,
            status: .watching
        ),
        Series(
            title: "The Office",
            description: "A mockumentary sitcom about the everyday lives of office employees working at a paper company.",
            category: .comedy,
            status: .waiting
        ),
        Series(
            title: "Stranger Things",
            description: "A group of kids in a small town uncover supernatural mysteries and government conspiracies.",
            category: .sciFi,
            status: .watching
        ),
        Series(
            title: "Friends",
            description: "Six friends navigate life and relationships in New York City.",
            category: .comedy,
            status: .waiting
        )
    ]
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
