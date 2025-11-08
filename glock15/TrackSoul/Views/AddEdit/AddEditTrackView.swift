import SwiftUI

struct AddEditTrackView: View {
    @ObservedObject var viewModel: TrackViewModel
    @Environment(\.dismiss) private var dismiss
    
    let trackToEdit: TrackData?
    
    @State private var title = ""
    @State private var artist = ""
    @State private var whereHeard: WhereHeardOption = .radio
    @State private var context = ""
    @State private var whatReminds = ""
    @State private var dateAdded = Date()
    @State private var showingDatePicker = false
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    
    private var isEditing: Bool {
        trackToEdit != nil
    }
    
    init(viewModel: TrackViewModel, trackToEdit: TrackData? = nil) {
        self.viewModel = viewModel
        self.trackToEdit = trackToEdit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(isEditing ? "Edit Track" : "New Track")
                                .font(.appTitle2)
                                .foregroundColor(.appPrimaryText)
                                .padding(.horizontal, 20)
                            
                            Divider()
                                .background(Color.appGridBlue)
                                .padding(.horizontal, 20)
                        }
                        
                        VStack(spacing: 20) {
                            FormField(
                                title: "Track Title",
                                text: $title,
                                placeholder: "Enter track title",
                                isRequired: true
                            )
                            
                            FormField(
                                title: "Artist",
                                text: $artist,
                                placeholder: "Enter artist name (optional)"
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Where Heard")
                                        .font(.appCallout)
                                        .foregroundColor(.appPrimaryText)
                                    
                                    Text("*")
                                        .font(.appCallout)
                                        .foregroundColor(.appAccent)
                                }
                                
                                Picker("Where Heard", selection: $whereHeard) {
                                    ForEach(WhereHeardOption.allCases, id: \.self) { option in
                                        Text(option.displayName)
                                            .tag(option)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(Color.appBackgroundGray)
                                .cornerRadius(8)
                            }
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            FormField(
                                title: "Context (Where Heard)",
                                text: $context,
                                placeholder: "Add context like place, event, episode...",
                                axis: .vertical
                            )
                            
                            FormField(
                                title: "What Reminds",
                                text: $whatReminds,
                                placeholder: "What does this track remind you of?",
                                axis: .vertical
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Date Added")
                                        .font(.appCallout)
                                        .foregroundColor(.appPrimaryText)
                                    
                                    Text("*")
                                        .font(.appCallout)
                                        .foregroundColor(.appAccent)
                                }
                                
                                Button(action: { showingDatePicker = true }) {
                                    HStack {
                                        Text(dateFormatter.string(from: dateAdded))
                                            .font(.appCallout)
                                            .foregroundColor(.appPrimaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "calendar")
                                            .foregroundColor(.appPrimaryBlue)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 12)
                                    .background(Color.appBackgroundGray)
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.vertical, 20)
                }
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.appCallout)
                                .foregroundColor(.appSecondaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.appBackgroundGray)
                                .cornerRadius(25)
                        }
                        
                        Button {
                            saveTrack()
                        } label: {
                            Text("Save")
                                .font(.appCallout)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: [Color.appPrimaryBlue, Color.appDarkBlue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                        }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $dateAdded)
        }
        .alert("Validation Error", isPresented: $showingValidationAlert) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
        .onAppear {
            loadTrackData()
            if !isEditing {
                dateAdded = Date()
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private func loadTrackData() {
        if let track = trackToEdit {
            title = track.title
            artist = track.artist ?? ""
            whereHeard = WhereHeardOption(rawValue: track.whereHeard) ?? .radio
            context = track.context ?? ""
            whatReminds = track.whatReminds ?? ""
            dateAdded = track.dateAdded
        }
    }
    
    private func saveTrack() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTitle.isEmpty {
            validationMessage = "Please enter a track title"
            showingValidationAlert = true
            return
        }
        
        if dateAdded > Date() {
            validationMessage = "Cannot set a future date"
            showingValidationAlert = true
            return
        }
        
        let trimmedArtist = artist.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContext = context.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedWhatReminds = whatReminds.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let track = trackToEdit {
            viewModel.updateTrack(
                track,
                title: trimmedTitle,
                artist: trimmedArtist.isEmpty ? nil : trimmedArtist,
                whereHeard: whereHeard,
                context: trimmedContext.isEmpty ? nil : trimmedContext,
                whatReminds: trimmedWhatReminds.isEmpty ? nil : trimmedWhatReminds,
                dateAdded: dateAdded
            )
        } else {
            viewModel.addTrack(
                title: trimmedTitle,
                artist: trimmedArtist.isEmpty ? nil : trimmedArtist,
                whereHeard: whereHeard,
                context: trimmedContext.isEmpty ? nil : trimmedContext,
                whatReminds: trimmedWhatReminds.isEmpty ? nil : trimmedWhatReminds,
                dateAdded: dateAdded
            )
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("TrackDataChanged"), object: nil)
        dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isRequired: Bool = false
    var axis: Axis = .horizontal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.appCallout)
                    .foregroundColor(.appPrimaryText)
                
                if isRequired {
                    Text("*")
                        .font(.appCallout)
                        .foregroundColor(.appAccent)
                }
            }
            
            TextField(placeholder, text: $text, axis: axis)
                .font(.appCallout)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(Color.appBackgroundGray)
                .cornerRadius(8)
                .lineLimit(axis == .vertical ? 3 : 1)
        }
        .padding(.horizontal, 20)
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
                
                Spacer()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
