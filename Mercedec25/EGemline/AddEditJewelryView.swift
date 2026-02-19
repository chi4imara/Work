import SwiftUI

enum JewelryFormMode {
    case add
    case edit
}

struct AddEditJewelryView: View {
    let jewelryId: UUID?
    let mode: JewelryFormMode
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var brand = ""
    @State private var material = ""
    @State private var stones = ""
    @State private var priceText = ""
    @State private var category: JewelryCategory = .rings
    @State private var style: JewelryStyle = .classic
    @State private var color = ""
    @State private var notes = ""
    @State private var imageURL = ""
    
    private var price: Double {
        Double(priceText) ?? 0
    }
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !brand.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                GridPatternView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        formField("Name", text: $name, placeholder: "Jewelry name")
                        formField("Brand", text: $brand, placeholder: "Brand name")
                        formField("Material", text: $material, placeholder: "e.g. Gold, Silver")
                        formField("Stones", text: $stones, placeholder: "e.g. Diamond, Pearl or None")
                        formField("Price", text: $priceText, placeholder: "0")
                            .keyboardType(.decimalPad)
                        formField("Color", text: $color, placeholder: "e.g. Silver, Gold")
                        formField("Notes", text: $notes, placeholder: "Optional notes")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfairDisplay(14, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryText)
                            Picker("Category", selection: $category) {
                                ForEach(JewelryCategory.allCases, id: \.self) { cat in
                                    Text(cat.rawValue).tag(cat)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(ColorTheme.primaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Style")
                                .font(.playfairDisplay(14, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryText)
                            Picker("Style", selection: $style) {
                                ForEach(JewelryStyle.allCases, id: \.self) { s in
                                    Text(s.rawValue).tag(s)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(ColorTheme.primaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(mode == .add ? "Add Jewelry" : "Edit Jewelry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        save()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(isValid ? ColorTheme.primaryBlue : ColorTheme.secondaryText)
                    .disabled(!isValid)
                }
            }
            .onAppear {
                if case .edit = mode, let id = jewelryId, let jewelry = appState.getJewelry(by: id) {
                    name = jewelry.name
                    brand = jewelry.brand
                    material = jewelry.material
                    stones = jewelry.stones
                    priceText = jewelry.price > 0 ? String(Int(jewelry.price)) : ""
                    category = jewelry.category
                    style = jewelry.style
                    color = jewelry.color
                    notes = jewelry.notes
                    imageURL = jewelry.imageURL
                }
            }
        }
    }
    
    private func formField(_ label: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.playfairDisplay(14, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            TextField(placeholder, text: text)
                .font(.playfairDisplay(16))
                .foregroundColor(ColorTheme.primaryText)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.backgroundWhite)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.05), radius: 3)
                )
        }
    }
    
    private func save() {
        if mode == .add {
            let newJewelry = Jewelry(
                name: name.trimmingCharacters(in: .whitespaces),
                brand: brand.trimmingCharacters(in: .whitespaces),
                material: material.trimmingCharacters(in: .whitespaces),
                stones: stones.trimmingCharacters(in: .whitespaces).isEmpty ? "None" : stones.trimmingCharacters(in: .whitespaces),
                price: price,
                category: category,
                imageURL: imageURL,
                style: style,
                color: color.trimmingCharacters(in: .whitespaces),
                notes: notes.trimmingCharacters(in: .whitespaces)
            )
            appState.addJewelry(newJewelry)
        } else if let id = jewelryId {
            let updated = Jewelry(
                id: id,
                name: name.trimmingCharacters(in: .whitespaces),
                brand: brand.trimmingCharacters(in: .whitespaces),
                material: material.trimmingCharacters(in: .whitespaces),
                stones: stones.trimmingCharacters(in: .whitespaces).isEmpty ? "None" : stones.trimmingCharacters(in: .whitespaces),
                price: price,
                category: category,
                imageURL: imageURL,
                style: style,
                color: color.trimmingCharacters(in: .whitespaces),
                notes: notes.trimmingCharacters(in: .whitespaces)
            )
            appState.updateJewelry(updated)
        }
        dismiss()
    }
}

#Preview {
    AddEditJewelryView(jewelryId: nil, mode: .add)
        .environmentObject(AppState())
}
