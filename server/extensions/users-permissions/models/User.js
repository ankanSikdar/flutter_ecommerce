require("dotenv").config();
const stripe = require("stripe")(process.env.KEY);

("use strict");

module.exports = {
  lifecycles: {
    async beforeCreate(model) {
      const customer = await stripe.customers.create({
        email: model.email,
      });
      model.customer_id = customer.id;
    },
  },
};
