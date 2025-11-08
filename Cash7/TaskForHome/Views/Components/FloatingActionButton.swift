import SwiftUI

struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.pureWhite)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(Color.buttonGradient)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FloatingActionButton {
        print("FAB tapped")
    }
}

