import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isNotEmpty: Bool {
        !self.trimmed.isEmpty
    }
}

extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
