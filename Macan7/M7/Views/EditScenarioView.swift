import SwiftUI

struct EditScenarioView: View {
    let scenario: PhotoshootScenario
    @EnvironmentObject var viewModel: PhotoshootViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var theme: String
    @State private var location: String
    @State private var date: Date
    @State private var poses: String
    @State private var props: String
    @State private var comment: String
    @State private var status: ScenarioStatus
    @State private var category: ScenarioCategory
    
    init(scenario: PhotoshootScenario) {
        self.scenario = scenario
        
        _theme = State(initialValue: scenario.theme)
        _location = State(initialValue: scenario.location)
        _date = State(initialValue: scenario.date)
        _poses = State(initialValue: scenario.poses)
        _props = State(initialValue: scenario.props)
        _comment = State(initialValue: scenario.comment)
        _status = State(initialValue: scenario.status)
        _category = State(initialValue: scenario.category)
    }
    
    private var isFormValid: Bool {
        !theme.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        theme != scenario.theme ||
        location != scenario.location ||
        date != scenario.date ||
        poses != scenario.poses ||
        props != scenario.props ||
        comment != scenario.comment ||
        status != scenario.status ||
        category != scenario.category
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                StaticBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Theme")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(.appPrimaryText)
                                    
                                    Text("*")
                                        .foregroundColor(.red)
                                }
                                
                                TextField("Enter shoot theme", text: $theme)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.appPrimaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12)
                                                .stroke(theme.isEmpty ? Color.red : Color.appPrimary, lineWidth: 1)
                                            }
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Location")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appPrimaryText)
                                
                                TextField("Enter location", text: $location)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.appPrimaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.appLightGray, lineWidth: 1)
                                            }
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Planned Date")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appPrimaryText)
                                
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.appLightGray, lineWidth: 1)
                                            }
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appPrimaryText)
                                
                                Picker("Category", selection: $category) {
                                    ForEach(ScenarioCategory.allCases, id: \.self) { cat in
                                        HStack {
                                            Image(systemName: cat.icon)
                                            Text(cat.rawValue)
                                        }
                                        .tag(cat)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.appLightGray, lineWidth: 1)
                                        }
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Poses")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appPrimaryText)
                                
                                TextEditor(text: $poses)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.appPrimaryText)
                                    .frame(minHeight: 80)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.appLightGray, lineWidth: 1)
                                            }
                                    )
                                    .overlay(
                                        VStack {
                                            HStack {
                                                if poses.isEmpty {
                                                    Text("Describe poses and shots...")
                                                        .font(.ubuntu(16))
                                                        .foregroundColor(.appSecondaryText)
                                                        .padding(.leading, 20)
                                                        .padding(.top, 20)
                                                }
                                                Spacer()
                                            }
                                            Spacer()
                                        }
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Props")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appPrimaryText)
                                
                                TextField("List required props", text: $props)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.appPrimaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.appLightGray, lineWidth: 1)
                                            }
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appPrimaryText)
                                
                                TextEditor(text: $comment)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.appPrimaryText)
                                    .frame(minHeight: 60)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.appLightGray, lineWidth: 1)
                                            }
                                    )
                                    .overlay(
                                        VStack {
                                            HStack {
                                                if comment.isEmpty {
                                                    Text("Additional notes...")
                                                        .font(.ubuntu(16))
                                                        .foregroundColor(.appSecondaryText)
                                                        .padding(.leading, 20)
                                                        .padding(.top, 20)
                                                }
                                                Spacer()
                                            }
                                            Spacer()
                                        }
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Status")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appPrimaryText)
                                
                                Picker("Status", selection: $status) {
                                    ForEach(ScenarioStatus.allCases, id: \.self) { stat in
                                        Text(stat.rawValue)
                                            .tag(stat)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: saveChanges) {
                                Text("Save Changes")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(isFormValid && hasChanges ? Color.appPrimary : Color.appLightGray)
                                    )
                            }
                            .disabled(!isFormValid || !hasChanges)
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appSecondaryText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.appLightGray, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Edit Scenario")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveChanges()
                }
                .disabled(!isFormValid || !hasChanges)
            )
        }
    }
    
    private func saveChanges() {
        var updatedScenario = scenario
        updatedScenario.theme = theme
        updatedScenario.location = location
        updatedScenario.date = date
        updatedScenario.poses = poses
        updatedScenario.props = props
        updatedScenario.comment = comment
        updatedScenario.status = status
        updatedScenario.category = category
        
        viewModel.updateScenario(updatedScenario)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditScenarioView(
        scenario: PhotoshootScenario(
            theme: "Summer Evening by the Sea",
            location: "Beach Pier",
            date: Date(),
            poses: "Sitting on sand, back to sun",
            props: "Blanket, glass, hat",
            comment: "Shoot at sunset"
        ),
    )
}
