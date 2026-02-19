import SwiftUI

struct HabitsListView: View {
    @EnvironmentObject var viewModel: HabitsViewModel
    @Binding var selectedTab: Int
    @State private var searchText = ""
    @State private var showingAddHabit = false
    @State private var showingFilters = false
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                AnimatedBubblesBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.filteredHabits.isEmpty {
                        emptyStateView
                    } else {
                        habitsList
                    }
                }
            }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView(selectedTab: $selectedTab)
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(selectedTab: $selectedTab)
                .environmentObject(viewModel)
        }
        .onChange(of: searchText) { newValue in
            viewModel.filter.searchText = newValue
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("My Habits")
                    .font(.ubuntu(size: 32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        selectedTab = 3
                    }
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accent)
                        .symbolRenderingMode(.hierarchical)
                }
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = 2
                }
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text("Add Habit")
                        .font(.ubuntu(size: 16, weight: .medium))
                }
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(AppColors.accentGradient)
                .cornerRadius(22)
                .shadow(color: AppColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.placeholderText)
                
                TextField("Search by name or category", text: $searchText)
                    .font(.ubuntu(size: 16))
                    .foregroundColor(AppColors.primaryText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.placeholderText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(Color.white)
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(AppColors.accentBlue.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
    
    private var habitsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredHabits) { habit in
                    NavigationLink(destination: HabitDetailView(habit: habit).environmentObject(viewModel)) {
                        HabitCardView(habit: habit)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentBlue.opacity(0.6))
            
            Text(viewModel.habits.isEmpty ? 
                 "Your journal is empty. Add your first habit to get started." :
                 "No habits match the selected parameters.")
                .font(.ubuntu(size: 18))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if viewModel.habits.isEmpty {
                Button(action: {
                    withAnimation {
                        selectedTab = 2
                    }
                }) {
                    Text("Add First Habit")
                        .font(.ubuntu(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 160, height: 44)
                        .background(AppColors.accentGradient)
                        .cornerRadius(22)
                        .shadow(color: AppColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 10)
            }
            
            Spacer()
        }
    }
}

struct HabitCardView: View {
    let habit: Habit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.ubuntu(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    HStack {
                        Text(habit.category.displayName)
                            .font(.ubuntu(size: 14, weight: .medium))
                            .foregroundColor(AppColors.accent)
                        
                        Text("•")
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(habit.time)
                            .font(.ubuntu(size: 14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            if !habit.description.isEmpty {
                Text(habit.description)
                    .font(.ubuntu(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(3)
            }
        }
        .padding(16)
        .cardStyle()
    }
}
