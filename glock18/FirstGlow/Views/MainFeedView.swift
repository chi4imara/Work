import SwiftUI

struct MainFeedView: View {
    @ObservedObject var store: FirstExperienceStore
    @State private var showingAddExperience = false
    @State private var showingFilters = false
    @State private var selectedExperience: FirstExperience?
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if experiencesToShow.isEmpty {
                    emptyStateView
                } else {
                    experiencesList
                }
            }
        }
        .sheet(isPresented: $showingAddExperience) {
            AddEditExperienceView(store: store)
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(store: store)
        }
        .sheet(item: $selectedExperience) { experience in
            ExperienceDetailView(experienceId: experience.id, store: store)
        }
    }
    
    private var experiencesToShow: [FirstExperience] {
        store.isFiltered ? store.filteredExperiences : store.experiences
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My First Times")
                        .font(FontManager.largeTitle)
                        .foregroundColor(AppColors.pureWhite)
                    
                    if store.isFiltered {
                        Text("Filtered Results")
                            .font(FontManager.caption1)
                            .foregroundColor(AppColors.pureWhite.opacity(0.7))
                    }
                }
                
                Spacer()
                
                Menu {
                    Button("Filter...") {
                        showingFilters = true
                    }
                    
                    if store.isFiltered {
                        Button("Reset Filters") {
                            store.resetFilters()
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.pureWhite)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(AppColors.pureWhite.opacity(0.1))
                        )
                }
            }
            
            Button(action: {
                showingAddExperience = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("New First Time")
                        .font(FontManager.buttonText)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var experiencesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(experiencesToShow) { experience in
                    ExperienceCardView(experience: experience,
                                       onTap: { selectedExperience = experience },
                                       onDelete: { store.deleteExperience(experience) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.pureWhite.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "airplane")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.pureWhite.opacity(0.7))
            }
            
            VStack(spacing: 12) {
                Text(store.isFiltered ? "No Results Found" : "Add Your First First Time!")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.pureWhite)
                
                Text(store.isFiltered ? 
                     "No experiences match your current filters" : 
                        "Start capturing your memorable first experiences")
                .font(FontManager.body)
                .foregroundColor(AppColors.pureWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if store.isFiltered {
                    store.resetFilters()
                } else {
                    showingAddExperience = true
                }
            }) {
                Text(store.isFiltered ? "Reset Filters" : "Add Experience")
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct ExperienceCardView: View {
    let experience: FirstExperience
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(experience.title)
                        .font(FontManager.cardTitle)
                        .foregroundColor(AppColors.darkGray)
                        .multilineTextAlignment(.leading)
                    
                    if let category = experience.category {
                        Text("Category: \(category)")
                            .font(FontManager.cardSubtitle)
                            .foregroundColor(AppColors.mediumGray)
                    }
                    
                    if let note = experience.note, !note.isEmpty {
                        Text(note)
                            .font(FontManager.caption1)
                            .foregroundColor(AppColors.mediumGray)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(experience.date, style: .date)
                        .font(FontManager.caption1)
                        .foregroundColor(AppColors.mediumGray)
                    
                    if let place = experience.place, !place.isEmpty {
                        Text(place)
                            .font(FontManager.caption2)
                            .foregroundColor(AppColors.mediumGray.opacity(0.8))
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .padding(16)
        }
        .cardBackground()
        .offset(x: dragOffset.width)
        .background(
            HStack {
                Button {
                    showingDeleteConfirmation = true
                } label: {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            Text("Delete")
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red)
                    .cornerRadius(16)
                }
            }
            .opacity(dragOffset.width < -50 ? 1 : 0)
        )
        .highPriorityGesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    if value.translation.width < 0 {
                        dragOffset = value.translation
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if value.translation.width < -100 {
                            dragOffset = CGSize(width: -80, height: 0)
                        } else {
                            dragOffset = .zero
                        }
                    }
                }
        )
        .alert("Delete Experience", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                withAnimation(.spring()) {
                    dragOffset = .zero
                }
            }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this experience? This action cannot be undone.")
        }
    }
}

extension View {
    func onDelete(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeleteModifier(action: action))
    }
}

struct DeleteModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
    }
}

#Preview {
    MainFeedView(store: FirstExperienceStore())
}
