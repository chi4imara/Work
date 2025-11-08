import SwiftUI

struct AddSessionView: View {
    let hobby: Hobby
    @ObservedObject var viewModel: HobbyViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    @State private var duration = ""
    @State private var comment = ""
    @State private var isPlanned = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                WebPatternBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(ColorTheme.primaryBlue.opacity(0.1))
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: hobby.icon)
                                        .font(.system(size: 24, weight: .medium))
                                        .foregroundColor(ColorTheme.primaryBlue)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("New Session")
                                        .font(FontManager.title)
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Text(hobby.name)
                                        .font(FontManager.subheadline)
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Session Type")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                                .fontWeight(.semibold)
                            
                            HStack(spacing: 0) {
                                Button(action: {
                                    isPlanned = false
                                }) {
                                    Text("Completed")
                                        .font(FontManager.body)
                                        .foregroundColor(isPlanned ? ColorTheme.secondaryText : .white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(isPlanned ? Color.clear : ColorTheme.primaryBlue)
                                }
                                
                                Button(action: {
                                    isPlanned = true
                                }) {
                                    Text("Planned")
                                        .font(FontManager.body)
                                        .foregroundColor(isPlanned ? .white : ColorTheme.secondaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(isPlanned ? ColorTheme.primaryBlue : Color.clear)
                                }
                            }
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
                            )
                            .animation(.easeInOut(duration: 0.2), value: isPlanned)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Date & Time")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                                .fontWeight(.semibold)
                            
                            DatePicker(
                                "Select date and time",
                                selection: $selectedDate,
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
                            Text("Notes (optional)")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                                .fontWeight(.semibold)
                            
                            TextField("Add notes about your session...", text: $comment, axis: .vertical)
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
                    .foregroundColor(duration.isEmpty ? Color.gray : ColorTheme.primaryBlue)
                    .disabled(duration.isEmpty)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveSession() {
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
            date: selectedDate,
            duration: durationInt,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
            isPlanned: isPlanned
        )
        
        dismiss()
    }
}

