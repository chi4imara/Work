import SwiftUI

struct AppColors {
    static let white = Color.white
    
    static let skyBlue = Color(red: 0.4, green: 0.7, blue: 0.95)
    static let lightBlue = Color(red: 0.5, green: 0.8, blue: 1.0)
    static let mediumBlue = Color(red: 0.3, green: 0.65, blue: 0.9)
    static let deepBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let paleBlue = Color(red: 0.7, green: 0.85, blue: 1.0)
    
    static let yellow = Color(red: 1.0, green: 0.85, blue: 0.2)
    static let goldenYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let brightYellow = Color(red: 1.0, green: 0.95, blue: 0.4)
    static let amber = Color(red: 1.0, green: 0.75, blue: 0.1)
    
    static let softGray = Color(red: 0.9, green: 0.9, blue: 0.95)
    static let mediumGray = Color(red: 0.6, green: 0.6, blue: 0.65)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.35)
    
    static let accent = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let pink = Color(red: 1.0, green: 0.6, blue: 0.8)
    static let purple = Color(red: 0.7, green: 0.5, blue: 0.9)
    static let mint = Color(red: 0.5, green: 0.9, blue: 0.7)
    static let coral = Color(red: 1.0, green: 0.6, blue: 0.5)
    
    static let primaryGradient = LinearGradient(
        colors: [
            Color(red: 0.5, green: 0.75, blue: 0.95),
            Color(red: 0.4, green: 0.7, blue: 0.9),
            Color(red: 0.35, green: 0.65, blue: 0.85),
            Color(red: 0.3, green: 0.6, blue: 0.85)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.4, green: 0.7, blue: 0.95).opacity(0.85),
            Color(red: 0.35, green: 0.65, blue: 0.9).opacity(0.9)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [yellow, goldenYellow],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let yellowGradient = LinearGradient(
        colors: [yellow, brightYellow],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let orangeGradient = LinearGradient(
        colors: [amber, yellow],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct AppBackground: View {
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            Circle()
                .fill(AppColors.paleBlue.opacity(0.15))
                .frame(width: 250, height: 250)
                .offset(x: -120, y: -250)
            
            Circle()
                .fill(AppColors.yellow.opacity(0.12))
                .frame(width: 180, height: 180)
                .offset(x: 140, y: 120)
            
            Circle()
                .fill(AppColors.lightBlue.opacity(0.1))
                .frame(width: 120, height: 120)
                .offset(x: -90, y: 180)
            
            Circle()
                .fill(AppColors.goldenYellow.opacity(0.08))
                .frame(width: 160, height: 160)
                .offset(x: 100, y: -150)
            
            Circle()
                .fill(AppColors.mint.opacity(0.06))
                .frame(width: 90, height: 90)
                .offset(x: -70, y: 50)
            
            Circle()
                .fill(AppColors.pink.opacity(0.05))
                .frame(width: 110, height: 110)
                .offset(x: 80, y: 200)
        }
    }
}
