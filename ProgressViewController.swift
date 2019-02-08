//
//  ProgressViewController.swift
//  SoccerTraccer
//
//  Created by Chris Carbajal on 11/6/18.
//  Copyright © 2018 Chris Carbajal. All rights reserved.
//

import UIKit
import CoreData
import Charts
import SafariServices


class ProgressViewController: UIViewController {

    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var totalGoalsLabel: UILabel!
    
    @IBOutlet weak var totalAssistsLabel: UILabel!
    
    @IBOutlet weak var totalMinutesLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    @IBOutlet weak var weatherResultLabel: UILabel!
    
    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet weak var pieChart: PieChartView!
    
    var gameContributions : [Double] = []
    var conditions : [Bool] = []
    var totalGoals : Int?
    var totalAssists : Int?
    var totalMinutes : Double?
    var goodWeatherEntry = PieChartDataEntry(value: 0)
    var badWeatherEntry = PieChartDataEntry(value: 0)
    var weatherConditionEntries = [PieChartDataEntry]()
    
    @IBAction func showPop(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    
    }
    
    @IBAction func openWeather(_ sender: Any) {
            let url = URL(string: "https://www.accuweather.com/en/weather-news/how-does-weather-impact-the-sport-of-soccer/70005170"
        )
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true, completion: nil)
    }
    
    func getResults(){
        let gs = GameStats()
        let call = gs.calcStats()
        let analysisCall = gs.result()
        resultLabel.text = analysisCall.0
        weatherResultLabel.text = analysisCall.1
        if analysisCall.0 == ""{
            emptyLabel.text = "Please enter Stats by clicking on the soccer ball at the home page."
        }
        totalGoals = call.0
        totalAssists = call.1
        totalMinutes = call.2
        gameContributions = call.3
        conditions = call.4
    }
    
    func colorPicker(value : Double) -> NSUIColor {
        if value > 0.5 && value < 1.0 {
            return NSUIColor.red
        }
        else {
            return NSUIColor.black
        }
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor .clear
    }
    
    override func viewDidLoad() {
        getResults()
        totalGoalsLabel.text = totalGoals?.description
        totalAssistsLabel.text = totalAssists?.description
        totalMinutesLabel.text = totalMinutes?.description
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor .darkGray

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.view.insertSubview(backgroundImage, at: 0)
        lineChart.borderColor = UIColor .white
        lineChart.backgroundColor = UIColor(hue: 0.0528, saturation: 0, brightness: 0.89, alpha: 1.0)
        updateGraph()
        pieChart.data?.setValueTextColor(NSUIColor.darkGray)
        pieChart.backgroundColor =
            UIColor(hue: 0.0528, saturation: 0, brightness: 0.89, alpha: 1.0)
        updatePieChart()
    }
    
    
    
    func updateGraph(){
        var lineChartEntry = [ChartDataEntry]()
        var circleColors = [NSUIColor]()
        for i in 0..<gameContributions.count{
            let value = ChartDataEntry(x: Double(i), y: Double(gameContributions[i]))
            lineChartEntry.append(value)
            if conditions[i] == true {
                circleColors.append(UIColor(hue: 0.5611, saturation: 0.86, brightness: 0.72, alpha: 1.0))
            }else{
                circleColors.append(UIColor(hue: 0, saturation: 0.72, brightness: 0.7, alpha: 1.0))
            }
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Goal contribution per minute")
        line1.colors = [NSUIColor.darkGray]
        line1.circleHoleColor = UIColor .lightGray
        line1.circleColors = circleColors
        let data = LineChartData()
        data.addDataSet(line1)
        lineChart.data = data
        lineChart.data?.setValueTextColor(NSUIColor.black)
        lineChart.chartDescription?.text = "Goal Chart"
    }
    func updatePieChart(){
        for i in 0..<conditions.count{
            if conditions[i] == true{
                goodWeatherEntry.value += Double(1)
                goodWeatherEntry.label = "good"
            }else {
                badWeatherEntry.value += Double(1)
                badWeatherEntry.label = "bad"
            }
        }
        weatherConditionEntries = [goodWeatherEntry,badWeatherEntry]
        let chartDataSet = PieChartDataSet(values: weatherConditionEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartData.setValueTextColor(NSUIColor .black)
        let colors =  [UIColor(hue: 0.5611, saturation: 0.86, brightness: 0.72, alpha: 1.0), UIColor(hue: 0, saturation: 0.72, brightness: 0.7, alpha: 1.0) ]
        chartDataSet.colors = colors
        pieChart.data?.setValueTextColor(NSUIColor.darkGray)
        pieChart.data = chartData
        pieChart.centerText = "Game"
    }
}
