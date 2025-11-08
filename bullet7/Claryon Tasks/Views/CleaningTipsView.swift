import SwiftUI

struct CleaningTipsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let tips = [
        CleaningTip(
            title: "Start Small",
            content: "Choose one zone and clean it completely. A small step creates a sense of movement."
        ),
        CleaningTip(
            title: "Don't Strive for Perfection",
            content: "It's enough to clean just enough to feel comfortable. The main thing is regularity."
        ),
        CleaningTip(
            title: "Divide into Parts",
            content: "If you're tired, clean half the room, and the rest tomorrow. It's still progress."
        ),
        CleaningTip(
            title: "Add Music",
            content: "Your favorite song makes cleaning almost like dancing. Let the mood help the work."
        ),
        CleaningTip(
            title: "Mark Success",
            content: "Every checkmark on the list is a step towards order and peace."
        ),
        CleaningTip(
            title: "Set a Timer",
            content: "Give yourself 15 minutes per zone. You'll be surprised how much you can accomplish."
        ),
        CleaningTip(
            title: "Reward Yourself",
            content: "After completing a zone, treat yourself to something nice. You've earned it."
        ),
        CleaningTip(
            title: "Make it Routine",
            content: "Clean one zone each day. Soon it will become a natural part of your schedule."
        )
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    HStack {
                        Text("Cleaning Tips")
                            .font(Font.titleLarge)
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                    }
                    
                    ForEach(tips) { tip in
                        TipCardView(tip: tip)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
    }
}

struct CleaningTip: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}

struct TipCardView: View {
    let tip: CleaningTip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(tip.title)
                .font(.titleSmall)
                .foregroundColor(.primaryWhite)
            
            Text(tip.content)
                .font(.bodyMedium)
                .foregroundColor(.secondaryText)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    CleaningTipsView()
}
