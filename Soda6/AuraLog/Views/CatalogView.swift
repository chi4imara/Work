import SwiftUI

struct CatalogView: View {
    @ObservedObject var store: PerfumeStore
    @State private var searchText = ""
    @State private var selectedSeason: Perfume.Season?
    @State private var selectedMood: Perfume.Mood?
    @State private var showingAddPerfume = false
    @State private var showingFilters = false
    
    var filteredPerfumes: [Perfume] {
        store.filteredPerfumes(searchText: searchText, selectedSeason: selectedSeason, selectedMood: selectedMood)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("My Fragrances")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(.primaryText)
                            
                            Spacer()
                            
                            Button(action: { showingAddPerfume = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.primaryYellow)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondaryText)
                            
                            TextField("Search fragrances...", text: $searchText)
                                .font(.ubuntu(16))
                                .foregroundColor(.primaryText)
                        }
                        .padding(12)
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        HStack {
                            Button(action: { showingFilters = true }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "line.3.horizontal.decrease.circle")
                                    Text("Filters")
                                    if selectedSeason != nil || selectedMood != nil {
                                        Circle()
                                            .fill(Color.primaryYellow)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.surfaceBackground)
                                .cornerRadius(20)
                            }
                            
                            Spacer()
                            
                            if !filteredPerfumes.isEmpty {
                                Text("\(filteredPerfumes.count) fragrances")
                                    .font(.ubuntu(14))
                                    .foregroundColor(.secondaryText)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 10)
                    
                    if store.perfumes.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundColor(.primaryYellow.opacity(0.6))
                            
                            VStack(spacing: 12) {
                                Text("Your fragrance collection is empty")
                                    .font(.ubuntu(20, weight: .medium))
                                    .foregroundColor(.primaryText)
                                    .multilineTextAlignment(.center)
                                
                                Text("Add your first perfume to start your catalog!")
                                    .font(.ubuntu(16))
                                    .foregroundColor(.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Button(action: { showingAddPerfume = true }) {
                                Text("Add Fragrance")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                    .frame(width: 200, height: 50)
                                    .background(AppGradients.yellowGradient)
                                    .cornerRadius(25)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                    } else if filteredPerfumes.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.primaryYellow.opacity(0.6))
                            
                            Text("No fragrances found")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(.primaryText)
                            
                            Text("Try adjusting your search or filters")
                                .font(.ubuntu(16))
                                .foregroundColor(.secondaryText)
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredPerfumes) { perfume in
                                    NavigationLink(destination: PerfumeDetailView(perfume: perfume, store: store)) {
                                        PerfumeCardView(perfume: perfume)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddPerfume) {
            AddPerfumeView(store: store)
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(selectedSeason: $selectedSeason, selectedMood: $selectedMood)
        }
    }
}

struct PerfumeCardView: View {
    let perfume: Perfume
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(perfume.name)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.primaryText)
                        .lineLimit(1)
                    
                    Text(perfume.brand)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Used \(perfume.usageCount) times")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(.primaryYellow)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.accentGreen)
                        Text(perfume.season.rawValue)
                            .font(.ubuntu(10))
                            .foregroundColor(.secondaryText)
                    }
                }
            }
            
            if !perfume.notes.isEmpty {
                Text("Notes: \(perfume.notes)")
                    .font(.ubuntu(14))
                    .foregroundColor(.secondaryText)
                    .lineLimit(2)
            }
            
            HStack {
                Text(perfume.mood.rawValue)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(.primaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.primaryPurple.opacity(0.3))
                    .cornerRadius(12)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondaryText)
            }
        }
        .padding(16)
        .background(AppGradients.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct FilterView: View {
    @Binding var selectedSeason: Perfume.Season?
    @Binding var selectedMood: Perfume.Mood?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Season")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(Perfume.Season.allCases, id: \.self) { season in
                                Button(action: {
                                    selectedSeason = selectedSeason == season ? nil : season
                                }) {
                                    Text(season.rawValue)
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(selectedSeason == season ? .primaryText : .secondaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(selectedSeason == season ? Color.primaryYellow : Color.surfaceBackground)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mood")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(Perfume.Mood.allCases, id: \.self) { mood in
                                Button(action: {
                                    selectedMood = selectedMood == mood ? nil : mood
                                }) {
                                    Text(mood.rawValue)
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(selectedMood == mood ? .primaryText : .secondaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(selectedMood == mood ? Color.primaryYellow : Color.surfaceBackground)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedSeason = nil
                        selectedMood = nil
                    }) {
                        Text("Clear All Filters")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.surfaceBackground)
                            .cornerRadius(25)
                    }
                }
                .padding(20)
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
