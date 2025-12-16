import SwiftUI

struct PerfumeDetailView: View {
    let perfume: Perfume
    @ObservedObject var store: PerfumeStore
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Text(perfume.name)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text(perfume.brand)
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.secondaryText)
                        }
                        
                        VStack(spacing: 12) {
                            Text("Used \(perfume.usageCount) times")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(.primaryYellow)
                            
                            Button(action: {
                                store.incrementUsage(for: perfume)
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Mark as Used")
                                }
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(.primaryText)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(AppGradients.yellowGradient)
                                .cornerRadius(20)
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(AppGradients.cardGradient)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    
                    VStack(spacing: 16) {
                        DetailSectionView(
                            title: "Notes",
                            content: perfume.notes.isEmpty ? "No notes specified" : perfume.notes,
                            icon: "leaf.fill"
                        )
                        
                        HStack(spacing: 16) {
                            DetailSectionView(
                                title: "Season",
                                content: perfume.season.rawValue,
                                icon: "calendar"
                            )
                            
                            DetailSectionView(
                                title: "Mood",
                                content: perfume.mood.rawValue,
                                icon: "heart.fill"
                            )
                        }
                        
                        DetailSectionView(
                            title: "Favorite Combinations",
                            content: perfume.favoriteCombinations.isEmpty ? "No combinations specified" : perfume.favoriteCombinations,
                            icon: "sparkles"
                        )
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "pencil")
                                Text("Edit Fragrance")
                            }
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.surfaceBackground)
                            .cornerRadius(25)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "trash")
                                Text("Delete Fragrance")
                            }
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.accentPink)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.surfaceBackground)
                            .cornerRadius(25)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Fragrance Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditPerfumeView(perfume: perfume, store: store)
        }
        .alert("Delete Fragrance", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                store.deletePerfume(perfume)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \"\(perfume.name)\"? This action cannot be undone.")
        }
    }
}

struct DetailSectionView: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.primaryYellow)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.primaryText)
            }
            
            Text(content)
                .font(.ubuntu(15))
                .foregroundColor(.secondaryText)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(AppGradients.cardGradient)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct EditPerfumeView: View {
    let perfume: Perfume
    @ObservedObject var store: PerfumeStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var brand: String
    @State private var notes: String
    @State private var selectedSeason: Perfume.Season
    @State private var selectedMood: Perfume.Mood
    @State private var favoriteCombinations: String
    
    init(perfume: Perfume, store: PerfumeStore) {
        self.perfume = perfume
        self.store = store
        self._name = State(initialValue: perfume.name)
        self._brand = State(initialValue: perfume.brand)
        self._notes = State(initialValue: perfume.notes)
        self._selectedSeason = State(initialValue: perfume.season)
        self._selectedMood = State(initialValue: perfume.mood)
        self._favoriteCombinations = State(initialValue: perfume.favoriteCombinations)
    }
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Fragrance Name *")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                TextField("Enter fragrance name", text: $name)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.primaryText)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Brand *")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                TextField("Enter brand name", text: $brand)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.primaryText)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                TextField("e.g., vanilla, jasmine, patchouli", text: $notes, axis: .vertical)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.primaryText)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .lineLimit(3...6)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Season")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                Menu {
                                    ForEach(Perfume.Season.allCases, id: \.self) { season in
                                        Button(season.rawValue) {
                                            selectedSeason = season
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedSeason.rawValue)
                                            .font(.ubuntu(16))
                                            .foregroundColor(.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondaryText)
                                    }
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mood")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                Menu {
                                    ForEach(Perfume.Mood.allCases, id: \.self) { mood in
                                        Button(mood.rawValue) {
                                            selectedMood = mood
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedMood.rawValue)
                                            .font(.ubuntu(16))
                                            .foregroundColor(.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondaryText)
                                    }
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Favorite Combinations")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                TextField("e.g., pairs well with warm vanilla scents", text: $favoriteCombinations, axis: .vertical)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.primaryText)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .lineLimit(2...4)
                            }
                        }
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(canSave ? .primaryText : .secondaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(canSave ? AnyShapeStyle(AppGradients.yellowGradient) : AnyShapeStyle(Color.surfaceBackground))
                                .cornerRadius(25)
                        }
                        .disabled(!canSave)
                        .padding(.top, 10)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Fragrance")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func saveChanges() {
        var updatedPerfume = perfume
        updatedPerfume.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedPerfume.brand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedPerfume.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedPerfume.season = selectedSeason
        updatedPerfume.mood = selectedMood
        updatedPerfume.favoriteCombinations = favoriteCombinations.trimmingCharacters(in: .whitespacesAndNewlines)
        
        store.updatePerfume(updatedPerfume)
        presentationMode.wrappedValue.dismiss()
    }
}
