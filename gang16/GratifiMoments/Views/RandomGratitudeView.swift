import SwiftUI

struct RandomGratitudeView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentEntry: GratitudeEntry?
    @State private var isAnimating = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.entriesCount == 0 {
                    emptyStateView
                } else {
                    contentView
                }
            }
        }
        .onAppear {
            loadRandomEntry()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Random Thank You")
                .font(.builderSans(.bold, size: 24))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: {
                loadRandomEntry()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .medium))
                    Text("Another")
                        .font(.builderSans(.medium, size: 16))
                }
                .foregroundColor(AppColors.primaryBlue)
            }
            .disabled(viewModel.entriesCount <= 1)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(spacing: 30) {
                titleSection
                
                if let entry = currentEntry {
                    randomEntryCard(entry)
                }
                
                actionButton
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
        }
    }
    
    private var titleSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryPurple.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .opacity(isAnimating ? 0.7 : 1.0)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 35, weight: .light))
                    .foregroundColor(AppColors.primaryPurple)
                    .rotationEffect(.degrees(isAnimating ? 10 : -10))
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
            
            Text("A Moment from Your Past")
                .font(.builderSans(.bold, size: 24))
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Here's a gratitude from your journal to brighten your day")
                .font(.builderSans(.regular, size: 16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
    }
    
    private func randomEntryCard(_ entry: GratitudeEntry) -> some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                
                Spacer()
                
                Image(systemName: "quote.closing")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            }
            .padding(.horizontal, 20)
            
            Text(entry.text)
                .font(.builderSans(.medium, size: 20))
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 10)
            
            VStack(spacing: 4) {
                Text("From:")
                    .font(.builderSans(.regular, size: 12))
                    .foregroundColor(AppColors.textLight)
                
                Text(entry.displayDate)
                    .font(.builderSans(.semiBold, size: 14))
                    .foregroundColor(AppColors.primaryBlue)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.textLight.opacity(0.15), radius: 12, x: 0, y: 6)
        )
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: isAnimating)
    }
    
    private var actionButton: some View {
        Button(action: {
            loadRandomEntry()
        }) {
            HStack {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.system(size: 20))
                Text("Show Another")
                    .font(.builderSans(.semiBold, size: 18))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
        }
        .disabled(viewModel.entriesCount <= 1)
        .opacity(viewModel.entriesCount <= 1 ? 0.6 : 1.0)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "leaf")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.accentPink)
            
            VStack(spacing: 16) {
                Text("No Gratitudes Yet")
                    .font(.builderSans(.bold, size: 24))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("You don't have any gratitude entries yet. Start with your first one.")
                    .font(.builderSans(.regular, size: 16))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = 0
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18))
                    Text("Add Entry")
                        .font(.builderSans(.semiBold, size: 18))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.primaryBlue)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private func loadRandomEntry() {
        let newEntry = viewModel.getRandomEntry()
        
        if viewModel.entriesCount > 1 {
            var attempts = 0
            var randomEntry = newEntry
            
            while randomEntry?.id == currentEntry?.id && attempts < 10 {
                randomEntry = viewModel.getRandomEntry()
                attempts += 1
            }
            
            currentEntry = randomEntry
        } else {
            currentEntry = newEntry
        }
    }
}
