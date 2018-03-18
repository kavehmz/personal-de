/* Triggered from a message on a Cloud Storage bucket.
 *
 * @param {!Object} event The Cloud Functions event.
 * @param {!Function} The callback function.
 */
const Storage = require('@google-cloud/storage');

exports.backupTerraformState = function(event, callback) {
  const storage = Storage();
  const file = event.data;
  const bucketNmae = event.data.bucket

  console.log(file.name);
  console.log(bucketNmae);

  var d = new Date();

  var patt = /^[a-zA-Z_\/-]*\.tfstate$/;
  
  if (file.name.match(patt)) {
    storage
    .bucket(file.bucket)
    .file(file.name)
    .copy(storage.bucket(bucketNmae).file("backup/" + file.name+ "-" + Math.round(Date.now() / 1000) ))
    .then(() => {
      console.log("copied");
    })
    .catch((err) => {
      console.error('ERROR:', err);
    });
  } else {
    console.log("not match:[" + file.name + "]");
    
  }

  callback();
};