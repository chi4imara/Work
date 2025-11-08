import SwiftUI

struct FavoritesView: View {
    @StateObject private var dataManager = MoodDataManager.shared
    @State private var animateContent = false
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var presentedSheet: SheetType?
    
    enum SheetType: Identifiable {
        case dayDetails(MoodEntry)
        
        var id: String {
            switch self {
            case .dayDetails(let entry):
                return "dayDetails_\(entry.id)"
            }
        }
    }
    
    var favoriteEntries: [MoodEntry] {
        dataManager.getFavoriteEntries()
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if favoriteEntries.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
        }
        .sheet(item: $presentedSheet) { sheetType in
            switch sheetType {
            case .dayDetails(let entry):
                DayDetailsView(selectedDate: entry.date, isPresented: .constant(false))
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateContent = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorite Days")
                .font(AppTheme.Fonts.largeTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : -30)
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.accentYellow.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .scaleEffect(pulseScale)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppTheme.Colors.accentYellow)
                    .rotationEffect(.degrees(rotationAngle))
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .scaleEffect(animateContent ? 1.0 : 0.5)
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.md)
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : -20)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.md) {
                ForEach(Array(favoriteEntries.enumerated()), id: \.element.id) { index, entry in
                    FavoriteEntryCard(entry: entry) {
                        presentedSheet = .dayDetails(entry)
                    } onRemoveFromFavorites: {
                        withAnimation(AnimationUtils.safeDragAnimation()) {
                            dataManager.toggleFavorite(for: entry.date)
                        }
                    }
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(x: animateContent ? 0 : -50)
                    .animation(AnimationUtils.safeListAnimation(index: index), value: animateContent)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.lg)
            .padding(.bottom, 80)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()
            
            Image(systemName: "star")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppTheme.Colors.accentYellow)
                .opacity(animateContent ? 1.0 : 0.0)
                .scaleEffect(animateContent ? 1.0 : 0.8)
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text("No favorite days yet")
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                
                Text("Go to the calendar and mark special days as favorites by long-pressing on them")
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            
            Spacer()
        }
    }
}

struct FavoriteEntryCard: View {
    let entry: MoodEntry
    let onTap: () -> Void
    let onRemoveFromFavorites: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var showRemoveButton = false
    
    private var safeOffset: CGFloat {
        max(-80, min(0, offset))
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Button(action: onRemoveFromFavorites) {
                    VStack {
                        Image(systemName: "star.slash")
                            .font(.system(size: 20, weight: .medium))
                        
                        Text("Remove")
                            .font(AppTheme.Fonts.caption1)
                    }
                    .foregroundColor(.white)
                    .frame(width: 80)
                }
                .frame(maxHeight: .infinity)
                .background(AppTheme.Colors.error)
                .opacity(showRemoveButton ? 1.0 : 0.0)
            }
            
            HStack(spacing: AppTheme.Spacing.md) {
                Circle()
                    .fill(entry.moodColor.color)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: AppTheme.Shadow.light, radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    HStack {
                        Text(dateFormatter.string(from: entry.date))
                            .font(AppTheme.Fonts.headline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        Spacer()
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.Colors.accentYellow)
                    }
                    
                    Text("\(entry.moodColor.displayName) — \(entry.moodColor.emotion)")
                        .font(AppTheme.Fonts.subheadline)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    if !entry.note.isEmpty {
                        Text(entry.note)
                            .font(AppTheme.Fonts.caption1)
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.Colors.tertiaryText)
            }
            .padding(AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .fill(AppTheme.Colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .offset(x: safeOffset)
            .onTapGesture {
                if offset == 0 {
                    onTap()
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        offset = 0
                        showRemoveButton = false
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            let translation = value.translation.width
                            offset = max(min(translation, 80), -80)
                            showRemoveButton = offset < -40
                        }
                    }
                    .onEnded { value in
                        withAnimation(AnimationUtils.safeDragAnimation()) {
                            if offset < -40 {
                                offset = -80
                                showRemoveButton = true
                            } else if offset > 40 {
                                offset = 0
                                showRemoveButton = false
                            } else {
                                offset = 0
                                showRemoveButton = false
                            }
                        }
                    }
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
    }
}

#Preview {
    FavoritesView()
}
