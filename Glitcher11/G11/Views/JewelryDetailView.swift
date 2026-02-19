import SwiftUI

struct JewelryDetailView: View {
    let jewelry: Jewelry
    @ObservedObject var viewModel: JewelryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var currentJewelry: Jewelry? {
        viewModel.jewelries.first(where: { $0.id == jewelry.id })
    }
    
    var body: some View {
        Group {
            if let current = currentJewelry {
                detailContent(for: current)
            } else {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                    .onAppear {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
    
    private func detailContent(for jewelry: Jewelry) -> some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(jewelry.name)
                            .font(.playfairDisplay(24, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                InfoRow(title: "Style", value: jewelry.style)
                                InfoRow(title: "Type", value: jewelry.type.displayName)
                            }
                            
                            Spacer()
                            
                            if jewelry.isFavorite {
                                VStack {
                                    Image(systemName: "heart.fill")
                                        .font(.title2)
                                        .foregroundColor(ColorTheme.orange)
                                    
                                    Text("Favorite")
                                        .font(.playfairDisplay(12))
                                        .foregroundColor(ColorTheme.orange)
                                }
                            }
                        }
                        
                        Divider()
                            .background(ColorTheme.accent.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Text(jewelry.note.isEmpty ? "No note available" : jewelry.note)
                                .font(.playfairDisplay(16))
                                .foregroundColor(jewelry.note.isEmpty ? ColorTheme.secondaryText : ColorTheme.primaryText)
                                .italic(jewelry.note.isEmpty)
                        }
                    }
                    .padding(20)
                    .background(ColorTheme.cardGradient)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(ColorTheme.accent.opacity(0.2), lineWidth: 1)
                    )
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            viewModel.toggleFavorite(jewelry)
                        }) {
                            HStack {
                                Image(systemName: jewelry.isFavorite ? "heart.slash.fill" : "heart.fill")
                                Text(jewelry.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                            }
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                jewelry.isFavorite ? 
                                LinearGradient(colors: [ColorTheme.orange, ColorTheme.orange.opacity(0.8)], startPoint: .leading, endPoint: .trailing) :
                                ColorTheme.buttonGradient
                            )
                            .cornerRadius(16)
                        }
                        
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ColorTheme.cardGradient)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(ColorTheme.accent.opacity(0.5), lineWidth: 1)
                            )
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete")
                            }
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [ColorTheme.destructiveButton, ColorTheme.destructiveButton.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle(jewelry.name)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingEditView) {
            if let current = currentJewelry {
                EditJewelryView(jewelry: current)
            }
        }
        .alert("Delete Jewelry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteJewelry(jewelry)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this jewelry piece? This action cannot be undone.")
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title + ":")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text(value)
                .font(.playfairDisplay(16))
                .foregroundColor(ColorTheme.accentText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(ColorTheme.lightBlue.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

#Preview {
    NavigationView {
        JewelryDetailView(
            jewelry: Jewelry(name: "Sample Earrings", style: "Minimalism", type: .earrings, note: "Perfect for office wear"),
            viewModel: JewelryViewModel.shared
        )
    }
}
