import SwiftUI

struct AddMemoryView: View {
    @ObservedObject var memoryStore: MemoryStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate = Date()
    @State private var title = ""
    @State private var description = ""
    @State private var selectedMood = "😊"
    
    let moods = ["😊", "😐", "😢", "😡", "🤩", "😴", "🤔", "😍"]
    
    var existingMemory: Memory?
    
    init(memoryStore: MemoryStore, existingMemory: Memory? = nil) {
        self.memoryStore = memoryStore
        self.existingMemory = existingMemory
        
        if let memory = existingMemory {
            _selectedDate = State(initialValue: memory.date)
            _title = State(initialValue: memory.title)
            _description = State(initialValue: memory.description)
            _selectedMood = State(initialValue: memory.mood)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        dateSection
                        
                        titleSection
                        
                        descriptionSection
                        
                        moodSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(existingMemory == nil ? "New Memory" : "Edit Memory")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMemory()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(16)
                .background(AppColors.cardGradient)
                .cornerRadius(12)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Title")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            TextField("Short event name", text: $title)
                .font(.ubuntu(16, weight: .regular))
                .padding(16)
                .background(AppColors.cardGradient)
                .cornerRadius(12)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            TextEditor(text: $description)
                .font(.ubuntu(16, weight: .regular))
                .padding(12)
                .frame(minHeight: 120)
                .scrollContentBackground(.hidden)
                .background(AppColors.cardGradient)
                .cornerRadius(12)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
    }
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mood")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(moods, id: \.self) { mood in
                    Button(action: { selectedMood = mood }) {
                        Text(mood)
                            .font(.system(size: 32))
                            .frame(width: 60, height: 60)
                            .background(
                                selectedMood == mood ? 
                                AnyShapeStyle(AppColors.primaryYellow.opacity(0.3)) :
                                    AnyShapeStyle(AppColors.cardGradient)
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedMood == mood ? 
                                        AppColors.primaryYellow : 
                                        Color.clear, 
                                        lineWidth: 2
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(12)
            .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
    }
    
    private func saveMemory() {
        if let existing = existingMemory {
            let updatedMemory = Memory(
                id: existing.id,
                date: selectedDate,
                title: title,
                description: description,
                mood: selectedMood,
                isFavorite: existing.isFavorite
            )
            memoryStore.updateMemory(updatedMemory)
        } else {
            let memory = Memory(
                date: selectedDate,
                title: title,
                description: description,
                mood: selectedMood
            )
            memoryStore.addMemory(memory)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddMemoryView(memoryStore: MemoryStore())
}
