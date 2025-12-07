import SwiftUI
import MapKit

struct MapSearchView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.4093, longitude: 49.8671),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var searchText = ""
    @State private var isBottomSheetExpanded = false
    @State private var selectedProperty: MapProperty? = nil
    @State private var navigateToDetails = false
    
    let mapProperties = [
        MapProperty(lat: 40.4093, lon: 49.8671, price: "520K", rating: 9.5, color: .green),
        MapProperty(lat: 40.4105, lon: 49.8685, price: "480K", rating: 9.2, color: .green),
        
        MapProperty(lat: 40.4120, lon: 49.8700, price: "410K", rating: 8.5, color: .orange),
        MapProperty(lat: 40.4065, lon: 49.8700, price: "380K", rating: 8.1, color: .orange),
        MapProperty(lat: 40.4093, lon: 49.8622, price: "390K", rating: 8.3, color: .orange),
        
        MapProperty(lat: 40.4140, lon: 49.8715, price: "290K", rating: 7.2, color: .red),
        MapProperty(lat: 40.4045, lon: 49.8715, price: "310K", rating: 7.5, color: .red),
        MapProperty(lat: 40.4070, lon: 49.8592, price: "280K", rating: 7.0, color: .red),
    ]
    let properties = [
        Property(address: "28 May Street, Nasimi", price: "₼ 450,000", feature: "Sea view, 3 bedrooms", imageName: "house1"),
        Property(address: "Nizami Street, Center", price: "₼ 380,000", feature: "City center, renovated", imageName: "house2"),
        Property(address: "Fountain Square Area", price: "₼ 520,000", feature: "Luxury, 4 bedrooms", imageName: "house3"),
        Property(address: "Khagani Street, Old City", price: "₼ 290,000", feature: "Historical area, 2 bedrooms", imageName: "house4"),
    ]
    
    let hexLocations = [
        HexLocation(color: .green, lat: 40.4093, lon: 49.8671, rotation: 0),
        HexLocation(color: .green, lat: 40.4105, lon: 49.8685, rotation: 30),
        HexLocation(color: .green, lat: 40.4081, lon: 49.8685, rotation: 60),
        
        HexLocation(color: .orange, lat: 40.4120, lon: 49.8700, rotation: 15),
        HexLocation(color: .orange, lat: 40.4093, lon: 49.8720, rotation: 45),
        HexLocation(color: .orange, lat: 40.4065, lon: 49.8700, rotation: 30),
        HexLocation(color: .orange, lat: 40.4065, lon: 49.8642, rotation: 0),
        HexLocation(color: .orange, lat: 40.4093, lon: 49.8622, rotation: 60),
        HexLocation(color: .orange, lat: 40.4120, lon: 49.8642, rotation: 20),
        
        HexLocation(color: .red, lat: 40.4140, lon: 49.8715, rotation: 45),
        HexLocation(color: .red, lat: 40.4120, lon: 49.8750, rotation: 30),
        HexLocation(color: .red, lat: 40.4070, lon: 49.8750, rotation: 15),
        HexLocation(color: .red, lat: 40.4045, lon: 49.8715, rotation: 60),
        HexLocation(color: .red, lat: 40.4045, lon: 49.8627, rotation: 0),
        HexLocation(color: .red, lat: 40.4070, lon: 49.8592, rotation: 45),
        HexLocation(color: .red, lat: 40.4120, lon: 49.8592, rotation: 30),
        HexLocation(color: .red, lat: 40.4140, lon: 49.8627, rotation: 15),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapWithHexagonsAndProperties(
                    region: $region,
                    hexLocations: hexLocations,
                    mapProperties: mapProperties,
                    selectedProperty: $selectedProperty
                )
                .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search neighborhoods, cities...", text: $searchText)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 5)
                            .padding(.top, 10)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("See recommended areas")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: isBottomSheetExpanded ? "chevron.down" : "chevron.up")
                                    .foregroundColor(.gray)
                            }
                            Text("Based on your preferences")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isBottomSheetExpanded.toggle()
                            }
                        }
                        
                        if isBottomSheetExpanded {
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(properties) { property in
                                        PropertyCard(property: property)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                            }
                            .frame(height: 300)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .offset(y: isBottomSheetExpanded ? 0 : 0)
                    .padding(.bottom,35)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            Button(action: {}) {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                            }
                        }
                        .padding(.trailing)
                        .padding(.bottom, 200)
                    }
                }
                
                NavigationLink(
                    destination: HouseDetailsView(),
                    isActive: $navigateToDetails
                ) {
                    EmptyView()
                }
            }
            .onChange(of: selectedProperty) { newValue in
                if newValue != nil {
                    navigateToDetails = true
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct MapProperty: Identifiable, Equatable {
    let id = UUID()
    let lat: Double
    let lon: Double
    let price: String
    let rating: Double
    let color: Color
    
    static func == (lhs: MapProperty, rhs: MapProperty) -> Bool {
        lhs.id == rhs.id
    }
}

struct MapWithHexagonsAndProperties: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    let hexLocations: [HexLocation]
    let mapProperties: [MapProperty]
    @Binding var selectedProperty: MapProperty?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        
        // Set dark theme
        mapView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .flat)
        if let config = mapView.preferredConfiguration as? MKStandardMapConfiguration {
            config.pointOfInterestFilter = .excludingAll
            config.showsTraffic = false
        }
        mapView.overrideUserInterfaceStyle = .dark
        
        for hex in hexLocations {
            let overlay = HexagonOverlay(coordinate: CLLocationCoordinate2D(latitude: hex.lat, longitude: hex.lon),
                                         color: hex.color,
                                         rotation: hex.rotation)
            mapView.addOverlay(overlay)
        }
        
        for property in mapProperties {
            let annotation = PropertyAnnotation(property: property)
            mapView.addAnnotation(annotation)
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapWithHexagonsAndProperties
        
        init(_ parent: MapWithHexagonsAndProperties) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let hexOverlay = overlay as? HexagonOverlay {
                let renderer = HexagonRenderer(overlay: hexOverlay)
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let propertyAnnotation = annotation as? PropertyAnnotation else {
                return nil
            }
            
            let identifier = "PropertyAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
            } else {
                annotationView?.annotation = annotation
            }
            
            let propertyView = PropertyMapCardView(property: propertyAnnotation.property) {
                self.parent.selectedProperty = propertyAnnotation.property
            }
            let hostingController = UIHostingController(rootView: propertyView)
            hostingController.view.backgroundColor = .clear
            
            annotationView?.frame = CGRect(x: 0, y: 0, width: 80, height: 90)
            annotationView?.addSubview(hostingController.view)
            hostingController.view.frame = annotationView!.bounds
            
            return annotationView
        }
    }
}

class PropertyAnnotation: NSObject, MKAnnotation {
    let property: MapProperty
    var coordinate: CLLocationCoordinate2D
    
    init(property: MapProperty) {
        self.property = property
        self.coordinate = CLLocationCoordinate2D(latitude: property.lat, longitude: property.lon)
    }
}

struct PropertyMapCardView: View {
    let property: MapProperty
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                // Card
                VStack(spacing: 6) {
                    // House icon
                    Image(systemName: "house.fill")
                        .font(.system(size: 16))
                        .foregroundColor(property.color)
                    
                    // Price
                    Text("₼\(property.price)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Rating
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", property.rating))
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.85))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(property.color.opacity(0.6), lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }
}

class HexagonOverlay: NSObject, MKOverlay {
    let coordinate: CLLocationCoordinate2D
    let color: UIColor
    let rotation: Double
    var boundingMapRect: MKMapRect {
        let point = MKMapPoint(coordinate)
        let size = MKMapSize(width: 5000, height: 5000)
        return MKMapRect(origin: MKMapPoint(x: point.x - size.width/2, y: point.y - size.height/2), size: size)
    }
    
    init(coordinate: CLLocationCoordinate2D, color: Color, rotation: Double) {
        self.coordinate = coordinate
        self.color = UIColor(color)
        self.rotation = rotation
    }
}

class HexagonRenderer: MKOverlayRenderer {
    let hexOverlay: HexagonOverlay
    
    init(overlay: HexagonOverlay) {
        self.hexOverlay = overlay
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let point = self.point(for: MKMapPoint(hexOverlay.coordinate))
        
        let size: CGFloat = 100 / zoomScale
        let path = createHexagonPath(center: point, size: size, rotation: hexOverlay.rotation)
        
        context.setFillColor(hexOverlay.color.withAlphaComponent(0.6).cgColor)
        context.setStrokeColor(hexOverlay.color.withAlphaComponent(0.8).cgColor)
        context.setLineWidth(2 / zoomScale)
        
        context.addPath(path)
        context.drawPath(using: .fillStroke)
    }
    
    func createHexagonPath(center: CGPoint, size: CGFloat, rotation: Double) -> CGPath {
        let path = CGMutablePath()
        let angleOffset = rotation * .pi / 180
        
        for i in 0..<6 {
            let angle = (CGFloat(i) * .pi / 3) + CGFloat(angleOffset)
            let x = center.x + size * cos(angle)
            let y = center.y + size * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        return path
    }
}

struct HexLocation: Identifiable {
    let id = UUID()
    let color: Color
    let lat: Double
    let lon: Double
    let rotation: Double
}

struct Property: Identifiable {
    let id = UUID()
    let address: String
    let price: String
    let feature: String
    let imageName: String
}

struct PropertyCard: View {
    let property: Property
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(property.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(property.address)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(property.price)
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text(property.feature)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    MapSearchView()
}
