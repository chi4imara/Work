import SwiftUI

struct RandomMemoryView: View {
    @StateObject private var diaryManager = DiaryManager.shared
    @State private var currentEntry: DiaryEntry?
    @State private var isAnimating = false
    
    let onDismiss: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(orbColor(for: index))
                        .frame(width: orbSize(for: index))
                        .position(orbPosition(for: index, in: geometry))
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 2...4))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.3),
                            value: isAnimating
                        )
                }
                
                VStack(spacing: 0) {
                    headerView
                    
                    if diaryManager.hasEntries {
                        memoryContentView
                    } else {
                        emptyStateView
                    }
                }
            }
        }
        .onAppear {
            loadRandomEntry()
            isAnimating = true
        }
    }
        
    private var headerView: some View {
        HStack {
            Text("Random Memory")
                .font(AppTheme.Typography.largeTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
            
            Button(action: loadAnotherRandomEntry) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppTheme.Colors.primaryText)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.md)
    }
        
    private var memoryContentView: some View {
        VStack {
            Spacer()
            
            if let entry = currentEntry {
                VStack(spacing: AppTheme.Spacing.xl) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppTheme.Colors.accent)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    VStack(spacing: AppTheme.Spacing.lg) {
                        Text(entry.text)
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, AppTheme.Spacing.md)
                        
                        Divider()
                            .background(AppTheme.Colors.secondaryText)
                        
                        Text("Date: \(entry.formattedDate)")
                            .font(AppTheme.Typography.callout)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                    .padding(AppTheme.Spacing.xl)
                    .background(AppTheme.Colors.cardBackground)
                    .cornerRadius(AppTheme.CornerRadius.xl)
                    .shadow(color: AppTheme.Shadow.light, radius: 10, x: 0, y: 5)
                    
                    Button(action: loadAnotherRandomEntry) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Another Memory")
                        }
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(AppTheme.Colors.primaryPurple)
                        .cornerRadius(AppTheme.CornerRadius.md)
                    }
                    .disabled(diaryManager.entriesCount <= 1)
                    .opacity(diaryManager.entriesCount <= 1 ? 0.6 : 1.0)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
            }
            
            Spacer()
        }
    }
        
    private var emptyStateView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.xl) {
                Image(systemName: "captions.bubble.fill")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                VStack(spacing: AppTheme.Spacing.md) {
                    Text("You don't have any memories yet.")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text("Start today.")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: onDismiss) {
                    Text("Create Entry")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(AppTheme.Colors.primaryPurple)
                        .cornerRadius(AppTheme.CornerRadius.md)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            
            Spacer()
        }
    }
        
    private func loadRandomEntry() {
        currentEntry = diaryManager.getRandomEntry()
    }
    
    private func loadAnotherRandomEntry() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentEntry = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentEntry = diaryManager.getRandomEntry(excluding: currentEntry)
            }
        }
    }
    
    private func orbColor(for index: Int) -> Color {
        switch index % 4 {
        case 0: return AppTheme.Colors.orb1
        case 1: return AppTheme.Colors.orb2
        case 2: return AppTheme.Colors.orb3
        default: return AppTheme.Colors.accent.opacity(0.1)
        }
    }
    
    private func orbSize(for index: Int) -> CGFloat {
        let sizes: [CGFloat] = [45, 25, 65, 35, 55]
        return sizes[index % sizes.count]
    }
    
    private func orbPosition(for index: Int, in geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        
        let positions: [CGPoint] = [
            CGPoint(x: width * 0.1, y: height * 0.15),
            CGPoint(x: width * 0.9, y: height * 0.25),
            CGPoint(x: width * 0.2, y: height * 0.85),
            CGPoint(x: width * 0.8, y: height * 0.9),
            CGPoint(x: width * 0.5, y: height * 0.05)
        ]
        
        return positions[index % positions.count]
    }
}

#Preview {
    RandomMemoryView {
        print("Random memory dismissed")
    }
}
