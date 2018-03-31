//
//  StoreData.swift
//  MyTrips
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit

//create, save and remove trips
class StoreData {
    
    let storeKey = "tripPlaces"
    var trips: [Dictionary<String,String>] = []
    
    func getDefaults() -> UserDefaults {
        
        return UserDefaults.standard
        
    }
    
    func saveTrip( trip: Dictionary<String,String> ){
        
        trips = listTrips()
        
        trips.append( trip )
        
        getDefaults().set( trips, forKey: storeKey )
        getDefaults().synchronize() //automatize sync
        
    }
    
    func listTrips() -> [ Dictionary<String,String> ] {
        
        let data = getDefaults().object( forKey: storeKey )
        if data != nil {
            return data as! Array
        }else {
            return []
        }
        
    }
    
    func removeTrip(index: Int){
        
        trips = listTrips()
        trips.remove(at: index)
        
        getDefaults().set( trips, forKey: storeKey )
        getDefaults().synchronize() //automatize sync
        
    }
    
}
