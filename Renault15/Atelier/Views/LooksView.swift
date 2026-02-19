import SwiftUI

struct LooksView: View {
    @EnvironmentObject var viewModel: HairstyleViewModel
    @State private var showingNewLook = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Looks")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                    
                    Button(action: {
                        showingNewLook = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.primaryYellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        
                        if viewModel.looks.isEmpty {
                            emptyStateSection
                        } else {
                            looksGridSection
                        }
                    }
                    .padding(.horizontal, AppDimensions.screenPadding)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(isPresented: $showingNewLook) {
            NewLookView(viewModel: viewModel)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Your Style Collection")
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.primaryWhite)
                Spacer()
            }
            
            Text("Manage and explore your created looks")
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
        }
    }
    
    private var looksGridSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(viewModel.looks) { look in
                NavigationLink(destination: LookDetailView(lookId: look.id).environmentObject(viewModel)) {
                    LookCard(look: look)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryYellow.opacity(0.7))
            
            VStack(spacing: 12) {
                Text("Create Your First Look")
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("Create your first look and experiment with hair style")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Button {
                showingNewLook = true
            } label: {
                Text("Add Look")
                    .font(AppFonts.button)
                    .foregroundColor(AppColors.darkBlue)
                    .frame(width: 200, height: AppDimensions.buttonHeight)
                    .background(AppColors.primaryYellow)
                    .cornerRadius(AppDimensions.cornerRadius)
            }
            
            Spacer()
        }
    }
}

struct LookCard: View {
    let look: Look
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.primaryWhite.opacity(0.2))
                .frame(height: 120)
                .overlay(
                    Group {
                        if let photoData = look.photo, let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 120)
                                .clipped()
                                .cornerRadius(AppDimensions.cornerRadius)
                        } else {
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.primaryYellow)
                                Text("No Photo")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                            }
                        }
                    }
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(look.name)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryWhite)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if look.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.accentPink)
                    }
                }
                
                Text(DateFormatter.shortDate.string(from: look.dateCreated))
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.6))
                
                if !look.hairstyles.isEmpty {
                    Text("\(look.hairstyles.count) hairstyle\(look.hairstyles.count == 1 ? "" : "s")")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(AppColors.primaryWhite.opacity(0.1))
        .cornerRadius(AppDimensions.cornerRadius)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    LooksView()
        .environmentObject(HairstyleViewModel())
}
