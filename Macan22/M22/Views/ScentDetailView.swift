import SwiftUI

struct ScentDetailView: View {
    let scent: Scent
    @ObservedObject var viewModel: ScentViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AppBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    scentInfoCard
                    
                    actionButtons
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            EditScentView(scent: scent, viewModel: viewModel)
        }
        .alert("Delete Scent", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteScent(scent)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete '\(scent.name)'? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.white)
            }
            
            Spacer()
            
            Text("Scent Details")
                .font(.playfairDisplay(.bold, size: 20))
                .foregroundColor(AppColors.white)
            
            Spacer()
            
            Button(action: {
                showingEditView = true
            }) {
                Image(systemName: "pencil")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.yellow)
            }
        }
    }
    
    private var scentInfoCard: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(scent.name)
                        .font(.playfairDisplay(.bold, size: 24))
                        .foregroundColor(AppColors.white)
                        .multilineTextAlignment(.leading)
                    
                    if !scent.brand.isEmpty {
                        Text(scent.brand)
                            .font(.playfairDisplay(.semiBold, size: 16))
                            .foregroundColor(AppColors.yellow)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(AppColors.yellowGradient)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: scent.season.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.white)
                    }
                    
                    Text(scent.season.displayName)
                        .font(.playfairDisplay(.medium, size: 12))
                        .foregroundColor(AppColors.white.opacity(0.8))
                }
            }
            .padding(20)
            .background(AppColors.cardGradient)
            
            VStack(spacing: 0) {
                if !scent.description.isEmpty {
                    DetailRow(
                        title: "Description",
                        content: scent.description,
                        icon: "text.quote"
                    )
                }
                
                if !scent.comment.isEmpty {
                    DetailRow(
                        title: "Comment",
                        content: scent.comment,
                        icon: "bubble.left"
                    )
                }
                
                DetailRow(
                    title: "Added",
                    content: DateFormatter.displayFormatter.string(from: scent.dateAdded),
                    icon: "calendar"
                )
            }
        }
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.deepBlue.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Edit Scent")
                        .font(.playfairDisplay(.semiBold, size: 18))
                }
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppColors.buttonGradient)
                .cornerRadius(28)
                .shadow(color: AppColors.yellow.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Delete Scent")
                        .font(.playfairDisplay(.semiBold, size: 16))
                }
                .foregroundColor(AppColors.error)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(AppColors.cardGradient)
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(AppColors.error.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(AppColors.white.opacity(0.1))
            
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.yellow)
                    .frame(width: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(.semiBold, size: 14))
                        .foregroundColor(AppColors.white.opacity(0.8))
                    
                    Text(content)
                        .font(.playfairDisplay(.regular, size: 16))
                        .foregroundColor(AppColors.white)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding(20)
        }
    }
}

extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    NavigationView {
        ScentDetailView(
            scent: Scent(
                name: "Vanilla Dream",
                brand: "Yankee Candle",
                description: "Warm vanilla with sugar notes",
                season: .winter,
                comment: "Perfect for cozy evenings"
            ),
            viewModel: ScentViewModel()
        )
    }
}
