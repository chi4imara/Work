import SwiftUI

struct ArchiveView: View {
    @ObservedObject var fragranceViewModel: FragranceViewModel
    @State private var showingAddFragrance = false
    @State private var selectedFragranceId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Fragrance Archive")
                            .font(.lumierepolis(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: { showingAddFragrance = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(AppColors.primaryWhite)
                                .frame(width: 44, height: 44)
                                .background(AppColors.buttonPrimary)
                                .clipShape(Circle())
                        }
                    }
                    
                    SearchBar(text: $fragranceViewModel.searchText) { text in
                        fragranceViewModel.updateSearch(text)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if fragranceViewModel.filteredFragrances.isEmpty {
                    EmptyStateView {
                        showingAddFragrance = true
                    }
                } else {
                    FragranceListView(
                        fragrances: fragranceViewModel.filteredFragrances
                    ) { fragranceId in
                        selectedFragranceId = fragranceId
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddFragrance) {
            AddFragranceView(fragranceViewModel: fragranceViewModel)
        }
        .sheet(item: Binding(
            get: { selectedFragranceId },
            set: { selectedFragranceId = $0 }
        )) { id in
            FragranceDetailView(
                fragranceId: id,
                fragranceViewModel: fragranceViewModel
            )
        }
    }
}

struct EmptyStateView: View {
    let onAddFragrance: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "archivebox")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 12) {
                Text("Archive is empty")
                    .font(.lumierepolis(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first fragrance to get started.")
                    .font(.lumierepolis(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onAddFragrance) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Fragrance")
                }
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(AppColors.primaryWhite)
                .frame(height: 50)
                .frame(maxWidth: 200)
                .background(AppColors.buttonPrimary)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct FragranceListView: View {
    let fragrances: [Fragrance]
    let onFragranceTap: (UUID) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(fragrances) { fragrance in
                    FragranceCard(fragrance: fragrance) {
                        onFragranceTap(fragrance.id)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100) 
        }
    }
}

struct FragranceCard: View {
    let fragrance: Fragrance
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(fragrance.name)
                        .font(.lumierepolis(18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text(fragrance.format.displayName)
                        .font(.lumierepolis(12, weight: .bold))
                        .foregroundColor(AppColors.primaryWhite)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(AppColors.buttonPrimary)
                        .cornerRadius(12)
                }
                
                HStack {
                    Text(fragrance.season.displayName)
                        .font(.lumierepolis(14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                }
                
                if !fragrance.displayNotes.isEmpty {
                    Text(fragrance.displayNotes)
                        .font(.lumierepolis(14))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SearchBar: View {
    @Binding var text: String
    let onSearchTextChanged: (String) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.placeholderText)
            
            TextField("Search fragrances...", text: $text)
                .font(.lumierepolis(16))
                .foregroundColor(AppColors.primaryText)
                .onChange(of: text) { newValue in
                    onSearchTextChanged(newValue)
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

#Preview {
    ArchiveView(fragranceViewModel: FragranceViewModel())
}
