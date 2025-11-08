import SwiftUI

struct PlanSessionView: View {
    @ObservedObject var viewModel: HobbyViewModel
    let selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedHobby: Hobby?
    @State private var sessionDate: Date
    @State private var duration = ""
    @State private var comment = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingAddHobby = false
    
    init(viewModel: HobbyViewModel, selectedDate: Date) {
        self.viewModel = viewModel
        self.selectedDate = selectedDate
        self._sessionDate = State(initialValue: selectedDate)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                WebPatternBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Plan Session")
                                .font(FontManager.title)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Text("Schedule a session for your hobby")
                                .font(FontManager.body)
                                .foregroundColor(ColorTheme.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Hobby")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                                .fontWeight(.semibold)
                            
                            if viewModel.hobbies.isEmpty {
                                VStack(spacing: 16) {
                                    Text("No hobbies available")
                                        .font(FontManager.body)
                                        .foregroundColor(ColorTheme.secondaryText)
                                    
                                    Button("Create New Hobby") {
                                        showingAddHobby = true
                                    }
                                    .font(FontManager.body)
                                    .foregroundColor(ColorTheme.primaryBlue)
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
                                )
                            } else {
                                LazyVStack(spacing: 8) {
                                    ForEach(viewModel.hobbies) { hobby in
                                        HobbySelectionCard(
                                            hobby: hobby,
                                            isSelected: selectedHobby?.id == hobby.id
                                        ) {
                                            selectedHobby = hobby
                                        }
                                    }
                                    
                                    Button(action: {
                                        showingAddHobby = true
                                    }) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(ColorTheme.lightBlue.opacity(0.2))
                                                    .frame(width: 40, height: 40)
                                                
                                                Image(systemName: "plus")
                                                    .font(.system(size: 18, weight: .medium))
                                                    .foregroundColor(ColorTheme.primaryBlue)
                                            }
                                            
                                            Text("Create New Hobby")
                                                .font(FontManager.subheadline)
                                                .foregroundColor(ColorTheme.primaryBlue)
                                                .fontWeight(.medium)
                                            
                                            Spacer()
                                        }
                                        .padding(12)
                                        .background(ColorTheme.cardBackground)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(ColorTheme.primaryBlue.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        
                        if selectedHobby != nil {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Date & Time")
                                    .font(FontManager.subheadline)
                                    .foregroundColor(ColorTheme.primaryText)
                                    .fontWeight(.semibold)
                                
                                DatePicker(
                                    "Select date and time",
                                    selection: $sessionDate,
                                    in: Date()...,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .datePickerStyle(.compact)
                                .accentColor(ColorTheme.primaryBlue)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Duration (minutes)")
                                    .font(FontManager.subheadline)
                                    .foregroundColor(ColorTheme.primaryText)
                                    .fontWeight(.semibold)
                                
                                TextField("Enter duration in minutes", text: $duration)
                                    .font(FontManager.body)
                                    .keyboardType(.numberPad)
                                    .padding(16)
                                    .background(ColorTheme.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Quick Duration")
                                    .font(FontManager.subheadline)
                                    .foregroundColor(ColorTheme.primaryText)
                                    .fontWeight(.semibold)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                    ForEach([15, 30, 45, 60, 90, 120], id: \.self) { minutes in
                                        Button(action: {
                                            duration = "\(minutes)"
                                        }) {
                                            Text("\(minutes)m")
                                                .font(FontManager.body)
                                                .foregroundColor(duration == "\(minutes)" ? .white : ColorTheme.primaryBlue)
                                                .frame(height: 40)
                                                .frame(maxWidth: .infinity)
                                                .background(duration == "\(minutes)" ? ColorTheme.primaryBlue : ColorTheme.cardBackground)
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(ColorTheme.primaryBlue.opacity(0.3), lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Notes (optional)")
                                    .font(FontManager.subheadline)
                                    .foregroundColor(ColorTheme.primaryText)
                                    .fontWeight(.semibold)
                                
                                TextField("Add notes about your planned session...", text: $comment, axis: .vertical)
                                    .font(FontManager.body)
                                    .lineLimit(3...6)
                                    .padding(16)
                                    .background(ColorTheme.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSession()
                    }
                    .font(FontManager.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTheme.primaryBlue)
                    .disabled(selectedHobby == nil || duration.isEmpty)
                }
            }
        }
        .sheet(isPresented: $showingAddHobby) {
            AddHobbyView(viewModel: viewModel)
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveSession() {
        guard let hobby = selectedHobby else {
            errorMessage = "Please select a hobby"
            showingError = true
            return
        }
        
        guard let durationInt = Int(duration), durationInt > 0 else {
            errorMessage = "Please enter a valid duration"
            showingError = true
            return
        }
        
        if comment.count > 300 {
            errorMessage = "Comment must be 300 characters or less"
            showingError = true
            return
        }
        
        viewModel.addSession(
            to: hobby,
            date: sessionDate,
            duration: durationInt,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
            isPlanned: true
        )
        
        dismiss()
    }
}

struct HobbySelectionCard: View {
    let hobby: Hobby
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? ColorTheme.primaryBlue.opacity(0.2) : ColorTheme.primaryBlue.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: hobby.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(hobby.name)
                        .font(FontManager.subheadline)
                        .foregroundColor(ColorTheme.primaryText)
                        .fontWeight(.semibold)
                    
                    Text("\(hobby.totalSessions) sessions")
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
            }
            .padding(12)
            .background(isSelected ? ColorTheme.primaryBlue.opacity(0.05) : ColorTheme.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? ColorTheme.primaryBlue : ColorTheme.lightBlue.opacity(0.3),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
