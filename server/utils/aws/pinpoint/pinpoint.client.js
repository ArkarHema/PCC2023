const {
  SendMessagesCommand,
  PinpointClient,
} = require("@aws-sdk/client-pinpoint");
// Configure AWS SDK with your credentials and region

const pinpoint = new PinpointClient();

// Specify the message content, including the OTP

module.exports = { pinpoint };
