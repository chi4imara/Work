import SwiftUI

struct EditHabitView: View {
    @EnvironmentObject var viewModel: HabitsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let habit: Habit
    
    @State private var name: String
    @State private var selectedCategory: HabitCategory
    @State private var time: String
    @State private var description: String
    @State private var comment: String
    
    init(habit: Habit) {
        self.habit = habit
        self._name = State(initialValue: habit.name)
        self._selectedCategory = State(initialValue: habit.category)
        self._time = State(initialValue: habit.time)
        self._description = State(initialValue: habit.description)
        self._comment = State(initialValue: habit.comment)
    }
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var hasChanges: Bool {
        name != habit.name ||
        selectedCategory != habit.category ||
        time != habit.time ||
        description != habit.description ||
        comment != habit.comment
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                AnimatedBubblesBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            FormFieldView(
                                title: "Name",
                                text: $name,
                                placeholder: "e.g., Evening Candle",
                                isRequired: true
                            )
                            
                            CategoryPickerView(selectedCategory: $selectedCategory)
                            
                            FormFieldView(
                                title: "Time",
                                text: $time,
                                placeholder: "e.g., 20:30"
                            )
                            
                            FormFieldView(
                                title: "Description",
                                text: $description,
                                placeholder: "Light a candle at the table after dinner",
                                isMultiline: true
                            )
                            
                            FormFieldView(
                                title: "Comment",
                                text: $comment,
                                placeholder: "Use vanilla scent",
                                isMultiline: true
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save Changes") {
                    saveChanges()
                }
                .disabled(!isFormValid || !hasChanges)
            )
        }
        .accentColor(AppColors.accent)
    }
    
    private func saveChanges() {
        var updatedHabit = habit
        updatedHabit.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedHabit.category = selectedCategory
        updatedHabit.time = time.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedHabit.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedHabit.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateHabit(updatedHabit)
        presentationMode.wrappedValue.dismiss()
    }
}
