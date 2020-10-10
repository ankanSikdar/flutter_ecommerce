require("dotenv").config();
const stripe = require("stripe")(process.env.KEY);

("use strict");

/**
 * A set of functions called "actions" for `card`
 */

module.exports = {
  index: async (ctx, next) => {
    const customerId = ctx.request.querystring;
    const customerData = await stripe.customers.retrieve(customerId);
    const cardData = customerData.sources.data;
    ctx.send(cardData);
  },
  add: async (ctx, next) => {
    const { customer, source } = ctx.request.body;
    // const card = await stripe.customers.createSource(customer, {
    //   source: source,
    // });
    const card = await stripe.paymentMethods.attach(source, {
      customer: customer,
    });
    ctx.send(card);
  },
};
