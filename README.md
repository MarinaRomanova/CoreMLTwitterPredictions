### CoreMLTwitterPredictions
completed tutorial of **CoreML** by *The App Brewery*

### Table of Contents
* [App description](#app-description)
* [Used cocopods and frameworks](#used-cocopods-and-frameworks)
* [Create and Train your model](#create-and-train-your-model)
* [Get Twitter API key](#get-twitter-api-key)

### App description
A simple one page iOS app that takes user's input and queries Twitter's API to get 100 full text tweets in English. 
These tweets are than evaluated by the ML Model to determine whether those tweets are positive, negative or neutral.
Based on the calculated total score an emoji is displayed.

<img src="https://user-images.githubusercontent.com/36896406/88467803-5821ef00-cedb-11ea-97b7-f9c72f484df1.png" height="450"/>

### Used cocopods and frameworks:
- [Swifter](https://github.com/mattdonnelly/Swifter) as a Wrapper for Twitter API calls
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) for JSON Handling

### Create and Train your model
- Create macOS Playground
```swift
import Cocoa
import CreateML

//Specify the path to the DataSet
let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/User/Downloads/twitter-sanders-apple3.csv"))

//Devide the DataSet into TrainingData (80% of data) and TestingData (20%)
let(trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")


//if you wish to check the accuracy
let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")
let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

//Create MetaData for your model
let metadata = MLModelMetadata(author: "Marina", shortDescription: "A model trained to classify sentiment on Tweets", version: "1.0")

//Save the mlmodel to a file, specify the path and file's name
try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/User/Downloads/TweetSentimentClassifier.mlmodel"))

//if you wish to test manualy
try sentimentClassifier.prediction(from: "@Apple is a terrible company") // should return Negative
try sentimentClassifier.prediction(from: "I just found the best restaurant ever") // should return Positive
try sentimentClassifier.prediction(from: "I think @CocaCola ads are ok.") // should return Neutral
```

### Get Twitter API key
- Go to https://developer.twitter.com/
- Add your API key (```apiKey```) and API secret (```apiSecret```) in a new property list ```Secrets.plist```
