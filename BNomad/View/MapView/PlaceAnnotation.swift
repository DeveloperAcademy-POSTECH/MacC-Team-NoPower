//
//  PlaceAnnotation.swift
//  BNomad
//
//  Created by Youngwoong Choi on 2022/10/19.
//

import Foundation
import MapKit

// TODO: - nil 전용 annotation 추가하기

class CoworkingAnnotationView: PlaceAnnotationView {
    
    static let ReuseID = "coworkingAnnotaion"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "working"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = CustomColor.nomadBlue
        glyphImage = UIImage(systemName: "laptopcomputer")
    }
}


class LibraryAnnotationView: PlaceAnnotationView {
    
    static let ReuseID = "libraryAnnotaion"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "working"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = .systemTeal
        glyphImage = UIImage(systemName: "books.vertical")
    }
}


class CafePlaceAnnotationView: PlaceAnnotationView {
    
    static let ReuseID = "cafeAnnotaion"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "cafe"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = .systemBrown
        glyphImage = UIImage(systemName: "cup.and.saucer")
    }
}

class PlaceAnnotationView: MKMarkerAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
