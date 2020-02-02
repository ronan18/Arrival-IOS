var helloWorld = 'Hello World!'
function getToStations(netJSON, day, hour, fromStation) {
  if (brain) {
    console.log(netJSON, day, hour, fromStation, 'brain ai js console')

    let testingLogs = {
      net: netJSON,
      day: day,
      hour: hour,
      station: fromStation,
      key: 'brain ai js console'
    }

    const net = new brain.NeuralNetwork()
    net.fromJSON(netJSON)
    let resultsArray = []
    let resultStations = []
    let result = net.run({
      day: day / 10,
      hour: hour / 100,
      [fromStation]: 1
    })

    return testingLogs
  } else {
    return { error: 'no brain' }
  }
}
