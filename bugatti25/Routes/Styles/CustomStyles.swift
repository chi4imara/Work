import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.playfairDisplay(.semibold, size: 18))
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.primaryYellow)
                    .shadow(color: Color.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.playfairDisplay(.medium, size: 16))
            .foregroundColor(.primaryBlue)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.primaryBlue, lineWidth: 2)
                    .background(Color.white.opacity(0.8))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.playfairDisplay(.regular, size: 16))
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryBlue.opacity(0.3), lineWidth: 1)
                    }
            )
    }
}

struct CircularProgressView: View {
    let progress: Double
    let size: CGFloat
    
    private var clampedProgress: CGFloat {
        min(max(progress, 0), 1)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.primaryBlue.opacity(0.2), lineWidth: 8)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: clampedProgress)
                .stroke(
                    Color.primaryYellow,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: clampedProgress)
            
            Text("\(Int(clampedProgress * 100))%")
                .font(.playfairDisplay(.semibold, size: size * 0.2))
                .foregroundColor(.primaryBlue)
        }
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func primaryButtonStyle() -> some View {
        buttonStyle(PrimaryButtonStyle())
    }
    
    func secondaryButtonStyle() -> some View {
        buttonStyle(SecondaryButtonStyle())
    }
}
