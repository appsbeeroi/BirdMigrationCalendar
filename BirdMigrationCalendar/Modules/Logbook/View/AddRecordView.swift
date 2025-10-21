import SwiftUI

struct AddRecordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: LogBookViewModel
    
    @State var record: LogRecord
    @State var isDateChoosed: Bool
    
    @State private var isShowImagePicker = false
    @State private var isShowDatePicker = false
    @State private var isLoading = false
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Image(.Images.mainBG)
                .adoptImage()
            
            VStack(spacing: 20) {
                navigation
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        imageSelector
                        speciesInput
                        dateSelector
                        noteInput
                        rarityInput
                    }
                    .padding(.horizontal, 35)
                }
            }
            
            if isShowDatePicker {
                datePicker
            }
            
            if isLoading {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.white)
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .animation(.smooth, value: isShowDatePicker)
        .sheet(isPresented: $isShowImagePicker) {
            ImagePicker(selectedImage: $record.image)
        }
    }
    
    private var navigation: some View {
        ZStack {
            StrokedText(text: "Logbook", fontSize: 35)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Circle()
                        .frame(width: 42, height: 42)
                        .foregroundStyle(.white.opacity(0.5))
                        .overlay {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.bmcBlue)
                        }
                }
                
                Spacer()
                
                Button {
                    isLoading = true
                    viewModel.save(record)
                } label: {
                    Circle()
                        .frame(width: 42, height: 42)
                        .foregroundStyle(.white.opacity(0.5))
                        .overlay {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.bmcBlue)
                        }
                        .opacity(record.isLock ? 0.5 : 1)
                }
                .disabled(record.isLock)
            }
        }
        .padding(.horizontal, 35)
        .padding(.top, 20)
    }
    
    private var imageSelector: some View {
        HStack {
            Button {
                isShowImagePicker.toggle()
            } label: {
                ZStack {
                    if let image = record.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 116, height: 116)
                            .clipped()
                            .cornerRadius(24)
                    } else {
                        RoundedRectangle(cornerRadius: 24)
                            .frame(width: 116, height: 116)
                            .foregroundStyle(.white)
                    }
                    
                    Image(systemName: "photo")
                        .font(.system(size: 58, weight: .medium))
                        .foregroundStyle(.bmcGray)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var speciesInput: some View {
        DefaultTextFieldView(placeholder: "Bird Species", text: $record.species, isFocused: $isFocused)
    }
    
    private var dateSelector: some View {
        Button {
            isShowDatePicker.toggle()
            isDateChoosed = true 
        } label: {
            HStack {
                let date = record.date.formatted(.dateTime.year().month(.twoDigits).day())
                
                Text(isDateChoosed ? date : "Migration Date")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.poller(with: 16))
                    .foregroundStyle(.bmcDarkBrown)
                
                
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .background(.white)
            .cornerRadius(20)
        }
    }
    
    private var noteInput: some View {
        DefaultTextFieldView(placeholder: "Note", text: $record.note, isFocused: $isFocused)
    }
    
    private var rarityInput: some View {
        VStack {
            Text("Rarity")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poller(with: 14))
            
            HStack {
                ForEach(BirdStatus.allCases) { status in
                    Button {
                        record.rarity = status
                    } label: {
                        Text(status.title)
                            .frame(height: 42)
                            .padding(.horizontal, 12)
                            .font(.poller(with: 14))
                            .foregroundStyle(record.rarity == status ? .white : .bmcDarkBrown)
                            .background(record.rarity == status ? .bmcBlue : .white)
                            .cornerRadius(36)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var datePicker: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Done") {
                        isShowDatePicker = false
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                
                DatePicker("", selection: $record.date, displayedComponents: [.date])
                    .labelsHidden()
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
            }
            .padding(.horizontal, 35)
        }
    }
}

#Preview {
    AddRecordView(record: LogRecord(isMock: true), isDateChoosed: true)
}

