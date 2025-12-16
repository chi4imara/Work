import SwiftUI

struct BagDetailView: View {
    let bagId: UUID
    @ObservedObject var viewModel: BagViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var bag: Bag? {
        viewModel.bags.first { $0.id == bagId }
    }
    
    var body: some View {
        Group {
            if let currentBag = bag {
                NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.primaryYellow.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: "handbag.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(AppColors.primaryYellow)
                            }
                            
                            VStack(spacing: 8) {
                                Text(currentBag.name)
                                    .font(FontManager.ubuntu(.bold, size: 28))
                                    .foregroundColor(AppColors.primaryText)
                                    .multilineTextAlignment(.center)
                                
                                Text(currentBag.brand)
                                    .font(FontManager.ubuntu(.medium, size: 18))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 16) {
                            DetailCard(
                                icon: "tag.fill",
                                title: "Style",
                                value: currentBag.style.displayName,
                                color: AppColors.primaryPurple
                            )
                            
                            HStack(spacing: 16) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.primaryYellow.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "paintpalette.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(AppColors.primaryYellow)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Color")
                                        .font(FontManager.ubuntu(.medium, size: 14))
                                        .foregroundColor(AppColors.darkText)
                                    
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(ColorPalette.getColorSwatch(for: currentBag.color))
                                            .frame(width: 24, height: 24)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 2)
                                            )
                                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                                        
                                        Text(currentBag.color)
                                            .font(FontManager.ubuntu(.bold, size: 18))
                                            .foregroundColor(AppColors.darkText)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(20)
                            .cardStyle()
                            
                            DetailCard(
                                icon: "clock.fill",
                                title: "Usage Frequency",
                                value: currentBag.usageFrequency.displayName,
                                color: usageFrequencyColor(for: currentBag)
                            )
                            
                            DetailCard(
                                icon: "calendar",
                                title: "Added",
                                value: DateFormatter.shortDate.string(from: currentBag.dateCreated),
                                color: AppColors.primaryBlue
                            )
                            
                            if let lastUsed = currentBag.lastUsedDate {
                                DetailCard(
                                    icon: "clock.arrow.circlepath",
                                    title: "Last Used",
                                    value: DateFormatter.shortDate.string(from: lastUsed),
                                    color: AppColors.success
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "text.quote")
                                    .foregroundColor(AppColors.primaryYellow)
                                
                                Text("Comment")
                                    .font(FontManager.ubuntu(.bold, size: 18))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                            }
                            
                            Text(currentBag.comment.isEmpty ? "No comment added. You can add one later through editing." : currentBag.comment)
                                .font(FontManager.ubuntu(.regular, size: 16))
                                .foregroundColor(currentBag.comment.isEmpty ? Color.gray : AppColors.darkText)
                                .lineSpacing(4)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(AppColors.cardBackground.opacity(0.7))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                Button(action: {
                                    viewModel.toggleFavorite(currentBag)
                                }) {
                                    HStack {
                                        Image(systemName: currentBag.isFavorite ? "heart.fill" : "heart")
                                        Text(currentBag.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                    }
                                    .font(FontManager.ubuntu(.medium, size: 16))
                                    .foregroundColor(currentBag.isFavorite ? AppColors.error : AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(currentBag.isFavorite ? AppColors.error.opacity(0.1) : AppColors.buttonSecondary)
                                    .cornerRadius(25)
                                }
                                
                                Button(action: {
                                    viewModel.markAsUsed(currentBag)
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                        Text("Mark as Used")
                                    }
                                    .font(FontManager.ubuntu(.medium, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.success.opacity(0.2))
                                    .cornerRadius(25)
                                }
                            }
                            
                            Button("Edit Bag") {
                                showingEditView = true
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            
                            Button("Delete Bag") {
                                showingDeleteAlert = true
                            }
                            .buttonStyle(DestructiveButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Bag Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditView = true
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingEditView) {
            AddEditBagView(viewModel: viewModel, editingBag: currentBag)
        }
        .alert("Delete Bag", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteBag(currentBag)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete '\(currentBag.name)'? This action cannot be undone.")
        }
            } else {
                NavigationView {
                    ZStack {
                        BackgroundView()
                        VStack {
                            Text("Bag not found")
                                .font(FontManager.ubuntu(.bold, size: 20))
                                .foregroundColor(AppColors.primaryText)
                            Button("Close") {
                                dismiss()
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                    }
                    .navigationTitle("Error")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .foregroundColor(AppColors.primaryText)
                        }
                    }
                }
            }
        }
    }
    
    private func usageFrequencyColor(for bag: Bag) -> Color {
        switch bag.usageFrequency {
        case .often:
            return AppColors.success
        case .sometimes:
            return AppColors.warning
        case .rarely:
            return AppColors.error
        }
    }
}

struct DetailCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.ubuntu(.medium, size: 14))
                    .foregroundColor(AppColors.darkText.opacity(0.7))
                
                Text(value)
                    .font(FontManager.ubuntu(.bold, size: 16))
                    .foregroundColor(AppColors.darkText)
            }
            
            Spacer()
        }
        .padding(16)
        .cardStyle()
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(FontManager.ubuntu(.medium, size: 18))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppColors.error)
            .cornerRadius(28)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

