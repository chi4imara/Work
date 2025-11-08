import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.theme.primaryBlue.opacity(0.3), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.theme.primaryBlue, lineWidth: 4)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1.0).repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            
            Text("Loading...")
                .font(.theme.body)
                .foregroundColor(Color.theme.secondaryText)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct PullToRefreshView: View {
    let action: () -> Void
    
    var body: some View {
        VStack {
            LoadingView()
                .scaleEffect(0.7)
        }
        .onAppear {
            action()
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        LoadingView()
        PullToRefreshView(action: {})
    }
    .padding()
    .background(
        LinearGradient(
            gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
