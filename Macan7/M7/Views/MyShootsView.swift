import SwiftUI

struct MyShootsView: View {
    @EnvironmentObject var viewModel: PhotoshootViewModel
    @State private var showingNewScenario = false
    @State private var showingSortOptions = false
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                StaticBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchAndFilterBar
                    
                    if viewModel.filteredScenarios.isEmpty {
                        emptyStateView
                    } else {
                        scenariosList
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewScenario) {
            NewScenarioView()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Shoots")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            Spacer()
            
            Button(action: {
                showingNewScenario = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.appYellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFilterBar: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.appSecondaryText)
                
                TextField("Search by theme or location", text: $viewModel.searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(.appPrimaryText)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.appSecondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            
            HStack {
                Button {
                    withAnimation {
                        selectedTab = 2
                    }
                } label: {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Filters")
                            .font(.ubuntu(14, weight: .medium))
                    }
                    .foregroundColor(viewModel.filterOptions.isActive ? .appYellow : .appPrimaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.filterOptions.isActive ? Color.appYellow.opacity(0.2) : Color.white)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(viewModel.filterOptions.isActive ? Color.appYellow : Color.appLightGray, lineWidth: 1)
                            }
                    )
                }
                
                Spacer()
                
                Button(action: {
                    showingSortOptions = true
                }) {
                    HStack {
                        Image(systemName: viewModel.sortOption.systemImage)
                        Text("Sort")
                            .font(.ubuntu(14, weight: .medium))
                    }
                    .foregroundColor(.appPrimaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.appLightGray, lineWidth: 1)
                            }
                    )
                }
                .confirmationDialog("Sort by", isPresented: $showingSortOptions, titleVisibility: .visible) {
                    ForEach(PhotoshootViewModel.SortOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            viewModel.sortOption = option
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "camera.on.rectangle")
                .font(.system(size: 80))
                .foregroundColor(.appLightBlue)
            
            VStack(spacing: 8) {
                Text("No scenarios yet")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(.appPrimaryText)
                
                Text("Tap + to create your first photoshoot plan")
                    .font(.ubuntu(16))
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingNewScenario = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("New Shoot")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appPrimary)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var scenariosList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredScenarios) { scenario in
                    NavigationLink(destination: ScenarioDetailView(scenario: scenario)) {
                        ScenarioCard(scenario: scenario)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
}

struct ScenarioCard: View {
    let scenario: PhotoshootScenario
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(scenario.theme)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(.appPrimaryText)
                        .lineLimit(2)
                    
                    Text(scenario.location)
                        .font(.ubuntu(14))
                        .foregroundColor(.appSecondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: scenario.status.icon)
                        .font(.system(size: 20))
                        .foregroundColor(scenario.status == .planned ? .appPlanned : .appCompleted)
                    
                    Text(scenario.status.rawValue)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(scenario.status == .planned ? .appPlanned : .appCompleted)
                }
            }
            
            if !scenario.comment.isEmpty {
                Text(scenario.comment)
                    .font(.ubuntu(14))
                    .foregroundColor(.appSecondaryText)
                    .lineLimit(2)
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: scenario.category.icon)
                        .font(.system(size: 12))
                    Text(scenario.category.rawValue)
                        .font(.ubuntu(12))
                }
                .foregroundColor(.appDarkBlue)
                
                Spacer()
                
                Text(scenario.date, style: .date)
                    .font(.ubuntu(12))
                    .foregroundColor(.appSecondaryText)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .opacity(scenario.status == .completed ? 0.7 : 1.0)
    }
}
