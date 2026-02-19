import SwiftUI

struct LookDetailView: View {
    let lookId: UUID
    @EnvironmentObject var viewModel: HairstyleViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var look: Look? {
        viewModel.look(byId: lookId)
    }
    
    var body: some View {
        Group {
            if let look = look {
                lookContent(look)
            } else {
                notFoundView
            }
        }
        .navigationTitle(look?.name ?? "Look")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
    
    private func lookContent(_ look: Look) -> some View {
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
                                if let photoData = look.photo, let uiImage = UIImage(data: photoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 220)
                                        .clipped()
                                        .cornerRadius(AppDimensions.cornerRadius)
                                } else {
                                    VStack(spacing: 12) {
                                        Image(systemName: "photo")
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
                        HStack {
                            Text(look.name)
                                .font(AppFonts.title)
                                .foregroundColor(AppColors.primaryWhite)
                            
                            Spacer()
                            
                            if look.isFavorite {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.accentPink)
                            }
                        }
                        
                        Text(DateFormatter.shortDate.string(from: look.dateCreated))
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                        
                        if !look.hairstyles.isEmpty {
                            Text("Hairstyles (\(look.hairstyles.count))")
                                .font(AppFonts.subtitle)
                                .foregroundColor(AppColors.primaryWhite)
                            
                            ForEach(look.hairstyles) { hairstyle in
                                HStack(spacing: 12) {
                                    Image(systemName: "scissors")
                                        .foregroundColor(AppColors.primaryYellow)
                                    Text(hairstyle.name)
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.primaryWhite)
                                    Spacer()
                                    Text(hairstyle.category.displayName)
                                        .font(AppFonts.caption)
                                        .foregroundColor(AppColors.primaryYellow)
                                }
                                .padding(12)
                                .background(AppColors.primaryWhite.opacity(0.1))
                                .cornerRadius(AppDimensions.smallCornerRadius)
                            }
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
    
    private var notFoundView: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 50))
                .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            Text("Look not found")
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        LookDetailView(lookId: UUID())
            .environmentObject(HairstyleViewModel())
    }
}
