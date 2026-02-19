import SwiftUI

struct NewScenarioView: View {
    @EnvironmentObject var viewModel: PhotoshootViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var theme = ""
    @State private var location = ""
    @State private var date = Date()
    @State private var poses = ""
    @State private var props = ""
    @State private var comment = ""
    @State private var status: ScenarioStatus = .planned
    @State private var category: ScenarioCategory = .portrait
    
    private var isFormValid: Bool {
        !theme.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
                                                    .stroke(theme.isEmpty ? Color.appLightGray : Color.appPrimary, lineWidth: 1)
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
                            Button(action: saveScenario) {
                                Text("Save")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(isFormValid ? Color.appPrimary : Color.appLightGray)
                                    )
                            }
                            .disabled(!isFormValid)
                            
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
            .navigationTitle("New Scenario")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func saveScenario() {
        let newScenario = PhotoshootScenario(
            theme: theme,
            location: location,
            date: date,
            poses: poses,
            props: props,
            comment: comment,
            status: status,
            category: category
        )
        
        viewModel.addScenario(newScenario)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NewScenarioView()
        .environmentObject(PhotoshootViewModel())
}
