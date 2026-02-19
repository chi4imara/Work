import SwiftUI

struct AddMasterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var savedMaster: Master?
    
    @State private var name = ""
    @State private var rating = 5.0
    @State private var reviewCount = 0
    @State private var experience = 1
    @State private var pricePerHour = 100.0
    @State private var bio = ""
    @State private var selectedSpecialties: Set<MassageType> = []
    @State private var selectedAvailability: Set<String> = []
    @State private var isVerified = false
    @State private var showingConfirmation = false
    
    let availabilityOptions = ["Morning", "Afternoon", "Evening"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        nameSection
                        ratingSection
                        experienceSection
                        priceSection
                        specialtiesSection
                        availabilitySection
                        bioSection
                        verifiedSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Add Master")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMaster()
                    }
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .disabled(!isFormValid)
                }
            }
        }
        .alert("Master Added", isPresented: $showingConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("The master has been added. You can now select them when adding sessions.")
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Full Name")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            TextField("Enter master name", text: $name)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textPrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.cardGradient)
                        .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
                )
        }
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rating: \(String(format: "%.1f", rating))")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Slider(value: $rating, in: 1...5, step: 0.1)
                .accentColor(ColorTheme.primaryBlue)
            
            HStack {
                Text("Reviews count")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                Spacer()
                TextField("0", value: $reviewCount, format: .number)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textPrimary)
                    .keyboardType(.numberPad)
                    .frame(width: 60)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).fill(ColorTheme.cardBackground))
            }
        }
    }
    
    private var experienceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Years of Experience")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            HStack(spacing: 12) {
                ForEach([1, 3, 5, 8, 10], id: \.self) { years in
                    Button(action: { experience = years }) {
                        Text("\(years)")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(experience == years ? .white : ColorTheme.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(experience == years ? ColorTheme.primaryBlue : ColorTheme.cardBackground)
                            )
                    }
                }
            }
        }
    }
    
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price per Hour: $\(Int(pricePerHour))")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Slider(value: $pricePerHour, in: 30...300, step: 5)
                .accentColor(ColorTheme.primaryBlue)
        }
    }
    
    private var specialtiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Specialties")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(MassageType.allCases, id: \.self) { type in
                    Button(action: {
                        if selectedSpecialties.contains(type) {
                            selectedSpecialties.remove(type)
                        } else {
                            selectedSpecialties.insert(type)
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: type.icon)
                                .font(.system(size: 14))
                            Text(type.rawValue)
                                .font(.ubuntu(12, weight: .medium))
                        }
                        .foregroundColor(selectedSpecialties.contains(type) ? .white : ColorTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedSpecialties.contains(type) ? type.color : ColorTheme.cardBackground)
                        )
                    }
                }
            }
        }
    }
    
    private var availabilitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Availability")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            HStack(spacing: 12) {
                ForEach(availabilityOptions, id: \.self) { slot in
                    Button(action: {
                        if selectedAvailability.contains(slot) {
                            selectedAvailability.remove(slot)
                        } else {
                            selectedAvailability.insert(slot)
                        }
                    }) {
                        Text(slot)
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(selectedAvailability.contains(slot) ? .white : ColorTheme.textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedAvailability.contains(slot) ? ColorTheme.primaryBlue : ColorTheme.cardBackground)
                            )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bio (Optional)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            TextField("Short description...", text: $bio, axis: .vertical)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textPrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.cardGradient)
                        .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
                )
                .lineLimit(3...6)
        }
    }
    
    private var verifiedSection: some View {
        HStack {
            Text("Verified Master")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
            Spacer()
            Toggle("", isOn: $isVerified)
                .tint(ColorTheme.primaryBlue)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
        )
    }
    
    private func saveMaster() {
        let master = Master(
            name: name.trimmingCharacters(in: .whitespaces),
            rating: rating,
            reviewCount: max(0, reviewCount),
            specialties: Array(selectedSpecialties),
            experience: experience,
            pricePerHour: pricePerHour,
            availability: selectedAvailability.isEmpty ? availabilityOptions : Array(selectedAvailability),
            bio: bio.isEmpty ? "No bio provided." : bio,
            imageUrl: "",
            isVerified: isVerified
        )
        savedMaster = master
        showingConfirmation = true
    }
}

#Preview {
    AddMasterView(savedMaster: .constant(nil))
}
