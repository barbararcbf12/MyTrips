//
//  HomeTableViewController.swift
//  MyTrips
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var places: [ Dictionary<String,String> ] = []
    var navigationControl = "add"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationControl = "add"
        updateTrips()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //open place on map by clicking table list item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationControl = "list"
        performSegue( withIdentifier: "seePlace", sender: indexPath.row )
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seePlace" {
            let viewControllerDestination = segue.destination as! ViewController
            if self.navigationControl == "list" {
                if let retrievedIndex = sender {
                    let index = retrievedIndex as! Int
                    viewControllerDestination.trip = places[ index ]
                    viewControllerDestination.selectedIndex = index
                }
            }else {
                viewControllerDestination.trip = [:]
                viewControllerDestination.selectedIndex = -1
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #return the number of rows equal to number of emelents in places array
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configuring the prototype cell
        let trip = places[ indexPath.row]["place"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath)
        cell.textLabel?.text = trip

        return cell
    }
    
    func updateTrips(){
        places = StoreData().listTrips() //reloading everytime changes screen
        tableView.reloadData()
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            StoreData().removeTrip( index: indexPath.row )
            updateTrips()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
