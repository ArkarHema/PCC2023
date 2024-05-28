const { SendMessagesCommand } = require("@aws-sdk/client-pinpoint");
const { pinpoint } = require("./pinpoint.client");

require("dotenv").config();

exports.sendOtp = (phoneNumber, otp) => {
  const message = {
    ApplicationId: process.env.AWS_PINPOINT_APPLICATION_ID, // Replace with your Pinpoint Application ID
    MessageRequest: {
      Addresses: {
        [phoneNumber]: {
          ChannelType: "SMS", // You can also use 'EMAIL' for email OTPs
        },
      },
      MessageConfiguration: {
        SMSMessage: {
          Body: `Your OTP is ${otp}`, // Replace with the generated OTP
          MessageType: "TRANSACTIONAL", // You can use TRANSACTIONAL or PROMOTIONAL
        },
      },
    },
  };

  const command = new SendMessagesCommand(message);

  pinpoint.send(command);
};

// sendOtp("+919677728298"); // Replace with your phone number
