import SwiftUI

struct PracticeDetailSheetItem: Identifiable {
    let id: UUID
}

struct MyPracticesView: View {
    @ObservedObject var practiceViewModel: PracticeViewModel
    @State private var showingAddPractice = false
    @State private var selectedPracticeDetail: PracticeDetailSheetItem?
    @State private var searchText = ""
    @State private var selectedFilter: PracticeFilter = .all
    
    enum PracticeFilter: String, CaseIterable {
        case all = "All"
        case favorites = "Favorites"
        case breathing = "Breathing"
        case stretching = "Stretching"
        case meditation = "Meditation"
        case exercise = "Exercise"
    }
    
    private var filteredPractices: [Practice] {
        var practices = practiceViewModel.practices
        
        if !searchText.isEmpty {
            practices = practices.filter { practice in
                practice.name.localizedCaseInsensitiveContains(searchText) ||
                practice.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedFilter {
        case .all:
            break
        case .favorites:
            practices = practices.filter { $0.isFavorite }
        case .breathing:
            practices = practices.filter { $0.type == .breathing }
        case .stretching:
            practices = practices.filter { $0.type == .stretching }
        case .meditation:
            practices = practices.filter { $0.type == .meditation }
        case .exercise:
            practices = practices.filter { $0.type == .exercise }
        }
        
        return practices.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Practices")
                        .font(.appTitle)
                        .foregroundColor(AppColors.primaryNavy)
                    
                    Spacer()
                    
                    Button(action: { showingAddPractice = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.primaryOrange)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                searchAndFilterSection
                
                if filteredPractices.isEmpty {
                    emptyStateView
                    Spacer()
                } else {
                    practicesListView
                }
            }
        }
        .sheet(isPresented: $showingAddPractice) {
            AddPracticeView(practiceViewModel: practiceViewModel)
        }
        .sheet(item: $selectedPracticeDetail) { item in
            PracticeDetailView(
                practiceId: item.id,
                practiceViewModel: practiceViewModel,
                onDismiss: { selectedPracticeDetail = nil }
            )
        }
    }
    
    private var searchAndFilterSection: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.mediumGray)
                
                TextField("Search practices...", text: $searchText)
                    .font(.bodyText)
                    .foregroundColor(AppColors.primaryNavy)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.mediumGray)
                    }
                }
            }
            .padding(12)
            .background(AppColors.cardGradient)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.mediumGray.opacity(0.3), lineWidth: 1)
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(PracticeFilter.allCases, id: \.self) { filter in
                        FilterButton(
                            title: filter.rawValue,
                            isSelected: selectedFilter == filter,
                            action: { selectedFilter = filter }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    private var practicesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredPractices) { practice in
                    MyPracticeCardView(
                        practice: practice,
                        onTap: {
                            selectedPracticeDetail = PracticeDetailSheetItem(id: practice.id)
                        },
                        onToggleFavorite: {
                            practiceViewModel.toggleFavorite(practice)
                        },
                        onComplete: {
                            practiceViewModel.completePractice(practice)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            if practiceViewModel.practices.isEmpty {
                EmptyStateView(
                    title: "No practices yet",
                    subtitle: "Add your first practice and start taking care of yourself",
                    buttonTitle: "Add Practice",
                    action: { showingAddPractice = true }
                )
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.mediumGray)
                    
                    VStack(spacing: 8) {
                        Text("No practices found")
                            .font(.cardTitle)
                            .foregroundColor(AppColors.primaryNavy)
                        
                        Text("Try adjusting your search or filter")
                            .font(.bodyText)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Button {
                        searchText = ""
                        selectedFilter = .all
                    } label: {
                        Text("Clear Filters")
                            .font(.buttonText)
                            .foregroundColor(AppColors.primaryOrange)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(AppColors.primaryOrange.opacity(0.1))
                            .cornerRadius(20)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 50)
    }
}

struct MyPracticeCardView: View {
    let practice: Practice
    let onTap: () -> Void
    let onToggleFavorite: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                Image(systemName: practice.type.icon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.primaryOrange)
                    .frame(width: 40, height: 40)
                    .background(AppColors.primaryOrange.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(practice.name)
                            .font(.cardTitle)
                            .foregroundColor(AppColors.primaryNavy)
                        
                        if practice.isFavorite {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.primaryOrange)
                        }
                    }
                    
                    HStack {
                        Text(practice.type.rawValue)
                            .font(.caption)
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(1)
                        
                        Text("•")
                            .font(.caption)
                            .foregroundColor(AppColors.mediumGray)
                        
                        Text("\(practice.duration) min")
                            .font(.caption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("•")
                            .font(.caption)
                            .foregroundColor(AppColors.mediumGray)
                        
                        Text(practice.frequency.rawValue)
                            .font(.caption)
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(1)
                    }
                    
                    if !practice.comment.isEmpty {
                        Text(practice.comment)
                            .font(.smallCaption)
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button(action: onToggleFavorite) {
                        Image(systemName: practice.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(practice.isFavorite ? AppColors.primaryOrange : AppColors.mediumGray)
                    }
                    
                    Button(action: onComplete) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.softGreen)
                    }
                }
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.primaryNavy.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? .white : AppColors.primaryNavy)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? AnyShapeStyle(AppColors.primaryOrange) : AnyShapeStyle(AppColors.cardGradient)
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? AppColors.primaryOrange : AppColors.mediumGray.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MyPracticesView_Previews: PreviewProvider {
    static var previews: some View {
        MyPracticesView(practiceViewModel: PracticeViewModel())
    }
}
