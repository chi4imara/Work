import SwiftUI

struct CreateProgramView: View {
    @ObservedObject var programsViewModel: ProgramsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var programName = ""
    @State private var inhaleSeconds = 4
    @State private var pauseSeconds = 0
    @State private var exhaleSeconds = 4
    @State private var cycleCount = 10
    
    @State private var showingNameError = false
    @State private var showingLongPhaseWarning = false
    
    private var isFormValid: Bool {
        !programName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        inhaleSeconds > 0 &&
        exhaleSeconds > 0 &&
        pauseSeconds >= 0 &&
        cycleCount > 0
    }
    
    private var hasLongPhase: Bool {
        inhaleSeconds > 600 || pauseSeconds > 600 || exhaleSeconds > 600
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerInfoView
                        
                        formFieldsView
                        
                        previewView
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Program")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.mediumText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProgram()
                    }
                    .foregroundColor(isFormValid ? AppColors.primaryPurple : AppColors.lightText)
                    .disabled(!isFormValid)
                }
            }
        }
        .alert("Long Phase Warning", isPresented: $showingLongPhaseWarning) {
            Button("Save Anyway") {
                saveProgram()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("One or more phases are unusually long (over 10 minutes). Are you sure you want to continue?")
        }
    }
    
    private var headerInfoView: some View {
        VStack(spacing: 16) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(AppColors.primaryPurple)
            
            Text("Create Custom Program")
                .font(.playfairDisplay(size: 24, weight: .semibold))
                .foregroundColor(AppColors.darkText)
                .multilineTextAlignment(.center)
            
            Text("Design your own breathing rhythm with custom timing for each phase")
                .font(.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(AppColors.mediumText)
                .multilineTextAlignment(.center)
        }
    }
    
    private var formFieldsView: some View {
        VStack(spacing: 20) {
            FormFieldView(
                title: "Program Name",
                icon: "textformat",
                isRequired: true
            ) {
                TextField("Enter program name", text: $programName)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            FormFieldView(
                title: "Inhale Duration",
                icon: "arrow.up.circle",
                isRequired: true
            ) {
                Stepper(value: $inhaleSeconds, in: 1...999) {
                    Text("\(inhaleSeconds) seconds")
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.darkText)
                }
            }
            
            FormFieldView(
                title: "Pause Duration",
                icon: "pause.circle",
                isRequired: false
            ) {
                Stepper(value: $pauseSeconds, in: 0...999) {
                    Text(pauseSeconds == 0 ? "No pause" : "\(pauseSeconds) seconds")
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.darkText)
                }
            }
            
            FormFieldView(
                title: "Exhale Duration",
                icon: "arrow.down.circle",
                isRequired: true
            ) {
                Stepper(value: $exhaleSeconds, in: 1...999) {
                    Text("\(exhaleSeconds) seconds")
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.darkText)
                }
            }
            
            FormFieldView(
                title: "Number of Cycles",
                icon: "repeat.circle",
                isRequired: true
            ) {
                Stepper(value: $cycleCount, in: 1...100) {
                    Text("\(cycleCount) cycles")
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.darkText)
                }
            }
        }
    }
    
    private var previewView: some View {
        VStack(spacing: 16) {
            Text("Preview")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.darkText)
            
            VStack(spacing: 12) {
                HStack {
                    Text("One Cycle:")
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(AppColors.mediumText)
                    
                    Spacer()
                    
                    Text(cycleDurationText)
                        .font(.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.darkText)
                }
                
                HStack {
                    Text("Total Duration:")
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(AppColors.mediumText)
                    
                    Spacer()
                    
                    Text(totalDurationText)
                        .font(.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.darkText)
                }
                
                Divider()
                
                Text(phaseDescriptionText)
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.mediumText)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(12)
        }
    }
    
    private var cycleDurationText: String {
        let totalSeconds = inhaleSeconds + pauseSeconds + exhaleSeconds
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    private var totalDurationText: String {
        let totalSeconds = (inhaleSeconds + pauseSeconds + exhaleSeconds) * cycleCount
        let minutes = totalSeconds / 60
        let remainingSeconds = totalSeconds % 60
        
        if minutes > 0 {
            return "\(minutes)m \(remainingSeconds)s"
        } else {
            return "\(remainingSeconds)s"
        }
    }
    
    private var phaseDescriptionText: String {
        if pauseSeconds > 0 {
            return "Inhale \(inhaleSeconds)s — Pause \(pauseSeconds)s — Exhale \(exhaleSeconds)s"
        } else {
            return "Inhale \(inhaleSeconds)s — Exhale \(exhaleSeconds)s"
        }
    }
    
    private func saveProgram() {
        let trimmedName = programName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            showingNameError = true
            return
        }
        
        if hasLongPhase {
            showingLongPhaseWarning = true
            return
        }
        
        let newProgram = BreathingProgram(
            name: trimmedName,
            inhaleSeconds: inhaleSeconds,
            pauseSeconds: pauseSeconds,
            exhaleSeconds: exhaleSeconds,
            cycleCount: cycleCount,
            isCustom: true
        )
        
        programsViewModel.addProgram(newProgram)
        dismiss()
    }
}

struct FormFieldView<Content: View>: View {
    let title: String
    let icon: String
    let isRequired: Bool
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(width: 20)
                
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.darkText)
                
                if isRequired {
                    Text("*")
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            
            content
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

#Preview {
    CreateProgramView(programsViewModel: ProgramsViewModel())
}
