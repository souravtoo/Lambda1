exports.handler =  async function(event, context) {
    const term = event.term
    const loanAmount = event.principal
    const yearlyRate = event.rate
    const detailed = event.detailed
    
    const monthlyRate = yearlyRate / 12 / 100
    const interestPayment = monthlyRate * loanAmount
    const rateMultiplier = 1 + monthlyRate
    const numPayments = term * 12
    const totalPayment = interestPayment / (1 - Math.pow(rateMultiplier, -numPayments))
    const principalPayment = totalPayment - interestPayment

    if ( !detailed ) {
        console.log(loanAmount + ":" + monthlyRate + ":" + totalPayment)
      return JSON.stringify(getPayment(loanAmount, monthlyRate, totalPayment))
    }
    
    var result = {
        term: term,
        loanAmount: loanAmount,
        payment: totalPayment,
        rate: yearlyRate,
        totalPaid: 0,
        interestPaid: 0,
        payments: []
    }

    var principal = loanAmount
    while ( principal > 0 ) {
        var payment = getPayment(principal, monthlyRate, totalPayment)
        result.payments.push(payment)
        result.totalPaid += payment.totalPayment
        result.interestPaid += payment.interestPayment
        principal -= payment.principalPayment
    }
    return JSON.stringify(result)
}

var getPayment = function(principal, monthlyRate, totalPayment) {
    var result = {}
    result.interestPayment = principal * monthlyRate
    result.principalPayment = totalPayment - result.interestPayment
    if ( result.principalPayment > principal ) {
        result.principalPayment = principal
    }
    result.totalPayment = result.principalPayment + result.interestPayment
    return result
}