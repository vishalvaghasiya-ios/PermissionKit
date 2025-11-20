import SwiftUI
import DialCodeKit

struct ContentView: View {
    @State private var selectedCountry: Country?
    @State private var isPresented = false

    var body: some View {
        VStack(spacing: 20) {
            
            if let selectedCountry {
                HStack {
                    Text("\(selectedCountry.name) \(selectedCountry.dialCode)")
                        .font(.title3)
                }
            } else {
                Text("No country selected")
                    .foregroundColor(.gray)
            }
            
            Button("Open Country Picker") {
                isPresented = true
            }
            .font(.title2)
            .padding()
        }
        .sheet(isPresented: $isPresented) {
            CountryPicker.view(
                config: CountryPickerConfig(
                    displayMode: .countryFlagAndCode,
                    showSearch: true,
                    showIndexBar: true,
                    title: "Select Country"
                ),
                onSelect: { country in
                    selectedCountry = country.country
                    isPresented = false
                },
                onCancel: {
                    isPresented = false
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
