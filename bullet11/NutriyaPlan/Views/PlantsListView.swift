import SwiftUI

struct PlantsListView: View {
    @ObservedObject var appViewModel: AppViewModel
    let onPlantTap: (Plant) -> Void
    let onMenuTap: () -> Void
    @Binding var showingSidebar: Bool
    
    @State private var showingFilterSheet = false
    @State private var showingAddPlant = false
    
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                UniversalHeaderView(
                    title: "My Plants",
                    onMenuTap: onMenuTap,
                    rightButton: AnyView(
                        HStack(spacing: 12) {
                            Button(action: { showingFilterSheet = true }) {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(AppTheme.primaryWhite)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.primaryYellow.opacity(0.2))
                                    )
                            }
                            
                            Button(action: { showingAddPlant = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(AppTheme.darkBlue)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.primaryYellow)
                                    )
                            }
                        }
                    )
                )
                
                if appViewModel.filteredAndSortedPlants().isEmpty {
                    EmptyStateView(
                        imageName: "leaf.circle",
                        title: "No plants yet",
                        description: "Add your first plant to start tracking fertilization schedules",
                        buttonTitle: "Add First Plant",
                        buttonAction: { showingAddPlant = true }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(appViewModel.filteredAndSortedPlants()) { plant in
                                PlantCardView(
                                    plant: plant,
                                    onTap: {
                                        onPlantTap(plant)
                                    },
                                    onFertilizeToday: {
                                        appViewModel.fertilizePlantToday(plant)
                                    },
                                    onDelete: {
                                        appViewModel.deletePlant(plant)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSortSheet(appViewModel: appViewModel)
        }
        .sheet(isPresented: $showingAddPlant) {
            AddPlantView(appViewModel: appViewModel, plant: nil, showingSidebar: $showingSidebar) {
                showingAddPlant = false
            }
        }
    }
}


struct PlantCardView: View {
    let plant: Plant
    let onTap: () -> Void
    let onFertilizeToday: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppTheme.primaryWhite)
                    Text("Fertilize")
                        .font(.appSmall)
                        .foregroundColor(AppTheme.primaryWhite)
                }
                .opacity(dragOffset.width > 50 ? 1.0 : 0.0)
                .scaleEffect(dragOffset.width > 50 ? 1.0 : 0.8)
                
                Spacer()
                
                VStack {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppTheme.statusRed)
                    Text("Delete")
                        .font(.appSmall)
                        .foregroundColor(AppTheme.statusRed)
                }
                .opacity(dragOffset.width < -50 ? 1.0 : 0.0)
                .scaleEffect(dragOffset.width < -50 ? 1.0 : 0.8)
            }
            .padding(.horizontal, 20)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: dragOffset.width)
            .allowsHitTesting(false)
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(plant.name)
                                .font(.cardTitle)
                                .foregroundColor(AppTheme.darkBlue)
                            
                            Text("Last fertilized: \(plant.lastFertilizedDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.appCaption)
                                .foregroundColor(AppTheme.darkBlue.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Text(plant.status.emoji)
                            .font(.system(size: 24))
                    }
                    
                    HStack {
                        Text("Every \(plant.intervalDays) days")
                            .font(.appCaption)
                            .foregroundColor(AppTheme.darkBlue.opacity(0.7))
                        
                        Spacer()
                        
                        Text("Passed: \(plant.daysPassed) of \(plant.intervalDays)")
                            .font(.appCaption)
                            .foregroundColor(AppTheme.darkBlue.opacity(0.7))
                    }
                    
                    HStack {
                        Circle()
                            .fill(statusColor(for: plant.status))
                            .frame(width: 8, height: 8)
                        
                        Text(plant.status.displayName)
                            .font(.appCaption)
                            .foregroundColor(statusColor(for: plant.status))
                    }
                }
                .padding(16)
                .background(AppTheme.cardGradient)
                .cornerRadius(16)
                .shadow(color: AppTheme.shadowColor, radius: 8, x: 0, y: 4)
                
                if let message = plant.needsAttentionMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.statusRed)
                        
                        Text(message)
                            .font(.appSmall)
                            .foregroundColor(AppTheme.statusRed)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .offset(x: dragOffset.width, y: 0)
            .highPriorityGesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        let maxOffset: CGFloat = 120
                        let clampedTranslation = max(-maxOffset, min(maxOffset, value.translation.width))
                        dragOffset = CGSize(width: clampedTranslation, height: 0)
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if value.translation.width > 100 {
                                onFertilizeToday()
                            } else if value.translation.width < -100 {
                                showingDeleteConfirmation = true
                            }
                            dragOffset = .zero
                        }
                    }
            )
            .onTapGesture {
                onTap()
            }
        }
        .alert("Delete Plant", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \(plant.name)? This will also delete all fertilization history for this plant.")
        }
    }
    
    private func statusColor(for status: PlantStatus) -> Color {
        switch status {
        case .recentlyFertilized:
            return AppTheme.statusGreen
        case .soonToFertilize:
            return AppTheme.statusYellow
        case .needsFertilizing:
            return AppTheme.statusRed
        }
    }
}

struct EmptyStateView: View {
    let imageName: String
    let title: String
    let description: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(AppTheme.primaryWhite.opacity(0.6))
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.screenTitle)
                    .foregroundColor(AppTheme.primaryWhite)
                
                Text(description)
                    .font(.appBody)
                    .foregroundColor(AppTheme.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Button(action: buttonAction) {
                Text(buttonTitle)
                    .font(.buttonMedium)
                    .foregroundColor(AppTheme.darkBlue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppTheme.yellowGradient)
                    .cornerRadius(20)
            }
            
            Spacer()
        }
    }
}

struct FilterSortSheet: View {
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Filter")
                            .font(.cardTitle)
                            .foregroundColor(AppTheme.primaryWhite)
                        
                        VStack(spacing: 8) {
                            ForEach(PlantFilter.allCases, id: \.self) { filter in
                                FilterOptionView(
                                    title: filter.displayName,
                                    isSelected: appViewModel.settings.currentFilter == filter,
                                    action: {
                                        appViewModel.updateFilter(filter)
                                    }
                                )
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sort")
                            .font(.cardTitle)
                            .foregroundColor(AppTheme.primaryWhite)
                        
                        VStack(spacing: 8) {
                            ForEach(PlantSortOption.allCases, id: \.self) { sort in
                                FilterOptionView(
                                    title: sort.displayName,
                                    isSelected: appViewModel.settings.currentSort == sort,
                                    action: {
                                        appViewModel.updateSort(sort)
                                    }
                                )
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Filter & Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct FilterOptionView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.appBody)
                    .foregroundColor(AppTheme.primaryWhite)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.primaryYellow)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppTheme.primaryYellow.opacity(0.1) : Color.clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AppTheme.primaryYellow : Color.gray.opacity(0.6), lineWidth: 1)
                    }
            )
        }
    }
}

#Preview {
    PlantsListView(
        appViewModel: AppViewModel(),
        onPlantTap: { _ in },
        onMenuTap: { },
        showingSidebar: .constant(false)
    )
}
