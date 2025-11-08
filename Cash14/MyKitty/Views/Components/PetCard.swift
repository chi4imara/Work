import SwiftUI

struct PetCard: View {
    let pet: Pet
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onArchive: () -> Void
    let onEdit: () -> Void
    
    @State private var offset = CGSize.zero
    @State private var showingArchiveAlert = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.error)
                .overlay(
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "archivebox.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            Text("Archive")
                                .font(FontManager.small)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 20)
                    }
                )
                .opacity(offset.width < -50 ? 1 : 0)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.95),
                            Color.white.opacity(0.85)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected ? AppColors.primaryBlue : Color.clear,
                            lineWidth: isSelected ? 3 : 0
                        )
                )
                .shadow(
                    color: AppColors.cardShadow.opacity(isSelected ? 0.3 : 0.1),
                    radius: isSelected ? 8 : 4,
                    x: 0,
                    y: 2
                )
                .overlay(
                    HStack(spacing: 16) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppColors.primaryBlue.opacity(0.8),
                                        AppColors.accentPurple.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(String(pet.name.prefix(1)).uppercased())
                                    .font(FontManager.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                            .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 4, x: 0, y: 2)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(pet.name)
                                    .font(FontManager.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColors.primaryText)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Image(systemName: genderIcon)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(genderColor)
                                    .padding(4)
                                    .background(genderColor.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            
                            Text(pet.speciesBreed)
                                .font(FontManager.body)
                                .foregroundColor(AppColors.secondaryText)
                                .lineLimit(1)
                            
                            HStack {
                                Text("Born: \(formattedBirthDate)")
                                    .font(FontManager.small)
                                    .foregroundColor(AppColors.secondaryText)
                                
                                Spacer()
                                
                                Text(pet.age)
                                    .font(FontManager.small)
                                    .fontWeight(.medium)
                                    .foregroundColor(AppColors.primaryBlue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(AppColors.primaryBlue.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        
                        Spacer()
                        
                        if !isSelectionMode {
                            VStack(spacing: 8) {
                                Button(action: onEdit) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppColors.primaryBlue)
                                        .frame(width: 32, height: 32)
                                        .background(AppColors.primaryBlue.opacity(0.1))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    showingArchiveAlert = true
                                }) {
                                    Image(systemName: "archivebox")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppColors.error)
                                        .frame(width: 32, height: 32)
                                        .background(AppColors.error.opacity(0.1))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        } else {
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                        }
                    }
                    .padding(16)
                )
        }
        .frame(height: 100)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .alert("Archive Pet", isPresented: $showingArchiveAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                onArchive()
            }
        } message: {
            Text("Are you sure you want to archive \(pet.name)?")
        }
    }
    
    private var genderIcon: String {
        switch pet.gender {
        case .male:
            return "figure"
        case .female:
            return "figure.dress.line.vertical.figure"
        case .unknown:
            return "questionmark.circle"
        }
    }
    
    private var genderColor: Color {
        switch pet.gender {
        case .male:
            return AppColors.primaryBlue
        case .female:
            return AppColors.softPink
        case .unknown:
            return AppColors.secondaryText
        }
    }
    
    private var formattedBirthDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: pet.birthDate)
    }
}

struct PetCard_Previews: PreviewProvider {
    static var previews: some View {
        let samplePet = Pet(
            name: "Fluffy",
            species: "Cat",
            breed: "Persian",
            gender: .female,
            birthDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date(),
            adoptionDate: nil,
            weight: 4.5,
            identification: nil,
            color: "White",
            allergies: nil,
            notes: "Very playful"
        )
        
        VStack(spacing: 16) {
            PetCard(
                pet: samplePet,
                isSelected: false,
                isSelectionMode: false,
                onTap: {},
                onLongPress: {},
                onArchive: {},
                onEdit: {}
            )
            
            PetCard(
                pet: samplePet,
                isSelected: true,
                isSelectionMode: true,
                onTap: {},
                onLongPress: {},
                onArchive: {},
                onEdit: {}
            )
        }
        .padding()
        .background(AppColors.backgroundGradientStart)
    }
}
