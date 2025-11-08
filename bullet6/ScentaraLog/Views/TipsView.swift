import SwiftUI

struct TipsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ScentDiaryViewModel
    
    private let tips = [
        Tip(
            title: "Notice First Impressions",
            description: "When you smell something — stop for a second and ask yourself what it reminds you of."
        ),
        Tip(
            title: "Don't Look for Rarities",
            description: "Sometimes the simplest scents — morning coffee, soap, fresh bread — are the most vivid."
        ),
        Tip(
            title: "Write About Feelings",
            description: "Don't limit yourself to describing the scent, add emotions — that's the essence of your diary."
        ),
        Tip(
            title: "Scent is Memory",
            description: "Aromas are often connected to memories. Record what exactly comes to mind."
        ),
        Tip(
            title: "Listen to Space",
            description: "Every place smells different. Learn to feel the atmosphere, not just see it."
        ),
        Tip(
            title: "Create Rituals",
            description: "Try to notice scents at specific times — morning walks, evening tea, cooking dinner."
        ),
        Tip(
            title: "Be Patient",
            description: "Some scents reveal themselves gradually. Give yourself time to fully experience them."
        ),
        Tip(
            title: "Connect with Seasons",
            description: "Each season has its unique scents. Notice how they change throughout the year."
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    HStack {
                        Text("Tips About Sensations")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    ForEach(tips, id: \.title) { tip in
                        TipCard(tip: tip)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
    }
}

struct Tip {
    let title: String
    let description: String
}

struct TipCard: View {
    let tip: Tip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(tip.title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            Text(tip.description)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient.cardGradient)
                .shadow(color: AppColors.cardShadow, radius: 6, x: 0, y: 3)
        )
    }
}
