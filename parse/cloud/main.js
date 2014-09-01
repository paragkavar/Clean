var twilio = require('twilio')('ACc0acdf522b4fed35aa8cf13c5848f2d9', 'c7d84a16cb070112709ee315eef29c4d');
Parse.Cloud.define("verifyNum", function(request, response) {
	twilio.sendSms({
  	to: request.params.number, 
  	from: '+16149074531',
  	body: request.params.message
  },{
    success: function(httpResponse) {
      response.success(httpResponse.message);
    },
    error: function(httpResponse) {
      response.error(httpResponse.message);
    }
  });
});

var Stripe = require('stripe');
Stripe.initialize('sk_test_h9iZDE3lsGOK4uBrmnS5rYxX');

Parse.Cloud.define("createCustomer", function(request, response) {   
  Stripe.Customers.create({
    account_balance: 0,
    description: request.params.phoneNumber,
    card: request.params.token
  }, {
    success: function(httpResponse) {
      response.success(httpResponse.id);
    },
    error: function(httpResponse) {
      response.error(httpResponse.message);
    }
  });
});

Parse.Cloud.define("createSubscription", function(request, response) {
  Stripe.Subscriptions.create(request.params.customer, {
    plan: request.params.plan
  }, {
    success: function(httpResponse) {
      response.success(httpResponse.id);
    },
    error: function(httpResponse) {
      response.error(httpResponse.message);
    }
  });
});

// Parse.Cloud.define("costCalc", function(request, response) {
//   var bedrooms = request.params.bedrooms;
//   var bathrooms = request.params.bathrooms;
//   var visits = request.params.visits;
//   var cost = (bedrooms + bathrooms)*10*visits;
//   response.success(cost);
// });