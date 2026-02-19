import SwiftUI

struct BreakfastDetailView: View {
    @EnvironmentObject var viewModel: BreakfastViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let breakfast: Breakfast
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    detailsCard
                    
                    actionButtons
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            EditBreakfastView(breakfast: breakfast)
                .environmentObject(viewModel)
        }
        .alert("Delete Breakfast", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteBreakfast()
            }
        } message: {
            Text("Are you sure you want to delete this breakfast? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(12)
                    .background(AppColors.backgroundWhite.opacity(0.9))
                    .clipShape(Circle())
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            
            Spacer()
            
            Text("Breakfast Details")
                .font(.playfairDisplay(size: 24, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
            
            Color.clear
                .frame(width: 42, height: 42)
        }
        .padding(.top, 10)
    }
    
    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text(breakfast.name)
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryBlue)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(breakfast.category.displayName)
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppColors.primaryYellow.opacity(0.2))
                        .cornerRadius(20)
                    
                    Spacer()
                    
                    Text(formatDate(breakfast.dateCreated))
                        .font(.playfairDisplay(size: 14))
                        .foregroundColor(AppColors.textGray.opacity(0.7))
                }
            }
            
            Divider()
                .background(AppColors.primaryBlue.opacity(0.2))
            
            if !breakfast.dishes.isEmpty {
                DetailRow(
                    icon: "fork.knife",
                    title: "Dishes",
                    content: breakfast.dishes,
                    iconColor: AppColors.accentGreen
                )
            }
            
            if !breakfast.drink.isEmpty {
                DetailRow(
                    icon: "cup.and.saucer.fill",
                    title: "Drink",
                    content: breakfast.drink,
                    iconColor: AppColors.accentOrange
                )
            }
            
            if !breakfast.atmosphereDescription.isEmpty {
                DetailRow(
                    icon: "sparkles",
                    title: "Atmosphere",
                    content: breakfast.atmosphereDescription,
                    iconColor: AppColors.primaryYellow
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.backgroundWhite.opacity(0.95))
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 15, x: 0, y: 8)
        )
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Edit")
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                }
                .foregroundColor(AppColors.backgroundWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.darkBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: AppColors.primaryBlue.opacity(0.4), radius: 10, x: 0, y: 5)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Delete")
                        .font(.playfairDisplay(size: 16, weight: .medium))
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColors.backgroundWhite.opacity(0.9))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
    }
    
    private func deleteBreakfast() {
        viewModel.deleteBreakfast(breakfast)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let content: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            Text(content)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(AppColors.textGray)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
    }
}

#Preview {
    let sampleBreakfast = Breakfast(
        name: "French Morning Set",
        category: .weekend,
        dishes: "Croissant, jam, omelet",
        drink: "Cappuccino",
        atmosphereDescription: "White dishes, sunny window, fresh flowers"
    )
    
    return BreakfastDetailView(breakfast: sampleBreakfast)
        .environmentObject(BreakfastViewModel())
}
