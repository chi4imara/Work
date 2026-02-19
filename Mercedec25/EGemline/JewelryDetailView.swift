import SwiftUI

struct JewelryDetailView: View {
    let jewelryId: UUID
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    
    private var jewelry: Jewelry? {
        appState.getJewelry(by: jewelryId)
    }
    
    var body: some View {
        Group {
            if let jewelry = jewelry {
                detailContent(jewelry: jewelry)
            } else {
                notFoundView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if jewelry != nil {
                    Menu {
                        Button(action: { showEditSheet = true }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive, action: { showDeleteAlert = true }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                    }
                }
            }
        }
        .alert("Delete Jewelry", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                appState.deleteJewelry(id: jewelryId)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this jewelry? This action cannot be undone.")
        }
        .sheet(isPresented: $showEditSheet) {
            if let jewelry = jewelry {
                AddEditJewelryView(jewelryId: jewelry.id, mode: .edit)
                    .environmentObject(appState)
            }
        }
    }
    
    private func detailContent(jewelry: Jewelry) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [ColorTheme.lightGray, ColorTheme.backgroundWhite]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 220)
                    .overlay(
                        VStack(spacing: 12) {
                            Image(systemName: jewelryCategoryIcon(jewelry.category))
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
                            Text(jewelry.name)
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    )
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(jewelry.brand)
                            .font(.playfairDisplay(20, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        Spacer()
                        Text("$\(Int(jewelry.price))")
                            .font(.playfairDisplay(22, weight: .bold))
                            .foregroundColor(ColorTheme.primaryYellow)
                    }
                    
                    DetailRow(title: "Category", value: jewelry.category.rawValue)
                    DetailRow(title: "Material", value: jewelry.material)
                    DetailRow(title: "Stones", value: jewelry.stones.isEmpty ? "None" : jewelry.stones)
                    DetailRow(title: "Style", value: jewelry.style.rawValue)
                    DetailRow(title: "Color", value: jewelry.color)
                    
                    if !jewelry.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryText)
                            Text(jewelry.notes)
                                .font(.playfairDisplay(14))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorTheme.backgroundWhite)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 8)
                )
                
                HStack(spacing: 12) {
                    Button(action: {
                        if appState.isInCollection(id: jewelryId) {
                            appState.removeFromCollection(id: jewelryId)
                        } else {
                            appState.addToCollection(id: jewelryId)
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: appState.isInCollection(id: jewelryId) ? "heart.fill" : "heart")
                            Text(appState.isInCollection(id: jewelryId) ? "In Collection" : "Add to Collection")
                                .font(.playfairDisplay(14, weight: .semibold))
                        }
                        .foregroundColor(appState.isInCollection(id: jewelryId) ? ColorTheme.softPink : ColorTheme.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(ColorTheme.primaryBlue.opacity(0.1))
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(ColorTheme.backgroundGradient)
    }
    
    private var notFoundView: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            Text("Jewelry not found")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            Button("Go Back") {
                dismiss()
            }
            .font(.playfairDisplay(16, weight: .medium))
            .foregroundColor(ColorTheme.primaryBlue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTheme.backgroundGradient)
    }
    
    private func jewelryCategoryIcon(_ category: JewelryCategory) -> String {
        switch category {
        case .rings: return "circle.dashed"
        case .earrings: return "oval.portrait"
        case .bracelets: return "link.circle"
        case .necklaces: return "oval.portrait.bottomhalf.filled"
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
            Spacer()
            Text(value)
                .font(.playfairDisplay(14, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
        }
    }
}

#Preview {
    NavigationStack {
        JewelryDetailView(jewelryId: UUID())
            .environmentObject(AppState())
    }
}
