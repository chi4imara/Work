import SwiftUI

struct MyOutfitsView: View {
    @ObservedObject var viewModel: OutfitViewModel
    @State private var showingAddOutfit = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchBar
                    
                    if viewModel.filteredOutfits.isEmpty {
                        emptyStateView
                    } else {
                        listView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddOutfit) {
            AddOutfitView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Outfits")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddOutfit = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(ColorManager.accentYellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorManager.secondaryText)
            
            TextField("Search outfits, tags, or notes...", text: $viewModel.searchText)
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.primaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(ColorManager.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 15)
        .padding(.bottom, 10)
    }
    
    private var viewToggle: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.showingCalendarView = false
                }
            } label: {
                Text("List")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(viewModel.showingCalendarView ? ColorManager.secondaryText : .white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(viewModel.showingCalendarView ? Color.clear : ColorManager.primaryText)
                    .cornerRadius(20)
            }
                    
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.showingCalendarView = true
                }
            } label: {
                Text("Calendar")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(!viewModel.showingCalendarView ? ColorManager.secondaryText : .white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(!viewModel.showingCalendarView ? Color.clear : ColorManager.primaryText)
                    .cornerRadius(20)
            }
        }
        .padding(4)
        .background(ColorManager.cardBackground)
        .cornerRadius(24)
        .padding(.horizontal, 20)
        .padding(.top, 15)
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tshirt")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorManager.secondaryText)
            
            Text("No outfits yet")
                .font(.playfairDisplay(24, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            Text("You don't have any added outfits yet. Tap + to add your first day.")
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                showingAddOutfit = true
            } label: {
                Text("Add New Day")
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(ColorManager.purpleGradient)
                    .cornerRadius(25)
                    .shadow(color: ColorManager.purpleDark.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            
            Spacer()
        }
    }
    
    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredOutfits) { outfit in
                    NavigationLink(destination: OutfitDetailView(outfitId: outfit.id, viewModel: viewModel)) {
                        OutfitCardView(outfit: outfit)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 10)
        }
    }
    
    private var calendarView: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Calendar View")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.top, 20)
                
                Text("Calendar implementation coming soon...")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.secondaryText)
                
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredOutfits) { outfit in
                        NavigationLink(destination: OutfitDetailView(outfitId: outfit.id, viewModel: viewModel)) {
                            OutfitCardView(outfit: outfit)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct OutfitCardView: View {
    let outfit: OutfitEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(outfit.dateString)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: outfit.mood.icon)
                        .foregroundColor(outfit.mood.color)
                    Text(outfit.mood.rawValue)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(outfit.mood.color)
                }
            }
            
            Text(outfit.shortDescription)
                .font(.playfairDisplay(15))
                .foregroundColor(ColorManager.primaryText)
                .lineLimit(2)
            
            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    Text("Comfort:")
                        .font(.playfairDisplay(13, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                    Text("\(outfit.comfort)/10")
                        .font(.playfairDisplay(13, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                }
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(outfit.reaction.color)
                        .frame(width: 8, height: 8)
                    Text(outfit.reaction.rawValue)
                        .font(.playfairDisplay(13, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            if !outfit.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(outfit.tags.prefix(3), id: \.self) { tag in
                            Text(tag)
                                .font(.playfairDisplay(12, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(ColorManager.accentYellow.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        if outfit.tags.count > 3 {
                            Text("+\(outfit.tags.count - 3)")
                                .font(.playfairDisplay(12, weight: .medium))
                                .foregroundColor(ColorManager.secondaryText)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(ColorManager.neutralGray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, -16)
            }
        }
        .padding(16)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorManager.purpleDark.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    MyOutfitsView(viewModel: OutfitViewModel())
}

