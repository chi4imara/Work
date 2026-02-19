import SwiftUI

struct MainScreenView: View {
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject var bookingsViewModel: BookingsViewModel
    @StateObject private var viewModel = MainScreenViewModel()
    @State private var showingFilters = false
    @State private var showingBookingSheet = false
    @State private var showingAddCatalogSession = false
    @State private var selectedSession: Session?
    
    var body: some View {
        ZStack {
            Color.clear
            
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    
                    searchAndFiltersSection
                    
                    quickFiltersSection
                    
                    sessionsListSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 120)
            }
            .refreshable {
                viewModel.refreshRecommendations()
            }
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddCatalogSession) {
            AddCatalogSessionView(onSave: { session in
                viewModel.addSessionToCatalog(session)
                showingAddCatalogSession = false
            })
            .environmentObject(appState)
        }
        .sheet(item: $selectedSession) { session in
            BookingSheet(session: session) { newSession in
                viewModel.bookSession(newSession)
            }
        }
        .onAppear {
            viewModel.onBookSession = { session in
                bookingsViewModel.addBooking(session)
            }
        }
        .onChange(of: appState.sampleDataLoadedTrigger) { _ in
            viewModel.reloadFromStorage()
        }
        .onChange(of: viewModel.searchText) { _ in
            viewModel.applyFilters()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recommended Sessions")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Text("Find the perfect procedure for relaxation, wellness or anti-stress")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Button(action: { showingAddCatalogSession = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
            }
        }
    }
    
    private var searchAndFiltersSection: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorTheme.textSecondary)
                
                TextField("Search sessions, masters...", text: $viewModel.searchText)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textPrimary)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardBackground)
                    .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
            )
            
            Button(action: { showingFilters = true }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.buttonGradient)
                    )
                    .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
            }
        }
    }
    
    private var quickFiltersSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(MassageType.allCases, id: \.self) { type in
                    QuickFilterChip(
                        title: type.rawValue,
                        icon: type.icon,
                        isSelected: viewModel.selectedMassageTypes.contains(type),
                        color: type.color
                    ) {
                        if viewModel.selectedMassageTypes.contains(type) {
                            viewModel.selectedMassageTypes.remove(type)
                        } else {
                            viewModel.selectedMassageTypes.insert(type)
                        }
                        viewModel.applyFilters()
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
    
    private var sessionsListSection: some View {
        LazyVStack(spacing: 16) {
            if viewModel.filteredSessions.isEmpty {
                EmptyStateView(
                    title: viewModel.sessions.isEmpty ? "No available sessions" : "No matching sessions",
                    description: viewModel.sessions.isEmpty ? "Add your first session to get started" : "Try adjusting your filters or check back later",
                    buttonTitle: viewModel.sessions.isEmpty ? "Add Session" : "Reset Filters",
                    buttonAction: {
                        if viewModel.sessions.isEmpty {
                            showingAddCatalogSession = true
                        } else {
                            viewModel.clearFilters()
                        }
                    }
                )
                .padding(.top, 40)
            } else {
                ForEach(viewModel.filteredSessions) { session in
                    SessionCard(session: session) {
                        selectedSession = session
                        showingBookingSheet = true
                    }
                }
            }
        }
    }
}

struct QuickFilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : ColorTheme.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? color : ColorTheme.cardBackground)
                    .shadow(color: ColorTheme.shadowColor, radius: isSelected ? 5 : 2, x: 0, y: 2)
            )
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

struct SessionCard: View {
    let session: Session
    let onBook: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(ColorTheme.primaryBlue.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(session.master.name.prefix(1)))
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(ColorTheme.primaryBlue)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(session.master.name)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    HStack(spacing: 4) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(ColorTheme.primaryYellow)
                            
                            Text(String(format: "%.1f", session.master.rating))
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(ColorTheme.textSecondary)
                        }
                        
                        Text("•")
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        Text("\(session.master.reviewCount) reviews")
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        if session.master.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundColor(ColorTheme.primaryBlue)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(session.formattedPrice)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorTheme.primaryBlue)
                    
                    Text(session.duration.displayName)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(session.title)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                HStack(spacing: 12) {
                    Label(session.type.rawValue, systemImage: session.type.icon)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(session.type.color)
                    
                    Label(session.location.rawValue, systemImage: session.location.icon)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                }
            }
            
            Button(action: onBook) {
                Text("Book Session")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.buttonGradient)
                    )
                    .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
        )
    }
}

struct EmptyStateView: View {
    let title: String
    let description: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.textSecondary.opacity(0.5))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text(description)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: buttonAction) {
                Text(buttonTitle)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ColorTheme.buttonGradient)
                    )
            }
        }
        .padding(40)
    }
}

#Preview {
    MainScreenView()
}
