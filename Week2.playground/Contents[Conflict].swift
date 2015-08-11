//Codefellows - Week 2 - Jeff Jacka
//MARK: Monday

var sentence = "How many words are in this sentence and how about now?"
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
