const prisma = require("../config/prisma");
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

exports.payment = async (req, res) => {
  try {
    // Chack user
    // req.user.id
    // console.log("test", req.user.id);
    const cart = await prisma.cart.findFirst({
      where: {
        orderedById: req.user.id,
      },
    });
    const amountTHB = cart.cartTotal * 100;
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountTHB, //จำนวนเงิน
      currency: "thb",
      automatic_payment_methods: {
        enabled: true,
      },
    });

    // res.send("hellow payment");
    res.send({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Server Error" });
  }
};
