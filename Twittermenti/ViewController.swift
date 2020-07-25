//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import CoreML
import SwifteriOS
import SwiftyJSON

class ViewController: UIViewController {

	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var sentimentLabel: UILabel!

	let ENGLISH_LANG = "en"
	let TWITS_COUNT = 100

	let sentimentClassifier = TweetSentimentClassifier()

	// Instantiation using Twitter's OAuth Consumer Key and secret
	let swifter: Swifter = Swifter(consumerKey: PlistManager.getApiKey()!, consumerSecret: PlistManager.getApiSecret()!)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func predictPressed(_ sender: Any) {
		fetchTweetsAndMakePrediction()
    }

	private func fetchTweetsAndMakePrediction() {

		guard let query = textField.text, query.count > 0 else {
			print ("Empty query")
			return
		}

		swifter.searchTweet(using: query, lang: ENGLISH_LANG, count: TWITS_COUNT, tweetMode: .extended, success: { (results, metadata) in

			var tweets = [TweetSentimentClassifierInput]()

			for i in 0..<self.TWITS_COUNT {
				if let tweet = results[i]["full_text"].string {
					print("\(tweet) - \(self.getScore(label: tweet))")
					tweets.append(TweetSentimentClassifierInput(text: tweet))
				}
			}
			self.makePrediction(with: tweets)
		}) { (error) in
			print("There was an error with Twitter API request: \(error.localizedDescription)")
		}

		
	}
}

extension ViewController {
	// MARK: - Model's Prediction Label
	enum PredictionLabel {

		case positive
		case negative
		case neutral

		var stringValue: String {
			switch self {
			case .positive:
				return "Pos"
			case .negative:
				return "Neg"
			case .neutral:
				return "Neutral"
			}
		}
	}

	private func getScore(label: String)-> Int {
		switch label {
		case PredictionLabel.positive.stringValue:
			return 1
		case PredictionLabel.negative.stringValue:
			return -1
		default:
			return 0
		}
	}

	//MARK: Make prediction
	private func makePrediction(with: [TweetSentimentClassifierInput]) {
		do {
			let predictions = try self.sentimentClassifier.predictions(inputs: with)

			var sentimentScore: Int = 0

			for prediction in predictions {
				sentimentScore += self.getScore(label: prediction.label)
			}

			updateUI(score: sentimentScore)
			print(sentimentScore)
		} catch {
			print("There was an error with Twitter API request: \(error.localizedDescription)")
		}
	}

	//MARK: Update UI
	private func updateUI(score: Int) {
		if score > 20 {
			sentimentLabel.text = "🥰"
		} else if score > 10 {
			sentimentLabel.text = "😌"
		} else if score > 0 {
			sentimentLabel.text = "🤨"
		} else if score > -5 {
			sentimentLabel.text = "😕"
		} else {
			sentimentLabel.text = "☹️"
		}
	}
}

