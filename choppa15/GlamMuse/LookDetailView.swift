import SwiftUI

struct LookDetailView: View {
    let lookId: UUID
    @ObservedObject var viewModel: MakeupLooksViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var look: MakeupLook? {
        viewModel.getLook(by: lookId)
    }
    
    var body: some View {
        Group {
            if let look = look {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                headerView(look: look)
                                
                                VStack(spacing: 20) {
                                    DetailSection(title: "Category") {
                                        HStack(spacing: 8) {
                                            Image(systemName: look.category.icon)
                                                .font(.system(size: 16))
                                            Text(look.category.rawValue)
                                                .font(.ubuntu(16, weight: .medium))
                                        }
                                        .foregroundColor(AppColors.accent)
                                    }
                                    
                                    if !look.mainShades.isEmpty {
                                        DetailSection(title: "Main Shades") {
                                            Text(look.mainShades.joined(separator: ", "))
                                                .font(.ubuntu(16))
                                                .foregroundColor(AppColors.darkText)
                                        }
                                    } else {
                                        DetailSection(title: "Main Shades") {
                                            emptyStateText
                                        }
                                    }
                                    
                                    if !look.applicationSteps.isEmpty {
                                        DetailSection(title: "Application Steps") {
                                            Text(look.applicationSteps)
                                                .font(.ubuntu(16))
                                                .foregroundColor(AppColors.darkText)
                                                .lineSpacing(2)
                                        }
                                    } else {
                                        DetailSection(title: "Application Steps") {
                                            emptyStateText
                                        }
                                    }
                                    
                                    if !look.products.isEmpty {
                                        DetailSection(title: "Products Used") {
                                            Text(look.products.joined(separator: ", "))
                                                .font(.ubuntu(16))
                                                .foregroundColor(AppColors.darkText)
                                                .lineSpacing(2)
                                        }
                                    } else {
                                        DetailSection(title: "Products Used") {
                                            emptyStateText
                                        }
                                    }
                                    
                                    if !look.result.isEmpty {
                                        DetailSection(title: "Final Result") {
                                            Text(look.result)
                                                .font(.ubuntu(16))
                                                .foregroundColor(AppColors.darkText)
                                                .lineSpacing(2)
                                        }
                                    } else {
                                        DetailSection(title: "Final Result") {
                                            emptyStateText
                                        }
                                    }
                                }
                                
                                actionButtonsView(look: look)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                        }
                    }
                    .navigationTitle(look.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .foregroundColor(AppColors.primaryText)
                        }
                    }
                    .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showingEditView) {
                    CreateEditLookView(viewModel: viewModel, lookToEdit: look)
                }
                .alert("Delete Look", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteLook(look)
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this makeup look? This action cannot be undone.")
                }
            } else {
                Color.clear
                    .onAppear {
                        dismiss()
                    }
            }
        }
    }
    
    private func headerView(look: MakeupLook) -> some View {
        VStack(spacing: 12) {
            Text(look.name)
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Created on \(DateFormatter.longDate.string(from: look.dateCreated))")
                .font(.ubuntu(14))
                .foregroundColor(AppColors.secondaryText)
        }
    }
    
    private var emptyStateText: some View {
        Text("Information not specified. Can be added later through editing.")
            .font(.ubuntu(14))
            .foregroundColor(AppColors.darkText.opacity(0.6))
            .italic()
    }
    
    private func actionButtonsView(look: MakeupLook) -> some View {
        VStack(spacing: 12) {
            Button(action: { showingEditView = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                    Text("Edit Look")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                    Text("Delete Look")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.error)
                .cornerRadius(12)
            }
        }
        .padding(.top, 20)
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            VStack(alignment: .leading, spacing: 8) {
                content
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

#Preview {
    let viewModel = MakeupLooksViewModel()
    let previewLook = MakeupLook(
        name: "Pink Morning",
        category: .daily,
        mainShades: ["pink", "champagne", "beige"],
        applicationSteps: "1. Foundation - light coverage\n2. Warm blush\n3. Lip gloss",
        products: ["NARS Orgasm Blush", "Dior Lip Glow"],
        result: "Fresh, glowing look with emphasis on skin"
    )
    viewModel.addLook(previewLook)
    return LookDetailView(lookId: previewLook.id, viewModel: viewModel)
}
