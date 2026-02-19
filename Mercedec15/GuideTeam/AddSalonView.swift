import SwiftUI

struct AddSalonView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (SPASalon) -> Void
    
    @State private var name = ""
    @State private var rating = 4.0
    @State private var reviewCount = "0"
    @State private var distance = 1.0
    @State private var priceRange: PriceRange = .moderate
    @State private var hasDiscount = false
    @State private var discountPercentage = "10"
    @State private var services: [SPAService] = []
    @State private var showingAddService = false
    @State private var salonImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        spaImageSection
                        basicInfoSection
                        
                        priceSection
                        
                        servicesSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Add Salon")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSalon()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                    .fontWeight(.semibold)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingAddService) {
            AddServiceView { service in
                services.append(service)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $salonImage)
        }
    }
    
    private var spaImageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SPA Image")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            Button(action: { showingImagePicker = true }) {
                ZStack {
                    if let image = salonImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(ColorTheme.primaryPurple.opacity(0.3))
                            .frame(height: 200)
                        
                        VStack(spacing: 8) {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(ColorTheme.secondaryText)
                            Text("Tap to add photo")
                                .font(.playfairRegular(size: 14))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                    }
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorTheme.cardBorder, lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Info")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Salon Name")
                    .font(.playfairSemiBold(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
                TextField("Enter salon name", text: $name)
                    .font(.playfairRegular(size: 16))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(16)
                    .background(ColorTheme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Rating")
                        .font(.playfairSemiBold(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    HStack {
                        Slider(value: $rating, in: 0...5, step: 0.1)
                            .accentColor(ColorTheme.primaryPurple)
                        Text(String(format: "%.1f", rating))
                            .font(.playfairSemiBold(size: 16))
                            .foregroundColor(ColorTheme.primaryText)
                            .frame(width: 36)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reviews")
                        .font(.playfairSemiBold(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    TextField("0", text: $reviewCount)
                        .font(.playfairRegular(size: 16))
                        .foregroundColor(ColorTheme.primaryText)
                        .keyboardType(.numberPad)
                        .padding(16)
                        .background(ColorTheme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(width: 80)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Distance (km)")
                    .font(.playfairSemiBold(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
                Slider(value: $distance, in: 0.1...50, step: 0.1)
                    .accentColor(ColorTheme.primaryPurple)
                Text(String(format: "%.1f km", distance))
                    .font(.playfairRegular(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Price & Discount")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            Picker("Price Range", selection: $priceRange) {
                ForEach(PriceRange.allCases, id: \.self) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .accentColor(ColorTheme.primaryPurple)
            
            Toggle(isOn: $hasDiscount) {
                Text("Has discount")
                    .font(.playfairSemiBold(size: 16))
                    .foregroundColor(ColorTheme.primaryText)
            }
            .toggleStyle(SwitchToggleStyle(tint: ColorTheme.primaryPurple))
            
            if hasDiscount {
                TextField("Discount %", text: $discountPercentage)
                    .font(.playfairRegular(size: 16))
                    .foregroundColor(ColorTheme.primaryText)
                    .keyboardType(.numberPad)
                    .padding(16)
                    .background(ColorTheme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Services")
                    .font(.playfairBold(size: 18))
                    .foregroundColor(ColorTheme.primaryText)
                Spacer()
                Button(action: { showingAddService = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(ColorTheme.primaryPurple)
                }
            }
            
            if services.isEmpty {
                Text("No services added. Tap + to add.")
                    .font(.playfairRegular(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(24)
            } else {
                ForEach(services) { service in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(service.name)
                                .font(.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            Text("\(service.duration) min - $\(Int(service.price))")
                                .font(.playfairRegular(size: 14))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                        Spacer()
                        Text(service.category.rawValue)
                            .font(.playfairRegular(size: 12))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .padding(12)
                    .background(ColorTheme.cardBackground.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func saveSalon() {
        let reviewCountInt = Int(reviewCount) ?? 0
        let discountInt = hasDiscount ? (Int(discountPercentage) ?? 0) : nil
        let salonId = UUID()
        var imageURL = ""
        if let image = salonImage, let filename = ImageStorage.saveSalonImage(image, salonId: salonId) {
            imageURL = filename
        }
        let salon = SPASalon(
            id: salonId,
            name: name.trimmingCharacters(in: .whitespaces),
            rating: rating,
            reviewCount: max(0, reviewCountInt),
            distance: distance,
            imageURL: imageURL,
            availableServices: services.isEmpty ? [SPAService(name: "General Treatment", duration: 60, price: 0, category: .massage, description: "Custom service")] : services,
            priceRange: priceRange,
            hasDiscount: hasDiscount,
            discountPercentage: discountInt
        )
        onSave(salon)
        dismiss()
    }
}

struct AddServiceView: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (SPAService) -> Void
    
    @State private var name = ""
    @State private var duration = "60"
    @State private var price = "80"
    @State private var category: ServiceCategory = .massage
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        TextField("Service name", text: $name)
                            .font(.playfairRegular(size: 16))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        Picker("Category", selection: $category) {
                            ForEach(ServiceCategory.allCases, id: \.self) { cat in
                                Text(cat.rawValue).tag(cat)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(ColorTheme.primaryWhite)
                        
                        HStack(spacing: 16) {
                            TextField("Duration (min)", text: $duration)
                                .font(.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                                .keyboardType(.numberPad)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            TextField("Price", text: $price)
                                .font(.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                                .keyboardType(.decimalPad)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        TextField("Description", text: $description)
                            .font(.playfairRegular(size: 16))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        Spacer(minLength: 40)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Add Service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(ColorTheme.primaryPurple)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let dur = Int(duration) ?? 60
                        let pr = Double(price) ?? 80
                        onAdd(SPAService(name: name.isEmpty ? "Service" : name, duration: dur, price: pr, category: category, description: description))
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                    .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    AddSalonView { _ in }
}
