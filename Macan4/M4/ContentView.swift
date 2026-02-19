import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 24) {
                Image(systemName: "face.smiling")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppColors.primaryBlue)
                
                VStack(spacing: 12) {
                    Text("Makeup Organizer")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Your personal beauty companion")
                        .font(.playfairDisplay(16))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
