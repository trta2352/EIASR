//Approach 1
import CreateML
import Foundation

// Get the path of training images directory
let trainingImagesDirectoryPath = URL(fileURLWithPath: "/Users/jakatertinek/desktop/apps/EIASR/model/training")
print(trainingImagesDirectoryPath)

//Let's train the model with training images
let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainingImagesDirectoryPath))

// Get the path of test images directory
let testImagesDirectoryPath = URL(fileURLWithPath: "/Users/jakatertinek/desktop/apps/EIASR/model/test")
print(testImagesDirectoryPath)

// Let's evaluate the trained model :)
let evaluation = model.evaluation(on: .labeledDirectories(at: testImagesDirectoryPath))

//Save the model at spcific path
try model.write(to: URL(fileURLWithPath: "/Users/jakatertinek/desktop/apps/EIASR/model"))

