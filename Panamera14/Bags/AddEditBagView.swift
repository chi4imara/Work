import SwiftUI
import PhotosUI

struct AddEditBagView: View {
    @ObservedObject var bagStore: BagStore
    @Environment(\.dismiss) private var dismiss
    
    let bagToEdit: Bag?
    
    @State private var name: String = ""
    @State private var selectedSize: BagSize = .medium
    @State private var selectedStyle: BagStyle = .casual
    @State private var suitableFor: String = ""
    @State private var notes: String = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    init(bagStore: BagStore, bagToEdit: Bag? = nil) {
        self.bagStore = bagStore
        self.bagToEdit = bagToEdit
    }
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !suitableFor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text("Photo")
                                .font(.bellGothic(18, weight: .bold))
                                .foregroundColor(.appDarkBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: {
                                showingActionSheet = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.cardGradient)
                                        .frame(height: 200)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(Color.appPrimaryBlue.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [8]))
                                        )
                                    
                                    if let selectedImage = selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 200)
                                            .clipped()
                                            .cornerRadius(16)
                                    } else {
                                        VStack(spacing: 12) {
                                            Image(systemName: "camera")
                                                .font(.system(size: 40, weight: .light))
                                                .foregroundColor(.appPrimaryBlue)
                                            
                                            Text("Add Photo")
                                                .font(.bellGothic(16))
                                                .foregroundColor(.appPrimaryBlue)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 20) {
                            FormField(title: "Bag Name", text: $name, placeholder: "Enter bag name")
                            
                            VStack(spacing: 12) {
                                Text("Size")
                                    .font(.bellGothic(18, weight: .bold))
                                    .foregroundColor(.appDarkBlue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Picker("Size", selection: $selectedSize) {
                                    ForEach(BagSize.allCases, id: \.self) { size in
                                        Text(size.displayName)
                                            .font(.bellGothic(16))
                                            .tag(size)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            VStack(spacing: 12) {
                                Text("Style")
                                    .font(.bellGothic(18, weight: .bold))
                                    .foregroundColor(.appDarkBlue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Picker("Style", selection: $selectedStyle) {
                                    ForEach(BagStyle.allCases, id: \.self) { style in
                                        Text(style.displayName)
                                            .font(.bellGothic(16))
                                            .tag(style)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            FormField(title: "Suitable For", text: $suitableFor, placeholder: "e.g., work, casual, evening")
                            
                            FormField(title: "Notes (Optional)", text: $notes, placeholder: "Additional notes...", isMultiline: true)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(bagToEdit == nil ? "New Bag" : "Edit Bag")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.bellGothic(16))
                    .foregroundColor(.appPrimaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBag()
                    }
                    .font(.bellGothic(16, weight: .bold))
                    .foregroundColor(isFormValid ? .appDarkBlue : .gray)
                    .disabled(!isFormValid)
                }
            }
        }
        .onAppear {
            loadBagData()
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Select Photo"),
                buttons: [
                    .default(Text("Camera")) {
                        imageSourceType = .camera
                        showingImagePicker = true
                    },
                    .default(Text("Photo Library")) {
                        imageSourceType = .photoLibrary
                        showingImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: imageSourceType)
        }
    }
    
    private func loadBagData() {
        if let bag = bagToEdit {
            name = bag.name
            selectedSize = bag.size
            selectedStyle = bag.style
            suitableFor = bag.suitableFor
            notes = bag.notes
            selectedImage = bag.image
        }
    }
    
    private func saveBag() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        if let bagToEdit = bagToEdit {
            var updatedBag = bagToEdit
            updatedBag.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedBag.size = selectedSize
            updatedBag.style = selectedStyle
            updatedBag.suitableFor = suitableFor.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedBag.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedBag.imageData = imageData
            
            bagStore.updateBag(updatedBag)
        } else {
            let newBag = Bag(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                imageData: imageData,
                size: selectedSize,
                style: selectedStyle,
                suitableFor: suitableFor.trimmingCharacters(in: .whitespacesAndNewlines),
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            bagStore.addBag(newBag)
        }
        
        dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.bellGothic(18, weight: .bold))
                .foregroundColor(.appDarkBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if isMultiline {
                TextEditor(text: $text)
                    .font(.bellGothic(16))
                    .foregroundColor(.appTextDark)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 80)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.appCardBackground)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            } else {
                TextField(placeholder, text: $text)
                    .font(.bellGothic(16))
                    .foregroundColor(.appTextDark)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.appCardBackground)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
