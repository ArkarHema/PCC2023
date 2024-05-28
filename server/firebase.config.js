const admin = require("firebase-admin");

// const bucket = admin.storage().bucket();

const handleNotification = async (title, body, token) => {
  try {
    const message = {
      notification: {
        title,
        body,
      },
      token,
    };
    await admin.messaging().send(message);
  } catch (err) {
    return;
  }
};

// const handlePhotoUpload = async (file, fileName) => {
//   let publicUrl;

//   try {
//     const metadata = {
//       metadata: {
//         firebaseStorageDownloadTokens: fileName,
//       },
//       contentType: file.mimetype,
//       cacheControl: "public, max-age=31536000",
//     };

//     const blob = bucket.file(fileName);
//     const blobStream = blob.createWriteStream({
//       metadata: metadata,
//       gzip: true,
//     });

//     await new Promise((resolve, reject) => {
//       blobStream.on("error", (err) => {
//         reject(err);
//       });

//       blobStream.on("finish", () => {
//         publicUrl = `https://firebasestorage.googleapis.com/v0/b/${
//           bucket.name
//         }/o/${encodeURI(blob.name)}?alt=media`;
//         resolve(publicUrl);
//       });

//       blobStream.end(file.buffer);
//     });

//     return publicUrl;
//   } catch (error) {
//     throw error;
//   }
// };

module.exports = { handleNotification };
