# Create Auth Key

In order to access the API, a client will need a consumer with a valid
authentication key. These can be created by using the [console].

1. Open the [console].
1. If the key is for a new client, create the consumer and note the id: 
  
   ```ruby
   consumer = DocumentTransfer::Model::Consumer.create(name: '<consumer name>')
   consumer.id
   ```
   
1. If the key is for an existing client, retrieve it using the id or name:

   ```ruby
   consumer = DocumentTransfer::Model::Consumer['<consumer id>']
   # OR
   consumer = DocumentTransfer::Model::Consumer.find(name: '<consumer name>')
   ```

1. Create the new key and note the key value. This is the _only_ time the key
   will be available in plain text, so be sure to grab it:

   ```ruby
   key = DocumentTransfer::Model::AuthKey.create(consumer:)
   key.plain_key
   ``` 
   
1. Save the consumer id and key in a secure location accessible by the client.
2. For information on how to use these values, see the [authentication
   documentation][auth].

[auth]: ../api/authentication.md
[console]: ../console.md
