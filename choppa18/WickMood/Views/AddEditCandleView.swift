import SwiftUI

struct AddEditCandleView: View {
    @ObservedObject var candleStore: CandleStore
    @Environment(\.dismiss) private var dismiss
    
    let editingCandle: Candle?
    
    @State private var name = ""
    @State private var brand = ""
    @State private var notes = ""
    @State private var selectedMood: Mood = .cozy
    @State private var selectedSeason: Season = .autumn
    @State private var impression = ""
    @State private var isFavorite = false
    
    init(candleStore: CandleStore, editingCandle: Candle? = nil) {
        self.candleStore = candleStore
        self.editingCandle = editingCandle
        
        if let candle = editingCandle {
            _name = State(initialValue: candle.name)
            _brand = State(initialValue: candle.brand)
            _notes = State(initialValue: candle.notes)
            _selectedMood = State(initialValue: candle.mood)
            _selectedSeason = State(initialValue: candle.season)
            _impression = State(initialValue: candle.impression)
            _isFavorite = State(initialValue: candle.isFavorite)
        }
    }
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        VStack(spacing: 20) {
                            inputField("Candle Name", text: $name, placeholder: "e.g., Amber Wood")
                            inputField("Brand", text: $brand, placeholder: "e.g., Jo Malone")
                            inputField("Scent Notes", text: $notes, placeholder: "e.g., Amber, sandalwood, musk")
                            
                            selectorField("Mood", options: Mood.self, selection: $selectedMood)
                            
                            selectorField("Season", options: Season.self, selection: $selectedSeason)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Impression")
                                    .font(.playfairDisplay(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                TextEditor(text: $impression)
                                    .font(.playfairDisplay(size: 14))
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(minHeight: 80)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(AppColors.borderColor, lineWidth: 1)
                                            )
                                    )
                                    .overlay(
                                        Group {
                                            if impression.isEmpty {
                                                HStack {
                                                    VStack {
                                                        HStack {
                                                            Text("Describe how this candle makes you feel...")
                                                                .font(.playfairDisplay(size: 14))
                                                                .foregroundColor(AppColors.textLight)
                                                            Spacer()
                                                        }
                                                        Spacer()
                                                    }
                                                    .padding(12)
                                                }
                                            }
                                        }
                                    )
                            }
                            
                            HStack {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 20))
                                    .foregroundColor(isFavorite ? AppColors.accentPink : AppColors.textLight)
                                
                                Text("Favorite Candle")
                                    .font(.playfairDisplay(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Toggle("", isOn: $isFavorite)
                                    .toggleStyle(SwitchToggleStyle(tint: AppColors.accentPink))
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveCandle) {
                            Text("Save")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.buttonText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(isFormValid ? AppColors.buttonPrimary : AppColors.textLight)
                                        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
                                )
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.textLight)
            }
            
            Spacer()
            
            Text(editingCandle == nil ? "New Candle" : "Edit Candle")
                .font(.playfairDisplay(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.clear)
            }
            .disabled(true)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private func inputField(_ title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
            
            TextField(placeholder, text: text)
                .font(.playfairDisplay(size: 14))
                .foregroundColor(AppColors.textPrimary)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.borderColor, lineWidth: 1)
                        )
                )
        }
    }
    
    private func selectorField<T: RawRepresentable & CaseIterable & Identifiable>(
        _ title: String,
        options: T.Type,
        selection: Binding<T>
    ) -> some View where T.RawValue == String {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
            
            Menu {
                ForEach(Array(options.allCases), id: \.id) { option in
                    Button(action: {
                        selection.wrappedValue = option
                    }) {
                        HStack {
                            Text(option.rawValue)
                            if selection.wrappedValue.rawValue == option.rawValue {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selection.wrappedValue.rawValue)
                        .font(.playfairDisplay(size: 14))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.textLight)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.borderColor, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private func saveCandle() {
        if let editingCandle = editingCandle {
            let updatedCandle = Candle(
                id: editingCandle.id,
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
                mood: selectedMood,
                season: selectedSeason,
                impression: impression.trimmingCharacters(in: .whitespacesAndNewlines),
                isFavorite: isFavorite,
                dateCreated: editingCandle.dateCreated
            )
            candleStore.updateCandle(updatedCandle)
        } else {
            let candle = Candle(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
                mood: selectedMood,
                season: selectedSeason,
                impression: impression.trimmingCharacters(in: .whitespacesAndNewlines),
                isFavorite: isFavorite
            )
            candleStore.addCandle(candle)
        }
        
        dismiss()
    }
}

#Preview {
    AddEditCandleView(candleStore: CandleStore())
}
