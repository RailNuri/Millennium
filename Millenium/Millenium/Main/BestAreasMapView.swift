import SwiftUI
import MapKit

struct BestAreasView: View {
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.4093, longitude: 49.8671),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var cardOffset: CGFloat = 400 
    
    let bestAreaHexes = [
        AreaHex(color: .green, lat: 40.415, lon: 49.860, rotation: 45),
        AreaHex(color: .green, lat: 40.412, lon: 49.865, rotation: 30),
        AreaHex(color: .green, lat: 40.410, lon: 49.870, rotation: 0),
        AreaHex(color: .green, lat: 40.407, lon: 49.868, rotation: 15),
        AreaHex(color: .green, lat: 40.405, lon: 49.872, rotation: 45),
        AreaHex(color: .green, lat: 40.402, lon: 49.875, rotation: 30),
        AreaHex(color: .green, lat: 40.400, lon: 49.878, rotation: 60),
        AreaHex(color: .green, lat: 40.398, lon: 49.880, rotation: 20),
        AreaHex(color: .green, lat: 40.417, lon: 49.863, rotation: 10),
        AreaHex(color: .green, lat: 40.403, lon: 49.867, rotation: 40),
    ]
    
    var body: some View {
        ZStack {
            DarkMapWithHexes(region: $mapRegion, hexes: bestAreaHexes)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Circle()
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                Spacer()
                
                VStack(spacing: 0) {
                    // Drag Handle
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                    
                    Text("Best Areas for You")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 60, height: 4)
                        .padding(.top, 8)
                    
                    Text("87%")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.top, 20)
                    
                    Text("Match")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    
                    Text("Based on your preferences for location,\namenitites, and lifestyle factors")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 12)
                        .padding(.horizontal, 30)
                    
                    // Heat Map Legend
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Heat Map Legend")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 12, height: 12)
                                Text("Best Fit")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.yellow)
                                    .frame(width: 12, height: 12)
                                Text("Moderate")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)
                                Text("Low Fit")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(white: 0.15))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    // View Houses Button
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("View Houses")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.green)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 30)
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                )
                .offset(y: cardOffset)
                .animation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0), value: cardOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newOffset = cardOffset + value.translation.height
                            if newOffset < 0 {
                                cardOffset = newOffset * 0.3
                            } else if newOffset > 400 {
                                cardOffset = 400 + (newOffset - 400) * 0.3
                            } else {
                                cardOffset = newOffset
                            }
                        }
                        .onEnded { value in
                            let velocity = value.predictedEndLocation.y - value.location.y
                            
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                if velocity < -100 {
                                    // Fast swipe up
                                    cardOffset = 0
                                } else if velocity > 100 {
                                    // Fast swipe down
                                    cardOffset = 400
                                } else if cardOffset < 200 {
                                    cardOffset = 0
                                } else {
                                    cardOffset = 400
                                }
                            }
                        }
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        if cardOffset > 200 {
                            cardOffset = 0
                        } else {
                            cardOffset = 400
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 80)
            }
        }
    }
}

struct DarkMapWithHexes: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    let hexes: [AreaHex]
    
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
        
        for hex in hexes {
            let overlay = AreaHexOverlay(coordinate: CLLocationCoordinate2D(latitude: hex.lat, longitude: hex.lon),
                                         color: hex.color,
                                         rotation: hex.rotation)
            mapView.addOverlay(overlay)
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(self)
    }
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        var parent: DarkMapWithHexes
        
        init(_ parent: DarkMapWithHexes) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let hexOverlay = overlay as? AreaHexOverlay {
                let renderer = AreaHexRenderer(overlay: hexOverlay)
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

class AreaHexOverlay: NSObject, MKOverlay {
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

class AreaHexRenderer: MKOverlayRenderer {
    let hexOverlay: AreaHexOverlay
    
    init(overlay: AreaHexOverlay) {
        self.hexOverlay = overlay
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let point = self.point(for: MKMapPoint(hexOverlay.coordinate))
        
        let size: CGFloat = 60 / zoomScale
        let path = createHexPath(center: point, size: size, rotation: hexOverlay.rotation)
        
        context.setFillColor(hexOverlay.color.withAlphaComponent(0.6).cgColor)
        context.setStrokeColor(hexOverlay.color.withAlphaComponent(0.8).cgColor)
        context.setLineWidth(2 / zoomScale)
        
        context.addPath(path)
        context.drawPath(using: .fillStroke)
    }
    
    func createHexPath(center: CGPoint, size: CGFloat, rotation: Double) -> CGPath {
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

struct AreaHex: Identifiable {
    let id = UUID()
    let color: Color
    let lat: Double
    let lon: Double
    let rotation: Double
}

#Preview {
    BestAreasView()
}
