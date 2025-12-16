import SwiftUI

struct CreateMomentView: View {
    @ObservedObject var momentsViewModel: DailyMomentsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var momentText = ""
    @State private var showingConfirmation = false
    
    private var currentDateTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    VStack(spacing: 12) {
                        Text("What was the most alive moment today?")
                            .font(.builderSans(size: 20, weight: .semibold))
                            .foregroundColor(.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Text(currentDateTime)
                            .font(.builderSans(size: 14, weight: .medium))
                            .foregroundColor(.secondaryText)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextEditor(text: $momentText)
                            .font(.builderSans(size: 16, weight: .regular))
                            .foregroundColor(.primaryText)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            )
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 200)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.primaryText.opacity(0.2), lineWidth: 1)
                            )
                        
                        if momentText.isEmpty {
                            Text("Describe the moment that you remember...")
                                .font(.builderSans(size: 14, weight: .regular))
                                .foregroundColor(.secondaryText.opacity(0.7))
                                .padding(.leading, 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: saveMoment) {
                        Text("Save Moment")
                            .font(.builderSans(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(momentText.isEmpty ? AnyShapeStyle(Color.gray) : AnyShapeStyle(AppGradients.buttonGradient))
                            )
                            .shadow(
                                color: momentText.isEmpty ? Color.clear : Color.accentYellow.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                    }
                    .disabled(momentText.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("New Moment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryText)
                }
            }
        }
        .alert("Moment Saved", isPresented: $showingConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your moment has been saved successfully.")
        }
    }
    
    private func saveMoment() {
        guard !momentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        momentsViewModel.saveMoment(momentText.trimmingCharacters(in: .whitespacesAndNewlines))
        showingConfirmation = true
    }
}

struct EditMomentView: View {
    let moment: DailyMoment
    @ObservedObject var momentsViewModel: DailyMomentsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var momentText: String
    @State private var showingConfirmation = false
    @State private var showingDeleteAlert = false
    
    init(moment: DailyMoment, momentsViewModel: DailyMomentsViewModel) {
        self.moment = moment
        self.momentsViewModel = momentsViewModel
        self._momentText = State(initialValue: moment.text)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    VStack(spacing: 12) {
                        Text("What was the most alive moment today?")
                            .font(.builderSans(size: 20, weight: .semibold))
                            .foregroundColor(.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Text(moment.dateString + ", " + moment.timeString)
                            .font(.builderSans(size: 14, weight: .medium))
                            .foregroundColor(.secondaryText)
                    }
                    .padding(.horizontal, 20)
                    
                    TextEditor(text: $momentText)
                        .font(.builderSans(size: 16, weight: .regular))
                        .foregroundColor(.primaryText)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.primaryText.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button(action: saveMoment) {
                            Text("Save Moment")
                                .font(.builderSans(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(momentText.isEmpty ? AnyShapeStyle(Color.gray) : AnyShapeStyle(AppGradients.buttonGradient))
                                )
                                .shadow(
                                    color: momentText.isEmpty ? Color.clear : Color.accentYellow.opacity(0.3),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        }
                        .disabled(momentText.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Edit Moment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryText)
                }
            }
        }
        .alert("Moment Saved", isPresented: $showingConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your moment has been updated successfully.")
        }
        .alert("Delete Moment", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                momentsViewModel.deleteMoment(moment)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this moment? This action cannot be undone.")
        }
    }
    
    private func saveMoment() {
        guard !momentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        momentsViewModel.updateMoment(moment, with: momentText.trimmingCharacters(in: .whitespacesAndNewlines))
        showingConfirmation = true
    }
}

#Preview {
    CreateMomentView(momentsViewModel: DailyMomentsViewModel())
}
