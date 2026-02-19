import SwiftUI

struct HairstyleDetailView: View {
    let hairstyleId: UUID
    @EnvironmentObject var viewModel: HairstyleViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var hairstyle: Hairstyle? {
        viewModel.hairstyle(byId: hairstyleId)
    }
    
    var body: some View {
        Group {
            if let hairstyle = hairstyle {
                hairstyleContent(hairstyle)
            } else {
                notFoundView
            }
        }
        .navigationTitle(hairstyle?.name ?? "Hairstyle")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
    
    private func hairstyleContent(_ hairstyle: Hairstyle) -> some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .fill(AppColors.primaryWhite.opacity(0.2))
                        .frame(height: 220)
                        .overlay(
                            Group {
                                if let photoData = hairstyle.photo, let uiImage = UIImage(data: photoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 220)
                                        .clipped()
                                        .cornerRadius(AppDimensions.cornerRadius)
                                } else {
                                    VStack(spacing: 12) {
                                        Image(systemName: "scissors")
                                            .font(.system(size: 40))
                                            .foregroundColor(AppColors.primaryYellow)
                                        Text("No Photo")
                                            .font(AppFonts.body)
                                            .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                                    }
                                }
                            }
                        )
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(hairstyle.name)
                            .font(AppFonts.title)
                            .foregroundColor(AppColors.primaryWhite)
                        
                        detailRow(title: "Category", value: hairstyle.category.displayName)
                        detailRow(title: "Hair Length", value: hairstyle.hairLength.displayName)
                        detailRow(title: "Hair Color", value: hairstyle.hairColor)
                        detailRow(title: "Date", value: DateFormatter.shortDate.string(from: hairstyle.dateCreated))
                        
                        if !hairstyle.comment.isEmpty {
                            Text("Comment")
                                .font(AppFonts.subtitle)
                                .foregroundColor(AppColors.primaryWhite)
                            Text(hairstyle.comment)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryWhite.opacity(0.9))
                        }
                    }
                    .padding()
                    .background(AppColors.primaryWhite.opacity(0.1))
                    .cornerRadius(AppDimensions.cornerRadius)
                }
                .padding(.horizontal, AppDimensions.screenPadding)
            }
        }
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
            Spacer()
            Text(value)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryWhite)
        }
        .padding(.vertical, 4)
    }
    
    private var notFoundView: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 50))
                .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            Text("Hairstyle not found")
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        HairstyleDetailView(hairstyleId: UUID())
            .environmentObject(HairstyleViewModel())
    }
}
