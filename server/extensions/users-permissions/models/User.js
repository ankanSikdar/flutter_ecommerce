const axios = require("axios");

("use strict");

module.exports = {
  lifecycles: {
    async beforeCreate(data) {
      const cart = await axios.post("http://192.168.1.5:1337/carts");
      data.cart_id = cart.data.id;
    },
  },
};
