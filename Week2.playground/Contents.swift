//Codefellows - Week 2 - Jeff Jacka
//MARK: Monday

var sentence = "How many words are in this sentence?"
var arrayFromSentence = Array(sentence)

var wordCount = 0
for (index, element) in enumerate(arrayFromSentence) {
  print(element)
  if element == " " {
    wordCount++
  }
}

//Add One word for the end of the sentence
wordCount++

//Final word count
wordCount


//MARK: Tuesday
var testArray = ["Zero","One","Two","Three","Four","Five","Six","Seven", "Eight", "Nine","Ten"]

var returnArray : [String] = []

for (index, element) in enumerate(testArray) {
  if index % 2 == 0 {
    //number is even
  } else {
    returnArray.append(element)
  }
}

returnArray


//MARK: Wednesday
var counter = 0
var fibonacciArray : [Double] = [0,1]

while(fibonacciArray.count < 100){
  let newNumber = fibonacciArray[counter] + fibonacciArray[counter + 1]
  fibonacciArray.append(newNumber)
  counter++
}

fibonacciArray
fibonacciArray.count

//MARK: Thursday
func isPalindrome(testString : String) -> Bool {
  let reverseString = reverse(testString)
  
  if testString == reverseString {
    return true
  } else {
    return false
  }
}

let test1 = isPalindrome("kayak")
let test2 = isPalindrome("Jeff")
let test3 = isPalindrome("racecar")


