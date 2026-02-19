import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var taskName = ""
    @State private var selectedCategory = PlaceCategory.walk
    @State private var selectedFrequency = TaskFrequency.once
    @State private var whyImportant = ""
    @State private var isAddingPlace = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text("Add New")
                                .font(.playfairDisplay(.bold, size: 28))
                                .foregroundColor(.primaryBlue)
                            
                            HStack(spacing: 0) {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isAddingPlace = false
                                    }
                                }) {
                                    Text("Task")
                                        .font(.playfairDisplay(.semibold, size: 16))
                                        .foregroundColor(isAddingPlace ? .textSecondary : .white)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(isAddingPlace ? Color.clear : Color.primaryBlue)
                                        )
                                }
                                
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isAddingPlace = true
                                    }
                                }) {
                                    Text("Place")
                                        .font(.playfairDisplay(.semibold, size: 16))
                                        .foregroundColor(isAddingPlace ? .white : .textSecondary)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(isAddingPlace ? Color.primaryBlue : Color.clear)
                                        )
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.primaryBlue, lineWidth: 2)
                            )
                            .padding(.horizontal, 40)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(isAddingPlace ? "Place Name" : "Task Name")
                                    .font(.playfairDisplay(.semibold, size: 16))
                                    .foregroundColor(.primaryBlue)
                                
                                TextField(isAddingPlace ? "Enter place name" : "Enter task name", text: $taskName)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.playfairDisplay(.semibold, size: 16))
                                    .foregroundColor(.primaryBlue)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                    ForEach(PlaceCategory.allCases) { category in
                                        CategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category
                                        ) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                            }
                            
                            if !isAddingPlace {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Frequency")
                                        .font(.playfairDisplay(.semibold, size: 16))
                                        .foregroundColor(.primaryBlue)
                                    
                                    VStack(spacing: 8) {
                                        ForEach(TaskFrequency.allCases) { frequency in
                                            FrequencyButton(
                                                frequency: frequency,
                                                isSelected: selectedFrequency == frequency
                                            ) {
                                                selectedFrequency = frequency
                                            }
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Why is this important? (Optional)")
                                    .font(.playfairDisplay(.semibold, size: 16))
                                    .foregroundColor(.primaryBlue)
                                
                                TextField("Enter your thoughts...", text: $whyImportant, axis: .vertical)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .lineLimit(3...6)
                            }
                        }
                        .cardStyle()
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                    .font(.playfairDisplay(.semibold, size: 16))
                    .foregroundColor(taskName.isEmpty ? .textLight : .primaryYellow)
                    .disabled(taskName.isEmpty)
                }
            }
        }
    }
    
    private func saveItem() {
        guard !taskName.isEmpty else { return }
        
        if isAddingPlace {
            let place = Place(
                name: taskName,
                category: selectedCategory,
                whyImportant: whyImportant.isEmpty ? nil : whyImportant
            )
            viewModel.addPlace(place)
        } else {
            let task = DailyTask(
                title: taskName,
                category: selectedCategory,
                frequency: selectedFrequency,
                whyImportant: whyImportant.isEmpty ? nil : whyImportant
            )
            viewModel.addTask(task)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct CategoryButton: View {
    let category: PlaceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .primaryBlue)
                
                Text(category.rawValue)
                    .font(.playfairDisplay(.medium, size: 12))
                    .foregroundColor(isSelected ? .white : .primaryBlue)
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.primaryBlue : Color.white.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primaryBlue.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                    }
            )
        }
    }
}

struct FrequencyButton: View {
    let frequency: TaskFrequency
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(frequency.rawValue)
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(isSelected ? .white : .primaryBlue)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.primaryBlue : Color.white.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primaryBlue.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                    }
            )
        }
    }
}

#Preview {
    AddTaskView(viewModel: AppViewModel())
}
