//
//  PlaceAnnotation.swift
//  BNomad
//
//  Created by Youngwoong Choi on 2022/10/19.
//

import Foundation
import MapKit

class CoworkingAnnotationView: MKMarkerAnnotationView {
    
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
        markerTintColor = .systemPink
        glyphImage = UIImage(systemName: "laptopcomputer")
    }
}


class LibraryAnnotationView: MKMarkerAnnotationView {
    
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


class CafePlaceAnnotationView: MKMarkerAnnotationView {
    
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

