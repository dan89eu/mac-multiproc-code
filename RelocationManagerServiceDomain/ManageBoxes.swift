//
//  ManageBoxes.swift
//  RelocationManager
//
//  Created by Christian Tietze on 04/03/15.
//  Copyright (c) 2015 Christian Tietze. All rights reserved.
//

import Foundation

public class ManageBoxes {
    public lazy var provisioningService: ProvisioningService = DomainRegistry.sharedInstance.provisioningService()
    public lazy var boxRepository: BoxRepository = ServiceLocator.boxRepository()
    public lazy var dissolvingService: DissolveBox = DomainRegistry.sharedInstance.dissolveBox()
    
    public init() { }
    
    public func orderBox(label: String, capacity: Int) {
        if let boxCapacity = BoxCapacity(rawValue: capacity) {
            provisioningService.provisionBox(label, capacity: boxCapacity)
        }
    }
    
    public func removeBox(boxIdentifier: IntegerId) {
        let boxId = BoxId(boxIdentifier)
        if let box = boxRepository.box(boxId: boxId) {
            dissolvingService.dissolve(box)
        }
    }
}
