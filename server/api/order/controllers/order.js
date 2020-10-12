require("dotenv").config();
const stripe = require("stripe")(process.env.KEY);

("use strict");

/**
 * Read the documentation (https://strapi.io/documentation/v3.x/concepts/controllers.html#core-controllers)
 * to customize this controller
 */

module.exports = {
  async create(ctx) {
    const { amount, products, customer, source } = ctx.request.body;
    const { email } = ctx.state.user;

    try {
      const intent = await stripe.paymentIntents.create({
        amount: Number(amount) * 100,
        currency: "inr",
        customer: customer,
        receipt_email: email,
        payment_method_types: ["card"],
      });

      const paymentIntent = await stripe.paymentIntents.confirm(intent.id, {
        payment_method: source,
      });
      console.log("PAYMENT: ", paymentIntent);

      ctx.send({
        amount: amount,
        created: Date.now(),
        products: JSON.parse(products),
      });
    } catch (error) {
      console.log("ERROR ", error);
      return error;
    }
  },
};
