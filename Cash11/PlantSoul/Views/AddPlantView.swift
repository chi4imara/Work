import SwiftUI

struct AddPlantView: View {
    @ObservedObject var plantViewModel: PlantViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedCategory = PlantCategory.indoor
    @State private var notes = ""
    @State private var isFavorite = false
    
    @State private var wateringFrequency = 7
    @State private var fertilizingFrequency = 30
    @State private var repottingFrequency = 365
    @State private var cleaningFrequency = 14
    @State private var generalCareFrequency = 7
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorScheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignConstants.largePadding) {
                        RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                            .fill(ColorScheme.accent.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(ColorScheme.accent)
                            )
                        
                        VStack(spacing: DesignConstants.mediumPadding) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Plant Name")
                                    .font(FontManager.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(ColorScheme.lightText)
                                
                                TextField("", text: $name)
                                    .font(FontManager.body)
                                    .overlay(
                                        HStack {
                                            Text("Enter plant name")
                                                .font(FontManager.body)
                                                .foregroundColor(.gray)
                                                .opacity(name.isEmpty ? 1 : 0)
                                                .allowsTightening(false)
                                            
                                            Spacer()
                                        }
                                    )
                                    .padding(DesignConstants.mediumPadding)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                            .fill(ColorScheme.cardGradient)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(FontManager.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(ColorScheme.lightText)
                                
                                Picker("Category", selection: $selectedCategory) {
                                    ForEach(PlantCategory.allCases, id: \.self) { category in
                                        Text(category.displayName).tag(category)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
                                Text("Care Schedule")
                                    .font(FontManager.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(ColorScheme.lightText)
                                
                                CareFrequencyRow(
                                    title: "Watering",
                                    icon: "drop.fill",
                                    frequency: $wateringFrequency
                                )
                                
                                CareFrequencyRow(
                                    title: "Fertilizing",
                                    icon: "leaf.fill",
                                    frequency: $fertilizingFrequency
                                )
                                
                                CareFrequencyRow(
                                    title: "Repotting",
                                    icon: "leaf.circle.fill",
                                    frequency: $repottingFrequency
                                )
                                
                                CareFrequencyRow(
                                    title: "Cleaning",
                                    icon: "sparkles",
                                    frequency: $cleaningFrequency
                                )
                                
                                CareFrequencyRow(
                                    title: "General Care",
                                    icon: "heart.fill",
                                    frequency: $generalCareFrequency
                                )
                            }
                            .padding(DesignConstants.mediumPadding)
                            .background(
                                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                    .fill(ColorScheme.cardGradient.opacity(0.5))
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(FontManager.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(ColorScheme.lightText)
                                
                                TextField("", text: $notes, axis: .vertical)
                                    .font(FontManager.body)
                                    .overlay(
                                        HStack {
                                            Text("Add notes about your plant...")
                                                .font(FontManager.body)
                                                .foregroundColor(.gray)
                                                .opacity(notes.isEmpty ? 1 : 0)
                                                .allowsTightening(false)
                                            
                                            Spacer()
                                        }
                                    )
                                    .lineLimit(3...6)
                                    .padding(DesignConstants.mediumPadding)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                            .fill(ColorScheme.cardGradient)
                                    )
                            }
                            
                            Toggle(isOn: $isFavorite) {
                                Text("Add to Favorites")
                                    .font(FontManager.subheadline)
                                    .foregroundColor(ColorScheme.lightText)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: ColorScheme.accent))
                        }
                    }
                    .padding(DesignConstants.largePadding)
                }
            }
            .navigationTitle("Add Plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorScheme.lightText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePlant()
                    }
                    .foregroundColor(ColorScheme.accent)
                    .fontWeight(.semibold)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func savePlant() {
        let careSchedule = CareSchedule(
            wateringFrequency: wateringFrequency,
            fertilizingFrequency: fertilizingFrequency,
            repottingFrequency: repottingFrequency,
            cleaningFrequency: cleaningFrequency,
            generalCareFrequency: generalCareFrequency
        )
        
        let plant = Plant(
            name: name,
            category: selectedCategory,
            careSchedule: careSchedule,
            notes: notes,
            isFavorite: isFavorite
        )
        
        plantViewModel.addPlant(plant)
        dismiss()
    }
}

struct CareFrequencyRow: View {
    let title: String
    let icon: String
    @Binding var frequency: Int
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(ColorScheme.accent)
                .frame(width: 24)
            
            Text(title)
                .font(FontManager.body)
                .foregroundColor(ColorScheme.lightText)
            
            Spacer()
            
            HStack {
                Button(action: {
                    if frequency > 1 {
                        frequency -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(ColorScheme.accent)
                }
                
                Text("\(frequency)")
                    .font(FontManager.body)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorScheme.lightText)
                    .frame(minWidth: 30)
                
                Button(action: {
                    frequency += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(ColorScheme.accent)
                }
            }
            
            Text("days")
                .font(FontManager.caption)
                .foregroundColor(ColorScheme.secondaryText)
        }
    }
}

#Preview {
    AddPlantView(plantViewModel: PlantViewModel())
}

