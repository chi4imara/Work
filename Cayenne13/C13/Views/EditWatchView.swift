import SwiftUI

struct EditWatchView: View {
    @Binding var watch: Watch
    @ObservedObject var viewModel: WatchViewModel
    @Binding var isPresented: Bool
    
    @State private var watchName: String
    @State private var purchaseDate: Date
    @State private var selectedStyle: WatchStyle
    @State private var selectedCondition: WatchCondition
    @State private var comment: String
    
    init(watch: Binding<Watch>, viewModel: WatchViewModel, isPresented: Binding<Bool>) {
        self._watch = watch
        self.viewModel = viewModel
        self._isPresented = isPresented
        
        self._watchName = State(initialValue: watch.wrappedValue.name)
        self._purchaseDate = State(initialValue: watch.wrappedValue.purchaseDate)
        self._selectedStyle = State(initialValue: watch.wrappedValue.style)
        self._selectedCondition = State(initialValue: watch.wrappedValue.condition)
        self._comment = State(initialValue: watch.wrappedValue.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        HStack {
                            Button("Cancel") {
                                isPresented = false
                            }
                            .font(.playfairDisplay(size: 16, weight: .medium))
                            .foregroundColor(ColorManager.lightBlue)
                            
                            Spacer()
                            
                            Text("Edit Watch")
                                .font(.playfairDisplay(size: 20, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Spacer()
                            
                            Button("Save") {
                                saveChanges()
                            }
                            .font(.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(ColorManager.orange)
                            .disabled(watchName.isEmpty)
                            .opacity(watchName.isEmpty ? 0.6 : 1.0)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            CustomTextField(
                                title: "Name / Model",
                                text: $watchName,
                                placeholder: "Enter watch name or model"
                            )
                            
                            CustomDatePicker(
                                title: "Purchase Date",
                                date: $purchaseDate
                            )
                            
                            CustomPicker(
                                title: "Style",
                                selection: $selectedStyle,
                                options: WatchStyle.allCases
                            )
                            
                            CustomPicker(
                                title: "Condition",
                                selection: $selectedCondition,
                                options: WatchCondition.allCases
                            )
                            
                            CustomTextEditor(
                                title: "Comment (Optional)",
                                text: $comment,
                                placeholder: "Add any additional notes..."
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveChanges) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20))
                                
                                Text("Save Changes")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(ColorManager.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [ColorManager.lightBlue, ColorManager.orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(28)
                            .shadow(color: ColorManager.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(watchName.isEmpty)
                        .opacity(watchName.isEmpty ? 0.6 : 1.0)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func saveChanges() {
        var updatedWatch = watch
        updatedWatch.name = watchName
        updatedWatch.purchaseDate = purchaseDate
        updatedWatch.style = selectedStyle
        updatedWatch.condition = selectedCondition
        updatedWatch.comment = comment
        
        viewModel.updateWatch(updatedWatch)
        
        watch = updatedWatch
        
        isPresented = false
    }
}

#Preview {
    EditWatchView(
        watch: .constant(Watch(
            name: "Casio Edifice",
            purchaseDate: Date(),
            style: .sport,
            condition: .new,
            comment: "Birthday gift"
        )),
        viewModel: WatchViewModel(),
        isPresented: .constant(true)
    )
}
