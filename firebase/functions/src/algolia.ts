import * as functions from 'firebase-functions'
import * as algoliasearch from 'algoliasearch'

const ALGOLIA_ID = functions.config().algolia.app_id
const ALGOLIA_ADMIN_KEY = functions.config().algolia.api_key
const client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY);

const onDataCreated = functions.firestore.document('testData/{testDataId}').onCreate((snap, context) => {
  // Get the note document
  const testData = snap.data()!
  console.log(testData)

  // Add an 'objectID' field which Algolia requires
  testData.objectID = context.params.testDataId;

  // Write to the algolia index
  const index = client.initIndex("test")
  return index.saveObject(testData)
})

export { onDataCreated }