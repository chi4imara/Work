import SwiftUI

struct MySetsView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var selectedFilter: SetFilter = .all
    @State private var searchText = ""
    @State private var showingCreateSet = false
    
    private var filteredSets: [CosmeticSet] {
        let sets = appViewModel.filteredSets(filter: selectedFilter)
        if searchText.isEmpty {
            return sets
        } else {
            return sets.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    HStack {
                        Text("My Sets")
                            .font(.titleLarge)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: {
                            showingCreateSet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.textPrimary)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(Color.buttonSecondary)
                                )
                        }
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textSecondary)
                        
                        TextField("Search by name...", text: $searchText)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.cardBorder, lineWidth: 1)
                            )
                    )
                    
                    HStack(spacing: 12) {
                        ForEach(SetFilter.allCases, id: \.self) { filter in
                            FilterButton(
                                title: filter.displayName,
                                isSelected: selectedFilter == filter
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedFilter = filter
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if filteredSets.isEmpty {
                    EmptyStateView(
                        title: "No sets created yet",
                        subtitle: "Start with a basic set — gather what should always be at hand.",
                        buttonTitle: "Create Set",
                        buttonAction: {
                            showingCreateSet = true
                        }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredSets) { set in
                                NavigationLink(destination: SetDetailView(appViewModel: appViewModel, setId: set.id)) {
                                    SetCardView(set: set) {}
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreateSet) {
            CreateSetView(appViewModel: appViewModel)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.buttonSmall)
                .foregroundColor(isSelected ? .white : .textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.buttonPrimary : Color.buttonSecondary)
                )
        }
    }
}

struct SetCardView: View {
    let set: CosmeticSet
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(set.name)
                        .font(.titleSmall)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(set.category.displayName)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    StatusBadge(isReady: set.isReady)
                    
                    Text("\(set.products.count) products")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            if !set.comment.isEmpty {
                Text(set.comment)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct StatusBadge: View {
    let isReady: Bool
    
    var body: some View {
        Text(isReady ? "Ready" : "Not Ready")
            .font(.captionMedium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isReady ? Color.statusReady : Color.statusNotReady)
            )
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "briefcase")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.textSecondary)
                
                VStack(spacing: 12) {
                    Text(title)
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 40)
            }
            
            Button(action: buttonAction) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text(buttonTitle)
                        .font(.buttonMedium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.buttonPrimary)
                )
            }
            
            Spacer()
        }
    }
}

#Preview {
    MySetsView(appViewModel: AppViewModel())
}
