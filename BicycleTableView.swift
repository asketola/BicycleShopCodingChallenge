//
//  BicycleTableView.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/14/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit

class BicycleTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var storeNameText: UILabel!
    @IBOutlet weak var typesOfBikesTableView: UITableView!
    
    var bikeObjects = NSMutableArray()
    var santaCruzBikeArray = [["bikeBrandNameText":"Santa Cruz", "bikeModelText":"Chameleon", "bikePriceText":"$1,649", "bikeImage":"chameleon-web_0.png"], ["bikeBrandNameText":"Santa Cruz", "bikeModelText":"Highball 27.5", "bikePriceText":"$2,799", "bikeImage":"highball275-blue-web_1.png"], ["bikeBrandNameText":"Santa Cruz", "bikeModelText":"Highball 29", "bikePriceText":"$1,649", "bikeImage":"highball-29-black-web_0.png"], ["bikeBrandNameText":"Santa Cruz", "bikeModelText":"Superlight", "bikePriceText":"$1,999", "bikeImage":"superlight-web_0.png"], ["bikeBrandNameText":"Santa Cruz", "bikeModelText":"Tallboy", "bikePriceText":"$2,849", "bikeImage":"tallboy-red-web_0.png"], ["bikeBrandNameText":"Santa Cruz", "bikeModelText":"5010", "bikePriceText":"$3,049", "bikeImage":"5010-orange-web.png"], ["bikeBrandNameText":"Santa Cruz", "bikeModelText":"Heckler", "bikePriceText":"$2,299", "bikeImage":"heckler-web_0.png"], ["bikeBrandNameText":"Santa Cruz", "bikeModelText":"Bronson", "bikePriceText":"$3,099", "bikeImage":"bronson-green-web_2.png"], ["bikeBrandNameText":"Santa Cruz", "bikeModelText":"Nomad", "bikePriceText":"$5,199", "bikeImage":"nomad-green-web_0.png"], ["bikeBrandNameText":"Santa Cruz", "bikeModelText":"V10 CC", "bikePriceText":"$5,699", "bikeImage":"v10cc-white-web_1.png"]]
    
    var bicycle = Bicycle()
    var bikeObject = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "BicycleTableViewCell", bundle: nil)
        typesOfBikesTableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        self.typesOfBikesTableView.rowHeight = 120.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return santaCruzBikeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:BicycleTableViewCell = self.typesOfBikesTableView.dequeueReusableCellWithIdentifier("cell") as! BicycleTableViewCell
        self.bikeObject = santaCruzBikeArray[indexPath.row] // as NSDictionary
//        let bicycle = santaCruzBikeArray[indexPath.row] as Bicycle()
        cell.bikeBrandNameText.text = bikeObject["bikeBrandNameText"] as? String
        cell.bikeModelText.text = bikeObject["bikeModelText"] as? String
        cell.bikepriceText.text = bikeObject["bikePriceText"] as? String
        let bikeImageUIimage = bikeObject["bikeImage"] as! String
        let bikeImageUIimage1 = UIImage(named: bikeImageUIimage)
        cell.bikeImage.image = bikeImageUIimage1
        
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.bikeObject = santaCruzBikeArray[indexPath.row]
        println("You selected a cell #\(indexPath.row)!")
        println("\(santaCruzBikeArray[indexPath.row])")
        performSegueWithIdentifier("SHOW_BIKE_DETAIL", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("We got here")
            if segue.identifier == "SHOW_BIKE_DETAIL" {
            
            let detailedVC = segue.destinationViewController as! ProductDetailsViewController
            detailedVC.bicycleData = bikeObject
      }
    }


}
