import SwiftUI

struct HobbyCard: View {
    let hobby: Hobby
    @ObservedObject var viewModel: HobbyViewModel
    @State private var dragOffset: CGSize = .zero
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.primaryBlue.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: hobby.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(hobby.name)
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.primaryText)
                    .fontWeight(.semibold)
                
                Text("\(hobby.totalSessions) sessions • \(hobby.totalTimeFormatted)")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                
                ProgressView(value: hobby.progressPercentage)
                    .progressViewStyle(CustomProgressViewStyle())
                    .frame(height: 6)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorTheme.lightBlue)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: dragOffset)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                viewModel.selectedHobby = hobby
            }
        }
    }
}

struct CustomProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3)
                .fill(ColorTheme.lightBlue.opacity(0.3))
                .frame(height: 6)
            
            RoundedRectangle(cornerRadius: 3)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 200, height: 6)
                .animation(.easeInOut(duration: 0.8), value: configuration.fractionCompleted)
        }
    }
}
