import SwiftUI

struct MemoriesView: View {
    @StateObject private var viewModel = IdeaViewModel()
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                if filteredMemories.isEmpty {
                    emptyStateView
                } else {
                    memoriesListView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Our Memories")
                    .font(.playfair(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Cherished moments together")
                    .font(.playfair(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            if !viewModel.completedIdeasWithMemories.isEmpty {
                Text("\(viewModel.completedIdeasWithMemories.count)")
                    .font(.playfair(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(AppColors.blueText)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search memories...", text: $searchText)
                .font(.playfair(size: 16))
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var memoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredMemories) { idea in
                    MemoryCardView(idea: idea, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "star.circle")
                .font(.system(size: 80))
                .foregroundColor(AppColors.lightText)
            
            VStack(spacing: 12) {
                Text(searchText.isEmpty ? "No memories yet" : "No matching memories")
                    .font(.playfair(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(searchText.isEmpty ?
                     "When you mark an idea as completed, it will appear here." :
                        "Try adjusting your search.")
                .font(.playfair(size: 16))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var filteredMemories: [Idea] {
        let memories = viewModel.completedIdeasWithMemories
        
        if searchText.isEmpty {
            return memories
        } else {
            return memories.filter { idea in
                idea.title.localizedCaseInsensitiveContains(searchText) ||
                idea.memory?.localizedCaseInsensitiveContains(searchText) == true ||
                idea.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct MemoryCardView: View {
    let idea: Idea
    let viewModel: IdeaViewModel
    @State private var selectedIdeaId: UUID?
    @State private var isExpanded = false
    
    var body: some View {
        Button(action: {
            selectedIdeaId = idea.id
        }) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(idea.title)
                            .font(.playfair(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 8) {
                            Image(systemName: idea.category.icon)
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.blueText)
                            
                            Text(idea.category.rawValue)
                                .font(.playfair(size: 12, weight: .medium))
                                .foregroundColor(AppColors.blueText)
                            
                            Spacer()
                            
                            Text(idea.shortDateString)
                                .font(.playfair(size: 12))
                                .foregroundColor(AppColors.lightText)
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.mintGreen)
                    }
                }
                
                if let memory = idea.memory, !memory.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "quote.opening")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.blueText)
                            
                            Text("Memory")
                                .font(.playfair(size: 14, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            Spacer()
                        }
                        
                        Text(memory)
                            .font(.playfair(size: 15))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(isExpanded ? nil : 3)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(2)
                        
                        if memory.count > 100 {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded.toggle()
                                }
                            }) {
                                Text(isExpanded ? "Show less" : "Show more")
                                    .font(.playfair(size: 12, weight: .medium))
                                    .foregroundColor(AppColors.blueText)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        selectedIdeaId = idea.id
                    }) {
                        HStack(spacing: 6) {
                            Text("View Details")
                                .font(.playfair(size: 14, weight: .medium))
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppColors.purpleGradient)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.lightPurple, lineWidth: 1)
                    )
            )
            .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(item: Binding(
            get: { selectedIdeaId.map { IdeaDetailItem(id: $0) } },
            set: { selectedIdeaId = $0?.id }
        )) { item in
            IdeaDetailView(ideaId: item.id, viewModel: viewModel)
        }
    }
}

struct MemoryStatsView: View {
    let totalMemories: Int
    let thisMonthMemories: Int
    
    var body: some View {
        HStack(spacing: 20) {
            MemoryStatCardView(
                title: "Total",
                value: "\(totalMemories)",
                icon: "star.fill",
                color: AppColors.yellowAccent
            )
            
            MemoryStatCardView(
                title: "This Month",
                value: "\(thisMonthMemories)",
                icon: "calendar",
                color: AppColors.blueText
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

struct MemoryStatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.playfair(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.playfair(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    MemoriesView()
}
