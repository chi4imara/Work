import SwiftUI

struct ModificationDetailView: View {
    @EnvironmentObject var viewModel: ModificationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let modificationId: UUID
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var modification: Modification?
    
    var body: some View {
        Group {
            if let modification = modification {
                ZStack {
                    AnimatedBackground()
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            headerView
                            
                            contentView(modification: modification)
                            
                            actionButtons(modification: modification)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .navigationBarHidden(true)
                .sheet(isPresented: $showingEditView) {
                    EditModificationView(modification: modification)
                        .environmentObject(viewModel)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Delete Modification"),
                        message: Text("Are you sure you want to delete this modification? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            deleteModification(modification: modification)
                        },
                        secondaryButton: .cancel()
                    )
                }
            } else {
                ZStack {
                    AnimatedBackground()
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text("Modification not found")
                            .font(FontManager.title2)
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Button("Go Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.primaryWhite)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(AppColors.primaryDarkBlue)
                        )
                    }
                }
            }
        }
        .onAppear {
            modification = viewModel.getModification(by: modificationId)
        }
        .onChange(of: viewModel.modifications) { _ in
            modification = viewModel.getModification(by: modificationId)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryWhite)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(AppColors.primaryDarkBlue.opacity(0.8))
                    )
            }
            
            Spacer()
            
            Text("Modification Details")
                .font(FontManager.title2)
                .foregroundColor(AppColors.primaryWhite)
            
            Spacer()
            
            Button(action: {
                showingEditView = true
            }) {
                Image(systemName: "pencil")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryWhite)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(AppColors.primaryDarkBlue.opacity(0.8))
                    )
            }
        }
        .padding(.top, 10)
    }
    
    private func contentView(modification: Modification) -> some View {
        VStack(spacing: 20) {
            titleCard(modification: modification)
            
            detailsCard(modification: modification)
            
            if !modification.description.isEmpty {
                descriptionCard(modification: modification)
            }
        }
    }
    
    private func titleCard(modification: Modification) -> some View {
        VStack(spacing: 16) {
            Image(systemName: categoryIcon(for: modification.category))
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(AppColors.categoryColor(for: modification.category))
                .padding(20)
                .background(
                    Circle()
                        .fill(AppColors.categoryColor(for: modification.category).opacity(0.2))
                )
            
            Text(modification.name)
                .font(FontManager.title1)
                .foregroundColor(AppColors.cardText)
                .multilineTextAlignment(.center)
            
            Text(modification.category.displayName)
                .font(FontManager.subheadline)
                .foregroundColor(AppColors.categoryColor(for: modification.category))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.categoryColor(for: modification.category).opacity(0.2))
                )
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func detailsCard(modification: Modification) -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Status")
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.cardText.opacity(0.7))
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(AppColors.statusColor(for: modification.status))
                            .frame(width: 12, height: 12)
                        
                        Text(modification.status.displayName)
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.cardText)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Budget")
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.cardText.opacity(0.7))
                    
                    Text("$\(Int(modification.budget))")
                        .font(FontManager.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.cardText)
                }
            }
            
            Divider()
                .background(AppColors.cardText.opacity(0.2))
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Created")
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.cardText.opacity(0.7))
                    
                    Text(formatDate(modification.createdAt))
                        .font(FontManager.body)
                        .foregroundColor(AppColors.cardText)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private func descriptionCard(modification: Modification) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Description")
                .font(FontManager.headline)
                .foregroundColor(AppColors.cardText)
            
            Text(modification.description)
                .font(FontManager.body)
                .foregroundColor(AppColors.cardText.opacity(0.8))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private func actionButtons(modification: Modification) -> some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                    Text("Edit Modification")
                        .font(FontManager.headline)
                }
                .foregroundColor(AppColors.primaryWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.primaryDarkBlue)
                )
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                    Text("Delete Modification")
                        .font(FontManager.headline)
                }
                .foregroundColor(AppColors.primaryWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.accentRed)
                )
            }
        }
    }
    
    private func categoryIcon(for category: ModificationCategory) -> String {
        switch category {
        case .exterior:
            return "car.fill"
        case .technical:
            return "wrench.and.screwdriver.fill"
        case .interior:
            return "carseat.right.fill"
        case .electrical:
            return "bolt.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func deleteModification(modification: Modification) {
        viewModel.deleteModification(modification)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let viewModel = ModificationViewModel()
    let modification = Modification(
        name: "Install Sport Exhaust",
        category: .technical,
        budget: 600,
        status: .plan,
        description: "Install a high-performance exhaust system to improve sound and performance."
    )
    viewModel.addModification(modification)
    return ModificationDetailView(modificationId: modification.id)
        .environmentObject(viewModel)
}
